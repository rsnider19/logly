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
import { FOLLOW_UP_MARKER } from "./prompts.ts";
import {
  getOrCreateConversation,
  saveUserMessage,
  saveAssistantMessage,
  updateConversationIds,
  getConversationContext,
} from "./persistence.ts";

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
        completedStepNames.push(STEP_NAMES.UNDERSTANDING);
        // Send the redirect message as a text_delta so it appears as a chat message
        progress.sendTextDelta(sqlResult.parsed.redirectMessage);
        progress.sendConversionId(sqlResult.conversionId);

        // Save off-topic response to conversation
        if (conversationId) {
          await saveAssistantMessage(
            conversationId,
            sqlResult.parsed.redirectMessage,
            { steps: completedStepNames }
          );
          await updateConversationIds(
            conversationId,
            undefined,
            sqlResult.conversionId
          );
        }

        progress.sendDone(conversationId!);
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
      completedStepNames.push(STEP_NAMES.UNDERSTANDING);

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
      completedStepNames.push(STEP_NAMES.LOOKING_UP);

      // ============================================
      // Response streaming (no spinner -- direct text)
      // Uses buffering to prevent follow-up marker from appearing in stream
      // ============================================
      try {
        let fullResponseText = "";
        // Buffer to hold text that might contain start of marker
        let buffer = "";
        // Max length of marker prefix to buffer (length of "<!-- FOLLOW_UPS:")
        const MARKER_PREFIX_LEN = FOLLOW_UP_MARKER.length;
        // Flag to stop streaming once marker is detected
        let markerDetected = false;

        const { responseId } = await generateStreamingResponse({
          query: sanitizedQuery,
          rows: queryResult.rows,
          truncated: queryResult.truncated,
          conversionId: sqlResult.conversionId,
          hashedUserId: hashedUser,
          onTextDelta: (delta) => {
            fullResponseText += delta;

            // If marker already detected, don't stream anything more
            if (markerDetected) return;

            // Add delta to buffer
            buffer += delta;

            // Check if buffer contains the start of the marker
            const markerStart = buffer.indexOf(FOLLOW_UP_MARKER);
            if (markerStart !== -1) {
              // Marker found - emit everything before it, then stop streaming
              markerDetected = true;
              const cleanText = buffer.slice(0, markerStart);
              if (cleanText) progress.sendTextDelta(cleanText);
              buffer = ""; // Clear buffer (rest is follow-up data)
              return;
            }

            // Check if buffer might have partial marker at end
            // Look for any prefix of FOLLOW_UP_MARKER at the end of buffer
            let safeLength = buffer.length;
            for (let i = 1; i <= Math.min(buffer.length, MARKER_PREFIX_LEN); i++) {
              const suffix = buffer.slice(-i);
              if (FOLLOW_UP_MARKER.startsWith(suffix)) {
                safeLength = buffer.length - i;
                break;
              }
            }

            // Emit safe portion, keep potential marker prefix in buffer
            if (safeLength > 0) {
              const safeText = buffer.slice(0, safeLength);
              progress.sendTextDelta(safeText);
              buffer = buffer.slice(safeLength);
            }
          },
        });

        // Emit any remaining buffered text (if no marker was found)
        if (!markerDetected && buffer) {
          progress.sendTextDelta(buffer);
        }

        progress.sendResponseId(responseId);

        // Extract follow-up suggestions from accumulated response text
        const followUps = extractFollowUpSuggestions(fullResponseText);

        // Save AI response to database (clean content without follow-up marker)
        const cleanContent = fullResponseText
          .replace(/<!-- FOLLOW_UPS:.*-->/, "")
          .trim();
        if (conversationId) {
          await saveAssistantMessage(conversationId, cleanContent, {
            followUpSuggestions: followUps.length > 0 ? followUps : undefined,
            steps:
              completedStepNames.length > 0 ? completedStepNames : undefined,
          });

          // Update conversation with latest IDs for follow-up chaining
          await updateConversationIds(
            conversationId,
            responseId,
            sqlResult.conversionId
          );
        }

        progress.sendDone(conversationId!, followUps);
      } catch (err) {
        console.error("[Pipeline] Response generation failed:", err);
        progress.sendError(
          "I had trouble putting together your answer. Could you try again?"
        );
      }
    } catch (err) {
      // Catch-all for unexpected errors
      console.error("[Pipeline] Unexpected error:", err);
      progress.sendError(
        "Something unexpected happened. Could you try again?"
      );
    } finally {
      progress.close();
    }
  })();

  return new Response(progress.stream, {
    headers: createSSEHeaders(),
  });
}

// ============================================================
// Helpers
// ============================================================

/**
 * Extracts follow-up suggestions from the response text.
 * Looks for: <!-- FOLLOW_UPS: ["...", "..."] -->
 */
function extractFollowUpSuggestions(text: string): string[] {
  const startIdx = text.indexOf(FOLLOW_UP_MARKER);
  if (startIdx === -1) return [];

  const endIdx = text.indexOf("-->", startIdx);
  if (endIdx === -1) return [];

  const jsonStr = text.slice(startIdx + FOLLOW_UP_MARKER.length, endIdx).trim();
  try {
    const parsed = JSON.parse(jsonStr);
    if (Array.isArray(parsed) && parsed.every((s) => typeof s === "string")) {
      return parsed.slice(0, 3); // Max 3 suggestions
    }
  } catch {
    console.warn("[Pipeline] Failed to parse follow-up suggestions:", jsonStr);
  }
  return [];
}
