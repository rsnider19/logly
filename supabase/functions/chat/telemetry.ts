/**
 * Telemetry persistence module for chat observability.
 *
 * Captures all metrics from AI chat interactions for cost, quality,
 * and performance monitoring. Uses service_role key to bypass RLS.
 *
 * Design decisions (per CONTEXT.md):
 *   - Fire-and-forget persistence (never blocks or throws)
 *   - Service role only writes (no user access)
 *   - All timing/token fields nullable for partial failures
 *   - sql_fingerprint computed by database trigger (not here)
 */

import { createClient } from "npm:@supabase/supabase-js";

// Use service_role for server-side writes (bypasses RLS)
const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

/**
 * Telemetry record for a single chat interaction.
 * All timing and token fields are optional for partial failures.
 */
export interface TelemetryRecord {
  // Identifiers
  userId: string;
  conversationId?: string;
  responseId?: string;

  // Content captured
  userQuestion: string;
  aiResponse?: string;
  generatedSql?: string;
  resultRowCount?: number;
  followUpSuggestions?: string[];

  // Error tracking
  errorType?: string;
  errorMessage?: string;
  failedStep?: string;

  // Flags
  isOffTopic: boolean;

  // Model tracking
  sqlModel?: string;
  responseModel?: string;

  // Timing (milliseconds)
  nlToSqlDurationMs?: number;
  sqlExecutionDurationMs?: number;
  responseGenerationDurationMs?: number;
  ttfbMs?: number;

  // Token tracking: SQL generation step
  sqlInputTokens?: number;
  sqlOutputTokens?: number;
  sqlCachedTokens?: number;

  // Token tracking: Response generation step
  responseInputTokens?: number;
  responseOutputTokens?: number;
  responseCachedTokens?: number;
}

/**
 * Persists telemetry record to the database.
 *
 * This function is fire-and-forget: it logs errors but never throws.
 * Telemetry persistence should not affect the user's chat experience.
 *
 * Note: sql_fingerprint is computed by a database trigger, not here.
 */
export async function persistTelemetry(record: TelemetryRecord): Promise<void> {
  try {
    const { error } = await supabaseAdmin.from("chat_telemetry_log").insert({
      // Identifiers
      user_id: record.userId,
      conversation_id: record.conversationId,
      response_id: record.responseId,

      // Content captured
      user_question: record.userQuestion,
      ai_response: record.aiResponse,
      generated_sql: record.generatedSql,
      // sql_fingerprint computed by trigger
      result_row_count: record.resultRowCount,
      follow_up_suggestions: record.followUpSuggestions,

      // Error tracking
      error_type: record.errorType,
      error_message: record.errorMessage,
      failed_step: record.failedStep,

      // Flags
      is_off_topic: record.isOffTopic,

      // Model tracking
      sql_model: record.sqlModel,
      response_model: record.responseModel,

      // Timing (milliseconds)
      nl_to_sql_duration_ms: record.nlToSqlDurationMs,
      sql_execution_duration_ms: record.sqlExecutionDurationMs,
      response_generation_duration_ms: record.responseGenerationDurationMs,
      ttfb_ms: record.ttfbMs,

      // Token tracking: SQL generation step
      sql_input_tokens: record.sqlInputTokens,
      sql_output_tokens: record.sqlOutputTokens,
      sql_cached_tokens: record.sqlCachedTokens,

      // Token tracking: Response generation step
      response_input_tokens: record.responseInputTokens,
      response_output_tokens: record.responseOutputTokens,
      response_cached_tokens: record.responseCachedTokens,
    });

    if (error) {
      console.error("[Telemetry] Failed to persist log:", error);
      // Non-fatal - don't throw, telemetry should not break the main flow
    }
  } catch (err) {
    console.error("[Telemetry] Unexpected error:", err);
    // Non-fatal - swallow all errors
  }
}
