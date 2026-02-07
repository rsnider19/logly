/**
 * Voice Activity Parser Edge Function
 *
 * Parses voice transcripts using GPT-4o-mini to extract activity details,
 * then searches for matching activities using hybrid search.
 *
 * Returns both the parsed data and top 5 matching activities.
 */

import "@supabase/functions-js/edge-runtime.d.ts";
import OpenAI from "npm:openai@4.103.0";
import { createUserClient } from "../_utils/supabaseClient.ts";
import { AuthMiddleware } from "../_utils/verifyJwt.ts";
import { supabaseAdminClient } from "../_utils/supabaseAdmin.ts";

const SYSTEM_PROMPT = `You are a voice input parser for an activity logging app. Extract structured data from the user's voice transcript.

This app logs ANY type of personal activity - fitness, work, social, travel, hobbies, wellness, etc. Extract the core activity being described and normalize it to a searchable term.

Extract these fields (return null if not mentioned):
- activity_query: The activity type, normalized to a searchable term. Extract the main activity being described and use its base form (e.g., "ran" → "running", "lifted weights" → "weight training", "went on a work trip" → "work trip", "had dinner with friends" → "dinner", "drove to the store" → "shopping"). Use an EMPTY STRING only if absolutely no activity is mentioned.
- duration: Time spent on the activity
- distance: Distance covered (for applicable activities)
- date: When the activity happened
- comments: Any additional context that doesn't fit the above fields (like locations, people involved, or other details)

Be flexible with phrasing:
- "did a 5k" = running, 5 kilometers
- "quick 20 minute jog" = running, 1200 seconds
- "hit the gym for an hour" = weight training, 3600 seconds
- "went on a work trip to Chicago" = work trip, comments: "to Chicago"
- "had lunch with Sarah downtown" = lunch, comments: "with Sarah downtown"
- "this morning" = today's date at 8:00 AM
- "yesterday evening" = yesterday at 6:00 PM
- Day-of-week references like "Monday", "on Tuesday", etc. ALWAYS refer to the MOST RECENT PAST occurrence of that day. If today is Thursday and the user says "on Monday", that means the Monday 3 days ago, NOT the coming Monday. Never resolve a day-of-week to a future date.

Always normalize activity names to their base form for better search matching. Capture location and social context in comments.`;

/**
 * JSON Schema for OpenAI structured output.
 */
const PARSE_SCHEMA = {
  type: "json_schema" as const,
  json_schema: {
    name: "voice_activity_parse",
    strict: true,
    schema: {
      type: "object",
      properties: {
        activity_query: {
          type: "string",
          description:
            "The normalized activity type for searching (e.g., 'running', 'yoga', 'weight training')",
        },
        duration: {
          type: ["object", "null"],
          properties: {
            seconds: {
              type: "integer",
              description: "Duration in seconds",
            },
          },
          required: ["seconds"],
          additionalProperties: false,
        },
        distance: {
          type: ["object", "null"],
          properties: {
            meters: {
              type: "number",
              description: "Distance in meters",
            },
            original_value: {
              type: "number",
              description: "The original numeric value mentioned",
            },
            original_unit: {
              type: "string",
              description:
                "The original unit mentioned (e.g., 'miles', 'km', 'meters')",
            },
          },
          required: ["meters", "original_value", "original_unit"],
          additionalProperties: false,
        },
        date: {
          type: ["object", "null"],
          properties: {
            iso: {
              type: "string",
              description: "ISO 8601 date string",
            },
            relative: {
              type: ["string", "null"],
              description:
                "The relative time phrase used (e.g., 'this morning', 'yesterday')",
            },
          },
          required: ["iso", "relative"],
          additionalProperties: false,
        },
        comments: {
          type: ["string", "null"],
          description: "Any additional context from the transcript",
        },
      },
      required: ["activity_query", "duration", "distance", "date", "comments"],
      additionalProperties: false,
    },
  },
};

/**
 * Inserts telemetry record for voice activity parsing.
 * Fire-and-forget: returns null on error, never throws.
 */
async function insertTelemetry(params: {
  userId: string;
  transcript: string;
  parsedJson: object;
  llmModel: string;
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
  llmLatencyMs: number;
  activitySearchResults: string[];
  errorType?: string;
  errorMessage?: string;
  errorStackTrace?: string;
}): Promise<string | null> {
  try {
    const { data, error } = await supabaseAdminClient
      .from("voice_activity_telemetry")
      .insert({
        user_id: params.userId,
        transcript: params.transcript,
        parsed_json: params.parsedJson,
        llm_model: params.llmModel,
        prompt_tokens: params.promptTokens,
        completion_tokens: params.completionTokens,
        total_tokens: params.totalTokens,
        llm_latency_ms: params.llmLatencyMs,
        activity_search_results: params.activitySearchResults,
        error_type: params.errorType || null,
        error_message: params.errorMessage || null,
        error_stack_trace: params.errorStackTrace || null,
      })
      .select("id")
      .single();

    if (error) {
      console.error("[Telemetry] Failed to insert telemetry:", error);
      return null;
    }

    return data.id;
  } catch (e) {
    console.error("[Telemetry] Exception inserting telemetry:", e);
    return null;
  }
}

Deno.serve((r) =>
  AuthMiddleware(r, async (req, userId) => {
    try {
      const { transcript, timezone, utc_offset, local_date } = await req.json();

      if (!transcript || typeof transcript !== "string") {
        return new Response(
          JSON.stringify({ error: "Missing or invalid transcript" }),
          { status: 400, headers: { "Content-Type": "application/json" } }
        );
      }

      // Use user's local date/timezone for accurate relative date parsing
      const currentDate = local_date || new Date().toISOString();
      const userTimezone = timezone || "UTC";
      const userUtcOffset = utc_offset || "+00:00";

      // Compute day-of-week from local date for explicit context
      const localDate = new Date(currentDate);
      const dayOfWeek = localDate.toLocaleDateString("en-US", { weekday: "long" });

      // 1. Parse with GPT-4o-mini using structured output
      const openai = new OpenAI();
      const llmStartTime = Date.now();
      const parseResponse = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: `${SYSTEM_PROMPT}\n\nCurrent local date/time: ${currentDate}\nToday is: ${dayOfWeek}\nUser timezone: ${userTimezone} (UTC${userUtcOffset})\n\nIMPORTANT: All dates in the ISO output must use the user's local timezone offset (${userUtcOffset}). Day-of-week references refer to the most recent PAST occurrence relative to today (${dayOfWeek}).`,
          },
          { role: "user", content: transcript },
        ],
        response_format: PARSE_SCHEMA,
        temperature: 0.1,
        max_tokens: 300,
      });
      const llmLatencyMs = Date.now() - llmStartTime;

      const content = parseResponse.choices[0].message.content;
      if (!content) {
        throw new Error("No content in OpenAI response");
      }

      const parsed = JSON.parse(content);

      // Check if activity_query is empty/whitespace - if so, skip search
      const activityQuery = parsed.activity_query?.trim() || "";
      if (activityQuery === "") {
        // Insert telemetry for empty query case
        const telemetryIdPromise = insertTelemetry({
          userId: userId!,
          transcript,
          parsedJson: parsed,
          llmModel: "gpt-4o-mini",
          promptTokens: parseResponse.usage?.prompt_tokens || 0,
          completionTokens: parseResponse.usage?.completion_tokens || 0,
          totalTokens: parseResponse.usage?.total_tokens || 0,
          llmLatencyMs,
          activitySearchResults: [],
        });

        // Race with 100ms timeout for fire-and-forget
        const telemetryId = await Promise.race([
          telemetryIdPromise,
          new Promise<null>((resolve) => setTimeout(() => resolve(null), 100)),
        ]);

        return new Response(
          JSON.stringify({
            parsed,
            activities: [],
            telemetry_id: telemetryId,
          }),
          { headers: { "Content-Type": "application/json" } }
        );
      }

      // 2. Generate embedding for activity search
      const session = new Supabase.ai.Session("gte-small");
      const embedding = await session.run(activityQuery, {
        mean_pool: true,
        normalize: true,
      });

      // 3. Search for matching activities
      const supabase = createUserClient(req);
      const { data: activities, error } = await supabase
        .rpc("hybrid_search_activities", {
          query_text: activityQuery,
          query_embedding: embedding,
          match_count: 5,
        })
        .select("*, activity_category(*)");

      if (error) {
        console.error("Activity search failed:", error);
        throw new Error(`Activity search failed: ${error.message}`);
      }

      // 4. Insert telemetry with activity search results
      const activityIds = (activities || []).map((a) => a.activity_id);
      const telemetryIdPromise = insertTelemetry({
        userId: userId!,
        transcript,
        parsedJson: parsed,
        llmModel: "gpt-4o-mini",
        promptTokens: parseResponse.usage?.prompt_tokens || 0,
        completionTokens: parseResponse.usage?.completion_tokens || 0,
        totalTokens: parseResponse.usage?.total_tokens || 0,
        llmLatencyMs,
        activitySearchResults: activityIds,
      });

      // Race with 100ms timeout for fire-and-forget
      const telemetryId = await Promise.race([
        telemetryIdPromise,
        new Promise<null>((resolve) => setTimeout(() => resolve(null), 100)),
      ]);

      // 5. Return combined result in snake_case
      return new Response(
        JSON.stringify({
          parsed,
          activities: activities || [],
          telemetry_id: telemetryId,
        }),
        { headers: { "Content-Type": "application/json" } }
      );
    } catch (error) {
      console.error("Voice parse failed:", error);

      // Insert error telemetry (fire-and-forget, don't await)
      if (userId) {
        insertTelemetry({
          userId,
          transcript: "",
          parsedJson: {},
          llmModel: "gpt-4o-mini",
          promptTokens: 0,
          completionTokens: 0,
          totalTokens: 0,
          llmLatencyMs: 0,
          activitySearchResults: [],
          errorType: error instanceof Error ? error.name : "UnknownError",
          errorMessage: error instanceof Error ? error.message : String(error),
          errorStackTrace: error instanceof Error ? error.stack : undefined,
        }).catch((e) => console.error("[Telemetry] Error logging failed:", e));
      }

      return new Response(
        JSON.stringify({
          error: "Failed to process voice input. Please try again.",
        }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }
  })
);
