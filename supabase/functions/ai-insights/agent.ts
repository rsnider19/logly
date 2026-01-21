/**
 * NL-to-SQL Agent Pipeline using OpenAI Responses API
 *
 * A linear pipeline that converts natural language to SQL, executes the query,
 * and generates a friendly streaming response with follow-up question support.
 *
 * Pipeline stages:
 * 1. NL → SQL conversion (LLM)
 * 2. SQL validation (regex-based security)
 * 3. SQL execution (database query with row limit)
 * 4. Response generation (LLM with streaming)
 */

import { Client } from "jsr:@db/postgres";
import OpenAI from "npm:openai@4.103.0";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { NL_TO_SQL_INSTRUCTIONS } from "./schema.ts";
import { validateSqlQuery } from "./security.ts";

import {
  createProgressStream,
  createSSEHeaders,
  DB_STEP_NAMES,
  STEP_NAMES,
} from "./streamHandler.ts";
import { z } from "npm:zod";

// Supabase client for logging (uses service role for RLS bypass)
const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SB_SECRET")!,
);

// Maximum rows to return from queries
const MAX_ROWS = 20;

// TODO: Configure your preferred OpenAI model here
// Consider using a fine-tuned model for better accuracy
const NL_TO_SQL_MODEL = "ft:gpt-4.1-mini-2025-04-14:logly-llc::CwW7bj3O";
const RESPONSE_MODEL = "gpt-4.1-mini";

/**
 * Hashes the user ID for OpenAI's abuse detection.
 * This allows OpenAI to track per-user patterns without exposing raw IDs.
 */
async function hashUserId(userId: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(userId);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

/**
 * Pipeline input parameters
 */
export interface PipelineInput {
  query: string;
  userId: string;
  previousResponseId?: string; // For follow-up questions (Friendly Agent)
  previousConversionId?: string; // For follow-up SQL generation (SQL Agent)
}

/**
 * Pipeline result containing response ID for follow-ups
 */
export interface PipelineResult {
  responseId: string;
}

/**
 * Token usage from OpenAI API
 */
interface TokenUsage {
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
}

/**
 * Result from NL-to-SQL conversion
 */
interface ConversionResult {
  sql: string;
  responseId: string;
  usage: TokenUsage;
}

/**
 * Result from response generation
 */
interface ResponseResult {
  fullResponse: string;
  responseId: string;
  usage: TokenUsage;
}

/**
 * Step log for debugging persistence
 */
interface StepLog {
  stepName: string;
  input: unknown;
  output: unknown;
  usage?: TokenUsage;
  durationMs: number;
}

/**
 * Persists insight and step logs to the database for debugging.
 */
async function persistInsight(
  userId: string,
  query: string,
  responseId: string,
  conversionId: string,
  previousResponseId: string | undefined,
  previousConversionId: string | undefined,
  steps: StepLog[],
): Promise<void> {
  try {
    // Insert main insight record
    const { data: insight, error: insightError } = await supabase
      .from("user_ai_insight")
      .insert({
        user_id: userId,
        user_query: query,
        openai_response_id: responseId,
        openai_conversion_id: conversionId,
        previous_response_id: previousResponseId,
        previous_conversion_id: previousConversionId,
        // Legacy columns - populate from steps
        nl_to_sql_resp: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.CONVERTING
        )?.output ?? {},
        nl_to_sql_timing_ms: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.CONVERTING
        )?.durationMs ?? 0,
        query_results: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.EXECUTING
        )?.output ?? {},
        query_timing_ms: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.EXECUTING
        )?.durationMs ?? 0,
        friendly_answer_resp: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.RESPONDING
        )?.output ?? {},
        friendly_answer_timing_ms: steps.find((s) =>
          s.stepName === DB_STEP_NAMES.RESPONDING
        )?.durationMs ??
          0,
      })
      .select("user_ai_insight_id")
      .single();

    if (insightError) {
      console.error("[Persist] Failed to insert insight:", insightError);
      return;
    }

    // Insert step records
    const stepRecords = steps.map((step) => ({
      insight_id: insight.user_ai_insight_id,
      step_name: step.stepName,
      input_context: step.input,
      output_result: step.output,
      token_usage: step.usage
        ? {
          prompt: step.usage.promptTokens,
          completion: step.usage.completionTokens,
          total: step.usage.totalTokens,
        }
        : null,
      duration_ms: step.durationMs,
    }));

    const { error: stepsError } = await supabase
      .from("user_ai_insight_step")
      .insert(stepRecords);

    if (stepsError) {
      console.error("[Persist] Failed to insert steps:", stepsError);
    } else {
      console.log(`[Persist] ✅ Logged insight with ${steps.length} steps`);
    }
  } catch (err) {
    console.error("[Persist] Unexpected error:", err);
  }
}

/**
 * Converts natural language to SQL using OpenAI Responses API.
 *
 * TODO: Replace with fine-tuned model ID for better accuracy
 * TODO: Adjust temperature based on observed behavior
 */
async function convertToSql(
  openai: OpenAI,
  query: string,
  userId: string,
  hashedUserId: string,
  previousResponseId?: string,
): Promise<ConversionResult> {
  const userInput =
    `${query} [user_id: ${userId}] (Output raw JSON only. Start response with {)`;

  const SqlQuery = z.object({
    sqlQuery: z.string().describe("The SQL query to execute"),
  });

  // Manual schema to prevent "type: string" error from helper
  const apiSchema = {
    type: "json_schema" as const,
    name: "sql_query",
    strict: false, // Strict mode conflicts with text-based history from Friendly Agent
    schema: {
      type: "object",
      properties: {
        sqlQuery: {
          type: "string",
          description: "The SQL query to execute",
        },
      },
      required: ["sqlQuery"],
      additionalProperties: false,
    },
  };

  // Build the request with optional previous_response_id for follow-ups
  const response = await openai.responses.create({
    model: NL_TO_SQL_MODEL,
    instructions: NL_TO_SQL_INSTRUCTIONS,
    input: userInput,
    ...(previousResponseId && { previous_response_id: previousResponseId }),
    text: {
      format: apiSchema, // Use manual schema
    },
    temperature: 0.1, // Low temperature for consistent SQL generation
    store: true, // Store for follow-up context
    user: hashedUserId, // Hashed user ID for abuse detection
    // @ts-ignore: Responses API uses max_output_tokens
    max_output_tokens: 250,
  });

  const content = response.output_text;
  if (!content) {
    throw new Error("No response from NL-to-SQL model");
  }

  // Robustly find JSON object in case model adds extra text
  let jsonStr = content;
  // Use lazy match (*?) to capture only the FIRST JSON object if repeated
  const jsonMatch = content.match(/\{[\s\S]*?\}/);
  if (jsonMatch) {
    jsonStr = jsonMatch[0];
  }

  // Track usage locally to handle potential repairs
  const currentUsage: TokenUsage = {
    promptTokens: response.usage?.input_tokens ?? 0,
    completionTokens: response.usage?.output_tokens ?? 0,
    totalTokens: response.usage?.total_tokens ?? 0,
  };

  let parsed: { sqlQuery: string };
  try {
    parsed = SqlQuery.parse(JSON.parse(jsonStr));
  } catch (e) {
    console.warn(
      `[NL-to-SQL] ⚠️ JSON validation failed. Triggering retry logic... Error: ${e}`,
    );
    console.time("[NL-to-SQL] Retry Duration");

    // Self-correction attempt
    try {
      const repairResponse = await openai.responses.create({
        model: NL_TO_SQL_MODEL,
        input:
          `The previous response was invalid. Error: ${e}. Please return ONLY the raw JSON object for the SQL query, obeying the schema.`,
        previous_response_id: response.id,
        text: {
          format: apiSchema,
        },
        temperature: 0.1,
        store: true,
        user: hashedUserId,
      });

      const repairContent = repairResponse.output_text;
      if (!repairContent) throw new Error("No response from repair attempt");

      parsed = SqlQuery.parse(JSON.parse(repairContent));
      console.log(`[NL-to-SQL] Self-correction successful.`);
      console.timeEnd("[NL-to-SQL] Retry Duration");

      // Update usage to include the repair cost
      if (repairResponse.usage) {
        currentUsage.promptTokens += repairResponse.usage.input_tokens;
        currentUsage.completionTokens += repairResponse.usage.output_tokens;
        currentUsage.totalTokens += repairResponse.usage.total_tokens;
      }

      // Update response ID to the latest valid one
      response.id = repairResponse.id;
    } catch (repairError) {
      console.error(`[NL-to-SQL] Self-correction failed: ${repairError}`);
      throw new Error(
        `Failed to parse model response after repair attempt: ${e}`,
      );
    }
  }

  return {
    sql: parsed.sqlQuery,
    responseId: response.id,
    usage: currentUsage,
  };
}

/**
 * Executes SQL query with row limiting.
 */
async function executeQuery(
  sql: string,
): Promise<{ rows: unknown[]; truncated: boolean; originalRowCount: number }> {
  const client = new Client(Deno.env.get("SUPABASE_DB_URL"));
  await client.connect();

  try {
    const result = await client.queryObject(sql);
    const rows = result.rows;
    const originalRowCount = rows.length;
    const truncated = rows.length > MAX_ROWS;

    return {
      rows: truncated ? rows.slice(0, MAX_ROWS) : rows,
      truncated,
      originalRowCount,
    };
  } finally {
    await client.end();
  }
}

/**
 * System instructions for the friendly response generation.
 *
 * TODO: Customize tone and formatting preferences here
 * TODO: Add domain-specific formatting rules (e.g., duration in hours:minutes)
 */
const RESPONSE_INSTRUCTIONS = `
You are a friendly data analyst explaining activity data to users.

TONE:
- Uplifting and encouraging
- Positive but not childish
- Concise and clear (aim for under 150 words unless detail is requested)

RULES:
- Never mention SQL, queries, or technical details
- Never expose user IDs or database IDs
- Use Markdown for formatting when helpful
- If data is empty, acknowledge gracefully and suggest the user may not have logged that activity yet
- Bold important numbers and activity names
- For follow-up questions, reference previous context naturally
- Keep your response concise and to the point.
- DURATION FORMATTING: Always return durations in the most readable format:
  - Long durations: "X hours, Y minutes, Z seconds"
  - Medium durations: "X minutes, Y seconds"
  - Short durations: "X seconds"
  - Choose the granularity that makes the most sense for the value.
`.trim();

/**
 * Generates a friendly streaming response using OpenAI Responses API.
 *
 * @param openai - OpenAI client
 * @param query - Original user question
 * @param rows - Query result rows
 * @param previousResponseId - Previous response ID for follow-up context
 * @param sendText - Function to send text deltas
 * @returns The full response text, response ID, and token usage
 */
async function generateStreamingResponse(
  openai: OpenAI,
  query: string,
  rows: unknown[],
  truncated: boolean,
  previousResponseId: string,
  hashedUserId: string,
  sendText: (delta: string) => void,
): Promise<ResponseResult> {
  /* Helper to convert JSON rows to CSV to save tokens */
  function jsonToCsv(data: unknown[]): string {
    if (!data || data.length === 0) return "";
    const items = data as Record<string, unknown>[];
    const headers = Object.keys(items[0]);
    const csvRows = items.map((row) =>
      headers.map((header) => {
        const val = row[header];
        if (typeof val === "string") {
          // Escape quotes and wrap in quotes if necessary
          return `"${val.replace(/"/g, '""')}"`;
        }
        return String(val);
      }).join(",")
    );
    return [headers.join(","), ...csvRows].join("\n");
  }

  const dataContext = jsonToCsv(rows);
  const truncationNote = truncated
    ? `\n(Note: Results were limited to ${MAX_ROWS} rows)`
    : "";

  const userInput =
    `User asked: "${query}"\n\nData results:\n${dataContext}${truncationNote}`;

  const stream = await openai.responses.create({
    model: RESPONSE_MODEL,
    instructions: RESPONSE_INSTRUCTIONS,
    input: userInput,
    previous_response_id: previousResponseId, // Chain from SQL conversion
    stream: true,
    temperature: 0.7, // Slightly higher for more natural responses
    store: true, // Store for potential follow-ups
    user: hashedUserId, // Hashed user ID for abuse detection
    max_output_tokens: 1000,
  });

  let fullResponse = "";
  let responseId = "";
  let usage: TokenUsage = {
    promptTokens: 0,
    completionTokens: 0,
    totalTokens: 0,
  };

  for await (const event of stream) {
    // Handle text deltas
    if (event.type === "response.output_text.delta") {
      const delta = event.delta;
      if (delta) {
        fullResponse += delta;
        sendText(delta);
      }
    }

    // Capture response ID and usage from completed response
    if (event.type === "response.completed") {
      responseId = event.response.id;
      usage = {
        promptTokens: event.response.usage?.input_tokens ?? 0,
        completionTokens: event.response.usage?.output_tokens ?? 0,
        totalTokens: event.response.usage?.total_tokens ?? 0,
      };
    }
  }

  return { fullResponse, responseId, usage };
}

/**
 * Logs step metrics to console.
 */
function logStepMetrics(
  stepName: string,
  input: unknown,
  output: unknown,
  durationMs: number,
  tokenUsage?: TokenUsage,
): void {
  const bigIntToNumber = (key: any, value: any) =>
    typeof value === "bigint" ? Number(value) : value;

  console.log(`\n========== [${stepName}] ==========`);
  console.log(`⏱️  Duration: ${durationMs}ms`);
  console.log(`📥  Input:`, JSON.stringify(input, bigIntToNumber, 2));
  console.log(`📤  Output:`, JSON.stringify(output, bigIntToNumber, 2));
  if (tokenUsage) {
    console.log(
      `🎟️  Tokens: { prompt: ${tokenUsage.promptTokens}, completion: ${tokenUsage.completionTokens}, total: ${tokenUsage.totalTokens} }`,
    );
  }
  console.log(`====================================\n`);
}

/**
 * Runs the complete NL-to-SQL pipeline with streaming progress updates.
 *
 * @param input - Pipeline input with query, userId, and optional previousResponseId
 * @returns Response with SSE stream
 */
export async function runPipeline(input: PipelineInput): Promise<Response> {
  const { query, userId, previousResponseId, previousConversionId } = input;
  const openai = new OpenAI();
  const progress = createProgressStream();
  const hashedUserId = await hashUserId(userId);

  // Run pipeline asynchronously
  (async () => {
    const stepLogs: StepLog[] = [];
    let finalResponseId = "";
    let finalConversionId = "";

    try {
      // ============================================
      // Stage 1: Convert NL to SQL
      // ============================================
      progress.sendStep(STEP_NAMES.CONVERTING, "in_progress");
      const stage1Start = performance.now();
      const stage1Input = {
        query,
        userId,
        previousResponseId,
        previousConversionId,
      };

      let sql: string;
      let conversionResponseId: string;
      let conversionUsage: TokenUsage;
      try {
        const result = await convertToSql(
          openai,
          query,
          userId,
          hashedUserId,
          previousConversionId,
        );
        sql = result.sql;
        conversionResponseId = result.responseId;
        conversionUsage = result.usage;

        const stage1Duration = Math.round(
          performance.now() - stage1Start,
        );
        logStepMetrics(
          STEP_NAMES.CONVERTING,
          stage1Input,
          { sql, responseId: conversionResponseId },
          stage1Duration,
          conversionUsage,
        );

        // Collect step log
        stepLogs.push({
          stepName: DB_STEP_NAMES.CONVERTING,
          input: stage1Input,
          output: { sql, responseId: conversionResponseId },
          usage: conversionUsage,
          durationMs: stage1Duration,
        });
        finalConversionId = conversionResponseId;

        progress.sendConversionId(conversionResponseId);
        progress.sendStep(STEP_NAMES.CONVERTING, "complete");
      } catch (err) {
        const stage1Duration = Math.round(
          performance.now() - stage1Start,
        );
        logStepMetrics(
          STEP_NAMES.CONVERTING,
          stage1Input,
          { error: String(err) },
          stage1Duration,
        );

        console.error(`[NL-to-SQL] Conversion failed:`, err);
        progress.sendStep(STEP_NAMES.CONVERTING, "error");
        progress.sendError(
          "I had trouble understanding your question. Could you try rephrasing it?",
        );
        return;
      }

      // ============================================
      // Stage 2: Validate SQL
      // ============================================
      progress.sendStep(STEP_NAMES.VALIDATING, "in_progress");
      const stage2Start = performance.now();
      const stage2Input = { sql };

      const validation = validateSqlQuery(sql);
      const stage2Duration = Math.round(performance.now() - stage2Start);

      logStepMetrics(
        STEP_NAMES.VALIDATING,
        stage2Input,
        validation,
        stage2Duration,
      );

      // Collect step log
      stepLogs.push({
        stepName: DB_STEP_NAMES.VALIDATING,
        input: stage2Input,
        output: validation,
        durationMs: stage2Duration,
      });

      if (!validation.valid) {
        console.error(
          `[NL-to-SQL] Validation failed: ${validation.error}`,
        );
        progress.sendStep(STEP_NAMES.VALIDATING, "error");
        progress.sendError(
          "I generated a query that doesn't look safe. Let me know if you'd like to try a different question.",
        );
        return;
      }
      progress.sendStep(STEP_NAMES.VALIDATING, "complete");

      // ============================================
      // Stage 3: Execute SQL
      // ============================================
      progress.sendStep(STEP_NAMES.EXECUTING, "in_progress");
      const stage3Start = performance.now();
      const stage3Input = { sql };

      let rows: unknown[];
      let truncated: boolean;
      let originalRowCount: number;
      try {
        const result = await executeQuery(sql);
        rows = result.rows;
        truncated = result.truncated;
        originalRowCount = result.originalRowCount;

        const stage3Duration = Math.round(
          performance.now() - stage3Start,
        );
        logStepMetrics(
          STEP_NAMES.EXECUTING,
          stage3Input,
          {
            rowCount: rows.length,
            originalRowCount,
            truncated,
            rows,
          },
          stage3Duration,
        );

        // Collect step log
        stepLogs.push({
          stepName: DB_STEP_NAMES.EXECUTING,
          input: stage3Input,
          output: { rowCount: rows.length, originalRowCount, truncated, rows },
          durationMs: stage3Duration,
        });

        progress.sendStep(STEP_NAMES.EXECUTING, "complete");
      } catch (err) {
        const stage3Duration = Math.round(
          performance.now() - stage3Start,
        );
        logStepMetrics(
          STEP_NAMES.EXECUTING,
          stage3Input,
          { error: String(err) },
          stage3Duration,
        );

        console.error(`[NL-to-SQL] Query execution failed:`, err);
        progress.sendStep(STEP_NAMES.EXECUTING, "error");
        progress.sendError(
          "I ran into an issue fetching your data. Please try again.",
        );
        return;
      }

      // ============================================
      // Stage 4: Generate streaming response
      // ============================================
      progress.sendStep(STEP_NAMES.RESPONDING, "in_progress");
      const stage4Start = performance.now();
      const stage4Input = { query, rowCount: rows.length, truncated };
      let responseStarted = false;

      try {
        const result = await generateStreamingResponse(
          openai,
          query,
          rows,
          truncated,
          conversionResponseId, // Chain from SQL conversion for context
          hashedUserId,
          (delta: string) => {
            // Mark step as complete as soon as we start streaming text
            if (!responseStarted) {
              progress.sendStep(STEP_NAMES.RESPONDING, "complete");
              responseStarted = true;
            }
            progress.sendText(delta);
          },
        );

        const stage4Duration = Math.round(
          performance.now() - stage4Start,
        );
        logStepMetrics(
          STEP_NAMES.RESPONDING,
          stage4Input,
          {
            responseLength: result.fullResponse.length,
            responseId: result.responseId,
          },
          stage4Duration,
          result.usage,
        );

        // Send the final response ID so client can use it for follow-ups
        progress.sendResponseId(result.responseId);

        // Log total pipeline usage
        const totalDuration = Math.round(performance.now() - stage1Start);

        const totalPromptTokens = (conversionUsage?.promptTokens ?? 0) +
          (result.usage?.promptTokens ?? 0);
        const totalCompletionTokens = (conversionUsage?.completionTokens ?? 0) +
          (result.usage?.completionTokens ?? 0);
        const totalTokens = (conversionUsage?.totalTokens ?? 0) +
          (result.usage?.totalTokens ?? 0);

        console.log(`\n========== [PIPELINE SUMMARY] ==========`);
        console.log(`⏱️  Total Duration: ${totalDuration}ms`);
        console.log(`🎫  Token Usage:`);
        console.log(`   - Prompt:     ${totalPromptTokens}`);
        console.log(`   - Completion: ${totalCompletionTokens}`);
        console.log(`   - Total:      ${totalTokens}`);
        console.log(`========================================\n`);
        console.log(`========================================\n`);

        // Collect step log
        stepLogs.push({
          stepName: DB_STEP_NAMES.RESPONDING,
          input: stage4Input,
          output: {
            responseText: result.fullResponse,
            responseLength: result.fullResponse.length,
            responseId: result.responseId,
          },
          usage: result.usage,
          durationMs: stage4Duration,
        });
        finalResponseId = result.responseId;

        // Persist to database for debugging
        await persistInsight(
          userId,
          query,
          finalResponseId,
          finalConversionId,
          previousResponseId,
          previousConversionId,
          stepLogs,
        );
      } catch (err) {
        const stage4Duration = Math.round(
          performance.now() - stage4Start,
        );
        logStepMetrics(
          STEP_NAMES.RESPONDING,
          stage4Input,
          { error: String(err) },
          stage4Duration,
        );

        console.error(`[NL-to-SQL] Response generation failed:`, err);
        progress.sendStep(STEP_NAMES.RESPONDING, "error");
        progress.sendError(
          "I had trouble putting together your answer. Please try again.",
        );
      }
    } finally {
      progress.close();
    }
  })();

  return new Response(progress.stream, {
    headers: createSSEHeaders(),
  });
}
