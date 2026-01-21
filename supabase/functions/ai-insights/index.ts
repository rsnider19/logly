import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { runPipeline } from "./agent.ts";
import { isEntitledTo } from "../_utils/isEntitledTo.ts";

/**
 * Edge function entry point for the NL-to-SQL agent.
 *
 * POST /functions/v1/ai-insights-new
 * Body: {
 *   "query": "How many activities did I log this week?",
 *   "previousResponseId": "resp_abc123" // Optional, for follow-up questions
 * }
 *
 * Returns: Server-Sent Events stream with progress, response, and responseId for follow-ups
 */
Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
    });
  }

  // Only accept POST requests
  if (req.method !== "POST") {
    return new Response("Method not allowed", { status: 405 });
  }

  // Extract user ID from JWT
  const authHeader = req.headers.get("Authorization");
  if (!authHeader) {
    return new Response("Unauthorized", { status: 401 });
  }

  let userId: string;
  try {
    // Decode JWT to get user ID (sub claim)
    const token = authHeader.replace("Bearer ", "");
    const payload = JSON.parse(atob(token.split(".")[1]));
    userId = payload.sub;

    if (!userId) {
      return new Response("Invalid token: missing user ID", {
        status: 401,
      });
    }
  } catch {
    return new Response("Invalid token", { status: 401 });
  }

  // TODO: Add entitlement check here if needed
  // Example:
  const isEntitled = true || await isEntitledTo({ req, entitlement: "ai-insights" });
  if (!isEntitled) {
    return new Response(
      JSON.stringify({ message: "Forbidden", code: "premium_required" }),
      { status: 403 }
    );
  }

  // Parse request body
  let query: string;
  let previousResponseId: string | undefined;
  let previousConversionId: string | undefined;
  try {
    const body = await req.json();
    query = body.query;
    previousResponseId = body.previousResponseId; // Optional for follow-ups (Friendly Agent)
    previousConversionId = body.previousConversionId; // Optional for follow-ups (SQL Agent)

    if (!query || typeof query !== "string") {
      return new Response(
        JSON.stringify({ error: "Missing or invalid 'query' field" }),
        { status: 400 },
      );
    }
  } catch {
    return new Response(
      JSON.stringify({ error: "Invalid JSON body" }),
      { status: 400 },
    );
  }

  console.log(
    `[AI Insights New] Request from user ${userId}: "${query}"${
      previousResponseId ? ` (follow-up to ${previousResponseId})` : ""
    }`,
  );

  // Run the pipeline and return streaming response
  return runPipeline({
    query,
    userId,
    previousResponseId,
    previousConversionId,
  });
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Run `supabase functions serve ai-insights-new --env-file ./supabase/functions/.env`
  3. Make an HTTP request (first question):

  curl -N --location --request POST 'http://127.0.0.1:54321/functions/v1/ai-insights-new' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"query":"How many activities did I log this week?"}'

  4. For follow-up questions, use the responseId from the previous response:

  curl -N --location --request POST 'http://127.0.0.1:54321/functions/v1/ai-insights-new' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"query":"What about last week?", "previousResponseId":"resp_abc123"}'

*/
