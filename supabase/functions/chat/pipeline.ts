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
import { generateStreamingResponse } from "./responseGenerator.ts";

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
  const { query, userId, previousConversionId } = input;
  const progress = createProgressStream();

  // Run pipeline asynchronously -- the Response is returned immediately
  (async () => {
    try {
      const hashedUser = await hashUserId(userId);

      // ============================================
      // Sanitize input (no user-visible step)
      // ============================================
      const sanitizedQuery = sanitizeUserInput(query);

      // ============================================
      // Step 1: "Understanding your question..."
      // Covers: NL-to-SQL generation + SQL validation
      // ============================================
      progress.sendStep(STEP_NAMES.UNDERSTANDING, "start");

      let sqlResult;
      try {
        sqlResult = await generateSQL({
          query: sanitizedQuery,
          userId,
          previousConversionId,
        });
      } catch (err) {
        console.error("[Pipeline] NL-to-SQL generation failed:", err);
        progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");
        progress.sendError(
          "I had trouble understanding your question. Could you try rephrasing it?",
        );
        return;
      }

      // Handle off-topic questions
      if (sqlResult.parsed.offTopic) {
        progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");
        // Send the redirect message as a text_delta so it appears as a chat message
        progress.sendTextDelta(sqlResult.parsed.redirectMessage);
        progress.sendConversionId(sqlResult.conversionId);
        progress.sendDone();
        return;
      }

      // SQL validation (silent -- no user-visible step event)
      const validation = validateSqlQuery(sqlResult.parsed.sqlQuery);
      if (!validation.valid) {
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

      progress.sendConversionId(sqlResult.conversionId);
      progress.sendStep(STEP_NAMES.UNDERSTANDING, "complete");

      // ============================================
      // Step 2: "Looking up your data..."
      // Covers: RLS-enforced SQL execution
      // ============================================
      progress.sendStep(STEP_NAMES.LOOKING_UP, "start");

      let queryResult;
      try {
        queryResult = await executeWithRLS(
          sqlResult.parsed.sqlQuery,
          userId,
        );
      } catch (err) {
        console.error("[Pipeline] Query execution failed:", err);
        progress.sendStep(STEP_NAMES.LOOKING_UP, "complete");
        progress.sendError(
          "I ran into an issue looking up your data. Could you try again?",
        );
        return;
      }

      progress.sendStep(STEP_NAMES.LOOKING_UP, "complete");

      // ============================================
      // Response streaming (no spinner -- direct text)
      // ============================================
      try {
        const { responseId } = await generateStreamingResponse({
          query: sanitizedQuery,
          rows: queryResult.rows,
          truncated: queryResult.truncated,
          conversionId: sqlResult.conversionId,
          hashedUserId: hashedUser,
          onTextDelta: (delta) => progress.sendTextDelta(delta),
        });

        progress.sendResponseId(responseId);
        progress.sendDone();
      } catch (err) {
        console.error("[Pipeline] Response generation failed:", err);
        progress.sendError(
          "I had trouble putting together your answer. Could you try again?",
        );
      }
    } catch (err) {
      // Catch-all for unexpected errors
      console.error("[Pipeline] Unexpected error:", err);
      progress.sendError(
        "Something unexpected happened. Could you try again?",
      );
    } finally {
      progress.close();
    }
  })();

  return new Response(progress.stream, {
    headers: createSSEHeaders(),
  });
}
