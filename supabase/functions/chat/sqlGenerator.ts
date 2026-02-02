/**
 * NL-to-SQL conversion via OpenAI GPT-4o-mini.
 *
 * Converts natural language questions into SQL queries using structured
 * output with off-topic detection. Uses a discriminated union schema:
 * the LLM returns either { offTopic: false, sqlQuery: "SELECT ..." }
 * or { offTopic: true, redirectMessage: "..." }.
 *
 * Includes a self-correction retry: if the first response fails to parse,
 * a repair request is chained via previous_response_id to fix the output.
 *
 * Follow-up support: accepts an optional previousConversionId to chain
 * SQL generation context across turns (e.g., "What about last week?"
 * resolves against the previous SQL query context).
 */

import OpenAI from "npm:openai@4.103.0";
import { z } from "npm:zod";
import { buildNlToSqlInstructions } from "./prompts.ts";

/** Model used for NL-to-SQL conversion. */
const NL_TO_SQL_MODEL = "gpt-4o-mini";

// ============================================================
// Zod Schema (runtime validation)
// ============================================================

/**
 * Schema for a normal SQL query response.
 */
const SqlQueryResponse = z.object({
  offTopic: z.literal(false),
  sqlQuery: z.string().min(1),
});

/**
 * Schema for an off-topic redirect response.
 */
const OffTopicResponse = z.object({
  offTopic: z.literal(true),
  redirectMessage: z.string().min(1),
});

/**
 * Discriminated union: either a SQL query or an off-topic redirect.
 */
const NlToSqlResponse = z.union([SqlQueryResponse, OffTopicResponse]);

export type NlToSqlResult = z.infer<typeof NlToSqlResponse>;

// ============================================================
// OpenAI JSON Schema (for text.format)
// ============================================================

/**
 * Manual JSON schema for OpenAI's structured output.
 * We cannot use Zod's toJsonSchema() directly because OpenAI's
 * text.format expects a specific shape and strict mode conflicts
 * with text-based history from the response agent.
 */
const apiSchema = {
  type: "json_schema" as const,
  name: "nl_to_sql",
  strict: false,
  schema: {
    type: "object",
    properties: {
      offTopic: {
        type: "boolean",
        description:
          "true if the question is not about Logly activity data, false otherwise",
      },
      sqlQuery: {
        type: "string",
        description:
          "The SQL query to execute (only when offTopic is false)",
      },
      redirectMessage: {
        type: "string",
        description:
          "A friendly redirect message (only when offTopic is true)",
      },
    },
    required: ["offTopic"],
    additionalProperties: false,
  },
};

// ============================================================
// Types
// ============================================================

export interface GenerateSQLParams {
  query: string;
  userId: string;
  previousConversionId?: string;
}

export interface GenerateSQLResult {
  parsed: NlToSqlResult;
  conversionId: string;
}

// ============================================================
// Helpers
// ============================================================

/**
 * Hashes the user ID for OpenAI's abuse detection.
 * This allows OpenAI to track per-user patterns without exposing raw UUIDs.
 */
export async function hashUserId(userId: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(userId);
  const hashBuffer = await crypto.subtle.digest("SHA-256", data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

// ============================================================
// Main Export
// ============================================================

/**
 * Generates a SQL query (or off-topic redirect) from a natural language question.
 *
 * Uses OpenAI GPT-4o-mini with structured JSON output. On parse failure,
 * triggers a self-correction retry chained via previous_response_id.
 *
 * @param params - Query text, userId, and optional previous conversion ID
 * @returns Parsed result (SQL or redirect) plus the OpenAI response ID for chaining
 */
export async function generateSQL(
  params: GenerateSQLParams,
): Promise<GenerateSQLResult> {
  const { query, userId, previousConversionId } = params;
  const openai = new OpenAI();
  const hashedUser = await hashUserId(userId);

  const userInput = `${query} (Output raw JSON only. Start response with {)`;

  // Build request with optional follow-up chaining
  const response = await openai.responses.create({
    model: NL_TO_SQL_MODEL,
    instructions: buildNlToSqlInstructions(userId),
    input: userInput,
    ...(previousConversionId && {
      previous_response_id: previousConversionId,
    }),
    text: {
      format: apiSchema,
    },
    temperature: 0.1, // Low temperature for consistent SQL generation
    store: true, // Store for follow-up context chaining
    user: hashedUser, // Hashed user ID for abuse detection
    // @ts-ignore: Responses API uses max_output_tokens
    max_output_tokens: 300,
  });

  const content = response.output_text;
  if (!content) {
    throw new Error("No response from NL-to-SQL model");
  }

  // Robustly extract JSON object (model may add surrounding text)
  let jsonStr = content;
  const jsonMatch = content.match(/\{[\s\S]*?\}/);
  if (jsonMatch) {
    jsonStr = jsonMatch[0];
  }

  let parsed: NlToSqlResult;
  try {
    parsed = NlToSqlResponse.parse(JSON.parse(jsonStr));
  } catch (parseError) {
    console.warn(
      `[NL-to-SQL] JSON validation failed. Triggering self-correction... Error: ${parseError}`,
    );

    // Self-correction retry: chain from the failed response
    try {
      const repairResponse = await openai.responses.create({
        model: NL_TO_SQL_MODEL,
        input:
          `The previous response was invalid. Error: ${parseError}. Please return ONLY the raw JSON object, obeying the schema. Start with {`,
        previous_response_id: response.id,
        text: {
          format: apiSchema,
        },
        temperature: 0.1,
        store: true,
        user: hashedUser,
      });

      const repairContent = repairResponse.output_text;
      if (!repairContent) {
        throw new Error("No response from self-correction attempt");
      }

      parsed = NlToSqlResponse.parse(JSON.parse(repairContent));
      console.log("[NL-to-SQL] Self-correction successful.");

      return {
        parsed,
        conversionId: repairResponse.id,
      };
    } catch (repairError) {
      console.error(`[NL-to-SQL] Self-correction failed: ${repairError}`);
      throw new Error(
        `Failed to parse NL-to-SQL response after self-correction: ${parseError}`,
      );
    }
  }

  return {
    parsed,
    conversionId: response.id,
  };
}
