/**
 * Streaming friendly response generation via OpenAI GPT-4o-mini.
 *
 * Takes the original user question and SQL query results, then generates
 * a friendly, encouraging response streamed token-by-token via a callback.
 *
 * The response agent chains from the SQL agent's response ID via
 * previous_response_id, giving it context about what SQL was generated
 * and why. This enables more accurate and contextual responses.
 *
 * Follow-up support: within a single turn, Call 2 (this function) chains
 * from Call 1's response ID. Across turns, the client sends back
 * previousResponseId which is used by the pipeline.
 */

import OpenAI from "npm:openai@4.103.0";
import { RESPONSE_INSTRUCTIONS } from "./prompts.ts";

/** Model used for response generation. */
const RESPONSE_MODEL = "gpt-4o-mini";

// ============================================================
// Types
// ============================================================

export interface ResponseGeneratorParams {
  query: string;
  rows: unknown[];
  truncated: boolean;
  conversionId: string;
  hashedUserId: string;
  onTextDelta: (delta: string) => void;
}

export interface ResponseGeneratorResult {
  fullResponse: string;
  responseId: string;
  usage: {
    inputTokens: number;
    outputTokens: number;
    cachedTokens: number;
  };
}

// ============================================================
// Helpers
// ============================================================

/**
 * Converts an array of JSON objects to CSV format.
 * This saves tokens compared to sending raw JSON to the LLM.
 *
 * @param data - Array of objects with consistent keys
 * @returns CSV string with headers and rows
 */
function jsonToCsv(data: unknown[]): string {
  if (!data || data.length === 0) return "";

  const items = data as Record<string, unknown>[];
  const headers = Object.keys(items[0]);

  const csvRows = items.map((row) =>
    headers
      .map((header) => {
        const val = row[header];
        if (typeof val === "string") {
          // Escape quotes and wrap in quotes if necessary
          return `"${val.replace(/"/g, '""')}"`;
        }
        return String(val);
      })
      .join(",")
  );

  return [headers.join(","), ...csvRows].join("\n");
}

// ============================================================
// Main Export
// ============================================================

/**
 * Generates a streaming friendly response from query results.
 *
 * Uses OpenAI GPT-4o-mini with streaming enabled. The response is
 * chained from the SQL agent's response via conversionId, providing
 * context about the generated query.
 *
 * @param params - Query, results, conversion context, and text delta callback
 * @returns The full response text and OpenAI response ID for follow-up chaining
 */
export async function generateStreamingResponse(
  params: ResponseGeneratorParams,
): Promise<ResponseGeneratorResult> {
  const { query, rows, truncated, conversionId, hashedUserId, onTextDelta } =
    params;

  const openai = new OpenAI();

  // Convert rows to CSV for token efficiency
  const dataContext = jsonToCsv(rows);
  const truncationNote = truncated
    ? "\n(Note: Results were limited to 100 rows)"
    : "";

  const userInput =
    `User asked: "${query}"\n\nData results:\n${dataContext}${truncationNote}`;

  // Stream the response, chaining from SQL agent for context
  const stream = await openai.responses.create({
    model: RESPONSE_MODEL,
    instructions: RESPONSE_INSTRUCTIONS,
    input: userInput,
    previous_response_id: conversionId, // Chain from SQL conversion for context
    stream: true,
    temperature: 0.7, // Slightly higher for more natural, warm responses
    store: true, // Store for follow-up context
    user: hashedUserId, // Hashed user ID for abuse detection
    max_output_tokens: 1000,
  });

  let fullResponse = "";
  let responseId = "";
  let usage = { inputTokens: 0, outputTokens: 0, cachedTokens: 0 };

  for await (const event of stream) {
    // Handle text deltas (token-by-token streaming)
    if (event.type === "response.output_text.delta") {
      const delta = event.delta;
      if (delta) {
        fullResponse += delta;
        onTextDelta(delta);
      }
    }

    // Capture response ID and usage from completed response
    if (event.type === "response.completed") {
      responseId = event.response.id;
      usage = {
        inputTokens: event.response.usage?.input_tokens ?? 0,
        outputTokens: event.response.usage?.output_tokens ?? 0,
        cachedTokens: event.response.usage?.input_tokens_details?.cached_tokens ?? 0,
      };
    }
  }

  return { fullResponse, responseId, usage };
}
