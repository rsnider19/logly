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
import { snakeToCamel } from "../_utils/snakeToCamel.ts";
import { AuthMiddleware } from "../_utils/verifyJwt.ts";

const SYSTEM_PROMPT = `You are a voice input parser for an activity logging app. Extract structured data from the user's voice transcript.

Extract these fields (return null if not mentioned):
- activityQuery: The activity type, normalized to a searchable term (e.g., "ran" → "running", "lifted weights" → "weight training", "did yoga" → "yoga", "went swimming" → "swimming")
- duration: Time spent on the activity
- distance: Distance covered (for applicable activities)
- date: When the activity happened
- comments: Any additional context that doesn't fit the above fields

Be flexible with phrasing:
- "did a 5k" = 5 kilometers
- "quick 20 minute jog" = running, 1200 seconds
- "hit the gym for an hour" = weight training, 3600 seconds
- "this morning" = today's date at 8:00 AM
- "yesterday evening" = yesterday at 6:00 PM

Always normalize activity names to their base form for better search matching.`;

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
        activityQuery: {
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
            originalValue: {
              type: "number",
              description: "The original numeric value mentioned",
            },
            originalUnit: {
              type: "string",
              description:
                "The original unit mentioned (e.g., 'miles', 'km', 'meters')",
            },
          },
          required: ["meters", "originalValue", "originalUnit"],
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
          required: ["iso"],
          additionalProperties: false,
        },
        comments: {
          type: ["string", "null"],
          description: "Any additional context from the transcript",
        },
      },
      required: ["activityQuery", "duration", "distance", "date", "comments"],
      additionalProperties: false,
    },
  },
};

Deno.serve((r) =>
  AuthMiddleware(r, async (req) => {
    try {
      const { transcript } = await req.json();

      if (!transcript || typeof transcript !== "string") {
        return new Response(
          JSON.stringify({ error: "Missing or invalid transcript" }),
          { status: 400, headers: { "Content-Type": "application/json" } }
        );
      }

      // Get current date for relative date parsing
      const currentDate = new Date().toISOString();

      // 1. Parse with GPT-4o-mini using structured output
      const openai = new OpenAI();
      const parseResponse = await openai.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: `${SYSTEM_PROMPT}\n\nCurrent date/time: ${currentDate}`,
          },
          { role: "user", content: transcript },
        ],
        response_format: PARSE_SCHEMA,
        temperature: 0.1,
        max_tokens: 300,
      });

      const content = parseResponse.choices[0].message.content;
      if (!content) {
        throw new Error("No content in OpenAI response");
      }

      const parsed = JSON.parse(content);

      // 2. Generate embedding for activity search
      const session = new Supabase.ai.Session("gte-small");
      const embedding = await session.run(parsed.activityQuery, {
        mean_pool: true,
        normalize: true,
      });

      // 3. Search for matching activities
      const supabase = createUserClient(req);
      const { data: activities, error } = await supabase
        .rpc("hybrid_search_activities", {
          query_text: parsed.activityQuery,
          query_embedding: embedding,
          match_count: 5,
        })
        .select("*, activity_category(*)");

      if (error) {
        console.error("Activity search failed:", error);
        throw new Error(`Activity search failed: ${error.message}`);
      }

      // 4. Transform to camelCase and add __typename for client compatibility
      const transformedActivities = snakeToCamel(activities || []);
      transformedActivities.forEach((activity: Record<string, unknown>) => {
        activity.__typename = "Activity";
        if (activity.activityCategory) {
          (activity.activityCategory as Record<string, unknown>).__typename =
            "ActivityCategory";
        }
      });

      // 5. Return combined result
      return new Response(
        JSON.stringify({
          parsed,
          activities: transformedActivities,
        }),
        { headers: { "Content-Type": "application/json" } }
      );
    } catch (error) {
      console.error("Voice parse failed:", error);
      return new Response(
        JSON.stringify({
          error: "Failed to process voice input. Please try again.",
        }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }
  })
);
