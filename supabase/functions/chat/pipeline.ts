/**
 * Pipeline orchestrator for the chat edge function.
 *
 * Wires together all pipeline steps in sequence:
 * 1. Sanitize user input (prompt injection defense)
 * 2. Generate SQL from natural language (Call 1: NL-to-SQL)
 * 3. Validate generated SQL (silent -- no user-visible step)
 * 4. Execute SQL with RLS enforcement
 * 5. Stream friendly response from results (Call 2: response generation)
 *
 * User-visible progress steps (2 total):
 * - "Understanding your question..." (covers NL-to-SQL + validation)
 * - "Looking up your data..." (covers SQL execution)
 * - Response streaming has no step -- transitions directly to text deltas
 *
 * SSE events emitted:
 * - step (start/complete pairs)
 * - text_delta (token-by-token response)
 * - response_id (for follow-up response chaining)
 * - conversion_id (for follow-up SQL context chaining)
 * - error (user-friendly error messages)
 * - done (completion signal)
 */

import { createProgressStream, createSSEHeaders } from "./streamHandler.ts";
import { sanitizeUserInput, validateSqlQuery } from "./security.ts";
import { generateSQL, hashUserId } from "./sqlGenerator.ts";
import { executeWithRLS } from "./queryExecutor.ts";
import {
  generateStreamingResponse,
  generateFollowUpSuggestions,
} from "./responseGenerator.ts";
import {
  getOrCreateConversation,
  saveUserMessage,
  saveAssistantMessage,
  updateConversationIds,
  getConversationContext,
} from "./persistence.ts";
import { persistTelemetry, TelemetryRecord } from "./telemetry.ts";

// ============================================================
// Types
// ============================================================

/**
 * Input to the pipeline from the edge function entry point.
 */
export interface PipelineInput {
  query: string;
  userId: string;
  previousResponseId?: string;
  previousConversionId?: string;
  conversationId?: string;
}

// ============================================================
// Step Labels
// ============================================================

/** User-visible step labels (friendly, casual tone). */
const STEP_NAMES = {
  UNDERSTANDING: "Understanding your question...",
  LOOKING_UP: "Looking up your data...",
} as const;

// ============================================================
// Pipeline
// ============================================================

/**
 * Runs the complete NL-to-SQL pipeline with SSE streaming progress.
 *
 * Returns a Response with an SSE stream body immediately. The pipeline
 * executes asynchronously in the background, emitting events as it progresses.
 *
 * @param input - User query, userId, and optional follow-up context IDs
 * @returns HTTP Response with SSE stream body
 */
export function runPipeline(input: PipelineInput): Response {
  const {
    query,
    userId,
    previousConversionId: inputPreviousConversionId,
    conversationId: inputConversationId,
  } = input;
  const progress = createProgressStream();

  // Run pipeline asynchronously -- the Response is returned immediately
  (async () => {
    // Telemetry: timing capture
    const requestStart = performance.now();
    let firstTextTime: number | null = null;

    // Initialize telemetry record with known values
    const telemetry: Partial<TelemetryRecord> = {
      userId,
      userQuestion: query,
    };

    // Persistence: conversation ID resolved early for tracking
    let conversationId: string | undefined;
    // Completed steps tracked for message metadata
    const completedStepNames: string[] = [];

    try {
      const hashedUser = await hashUserId(userId);

      // ============================================
      // Get or create conversation (backend owns persistence)
      // ============================================
      conversationId = await getOrCreateConversation(
        userId,
        query,
        inputConversationId
      );
      telemetry.conversationId = conversationId;

      // Save user message before processing
      await saveUserMessage(conversationId, query);

      // If continuing conversation, load context for follow-up chaining
      let previousConversionId = inputPreviousConversionId;
      if (inputConversationId && !inputPreviousConversionId) {
        const context = await getConversationContext(
          inputConversationId,
          userId
        );
        if (context?.lastConversionId) {
          previousConversionId = context.lastConversionId;
        }
      }

      // ============================================
      // Sanitize input (no user-visible step)
      // ============================================
      const sanitizedQuery = sanitizeUserInput(query);

      // ============================================
      // Step 1: "Understanding your question..."
      // Covers: NL-to-SQL generation + SQL validation
      // ============================================
      progress.sendStep(STEP_NAMES.UNDERSTANDING, "start");

      // Generate current date in ISO format for NL-to-SQL context
      // This helps the model correctly interpret relative date references
      // like "last month", "September", "this week", etc.
      const currentDate = new Date().toISOString().split("T")[0]; // "YYYY-MM-DD"

      let sqlResult;
      const sqlStart = performance.now();
      try {
        sqlResult = await generateSQL({
          query: sanitizedQuery,
          userId,
          currentDate,
          previousConversionId,
        });
        telemetry.nlToSqlDurationMs = Math.round(performance.now() - sqlStart);
        telemetry.sqlModel = "gpt-4o-mini";
        telemetry.sqlInputTokens = sqlResult.usage.inputTokens;
        telemetry.sqlOutputTokens = sqlResult.usage.outputTokens;
        telemetry.sqlCachedTokens = sqlResult.usage.cachedTokens;
      } catch (err) {
        telemetry.nlToSqlDurationMs = Math.round(performance.now() - sqlStart);
        telemetry.errorType = "sql_generation";
        telemetry.errorMessage = String(err);
        telemetry.failedStep = "understanding";
        console.error("[Pipeline] NL-to-SQL generation failed:", err);
        progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");
        progress.sendError(
          "I had trouble understanding your question. Could you try rephrasing it?",
        );
        return;
      }

      // SQL validation (silent -- no user-visible step event)
      const validation = validateSqlQuery(sqlResult.parsed.sqlQuery);
      if (!validation.valid) {
        telemetry.errorType = "sql_validation";
        telemetry.errorMessage = validation.error ?? "Invalid SQL generated";
        telemetry.failedStep = "understanding";
        telemetry.generatedSql = sqlResult.parsed.sqlQuery;
        console.error(
          `[Pipeline] SQL validation failed: ${validation.error}`,
          `SQL: ${sqlResult.parsed.sqlQuery}`,
        );
        progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");
        progress.sendError(
          "I generated a query that doesn't look safe. Could you try a different question?",
        );
        return;
      }

      // Capture generated SQL after validation succeeds
      telemetry.generatedSql = sqlResult.parsed.sqlQuery;

      progress.sendConversionId(sqlResult.conversionId);
      progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");
      completedStepNames.push(STEP_NAMES.UNDERSTANDING);

      // ============================================
      // Step 2: "Looking up your data..."
      // Covers: RLS-enforced SQL execution
      // ============================================
      progress.sendStep(STEP_NAMES.LOOKING_UP, "start");

      let queryResult;
      const execStart = performance.now();
      try {
        queryResult = await executeWithRLS(
          sqlResult.parsed.sqlQuery,
          userId,
        );
        telemetry.sqlExecutionDurationMs = Math.round(performance.now() - execStart);
        telemetry.resultRowCount = queryResult.rows.length;
      } catch (err) {
        telemetry.sqlExecutionDurationMs = Math.round(performance.now() - execStart);
        telemetry.errorType = "sql_execution";
        telemetry.errorMessage = String(err);
        telemetry.failedStep = "looking_up";
        console.error("[Pipeline] Query execution failed:", err);
        progress.sendStep(STEP_NAMES.LOOKING_UP, "complete");
        progress.sendError(
          "I ran into an issue looking up your data. Could you try again?",
        );
        return;
      }

      progress.sendStep(STEP_NAMES.LOOKING_UP, "complete");
      completedStepNames.push(STEP_NAMES.LOOKING_UP);

      // ============================================
      // Response streaming (no spinner -- direct text)
      // ============================================
      const respStart = performance.now();
      try {
        let fullResponseText = "";

        const { responseId, usage: responseUsage } = await generateStreamingResponse({
          query: sanitizedQuery,
          rows: queryResult.rows,
          truncated: queryResult.truncated,
          conversionId: sqlResult.conversionId,
          hashedUserId: hashedUser,
          onTextDelta: (delta) => {
            fullResponseText += delta;

            // Capture first text time for TTFB
            if (firstTextTime === null) {
              firstTextTime = performance.now();
            }

            // Stream directly to client
            progress.sendTextDelta(delta);
          },
        });

        // Capture response generation telemetry
        telemetry.responseGenerationDurationMs = Math.round(performance.now() - respStart);
        telemetry.ttfbMs = firstTextTime !== null
          ? Math.round(firstTextTime - requestStart)
          : null;
        telemetry.responseModel = "gpt-4o-mini";
        telemetry.responseInputTokens = responseUsage.inputTokens;
        telemetry.responseOutputTokens = responseUsage.outputTokens;
        telemetry.responseCachedTokens = responseUsage.cachedTokens;
        telemetry.responseId = responseId;

        progress.sendResponseId(responseId);

        // Send done immediately so the client can finalize the message
        progress.sendDone(conversationId!);

        // Update conversation IDs immediately for follow-up chaining
        if (conversationId) {
          await updateConversationIds(
            conversationId,
            responseId,
            sqlResult.conversionId
          );
        }

        // Generate follow-up suggestions in a separate call
        const followUps = await generateFollowUpSuggestions({
          question: sanitizedQuery,
          response: fullResponseText,
          hashedUserId: hashedUser,
        });

        // Send suggestions to client (arrives after done)
        progress.sendFollowUpSuggestions(followUps);

        // Capture final telemetry fields
        telemetry.aiResponse = fullResponseText;
        telemetry.followUpSuggestions = followUps.length > 0 ? followUps : undefined;
        if (conversationId) {
          await saveAssistantMessage(conversationId, fullResponseText, {
            followUpSuggestions: followUps.length > 0 ? followUps : undefined,
            steps:
              completedStepNames.length > 0 ? completedStepNames : undefined,
          });
        }
      } catch (err) {
        telemetry.responseGenerationDurationMs = Math.round(performance.now() - respStart);
        telemetry.errorType = "response_generation";
        telemetry.errorMessage = String(err);
        telemetry.failedStep = "response";
        console.error("[Pipeline] Response generation failed:", err);
        progress.sendError(
          "I had trouble putting together your answer. Could you try again?"
        );
      }
    } catch (err) {
      // Catch-all for unexpected errors
      telemetry.errorType = "unexpected";
      telemetry.errorMessage = String(err);
      console.error("[Pipeline] Unexpected error:", err);
      progress.sendError(
        "Something unexpected happened. Could you try again?"
      );
    } finally {
      progress.close();
      // Fire-and-forget telemetry persistence
      persistTelemetry(telemetry as TelemetryRecord).catch((e) =>
        console.error("[Pipeline] Telemetry persistence failed:", e)
      );
    }
  })();

  return new Response(progress.stream, {
    headers: createSSEHeaders(),
  });
}

