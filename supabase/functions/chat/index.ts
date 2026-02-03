import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { AuthMiddleware } from "../_utils/verifyJwt.ts";
import { isEntitledTo } from "../_utils/isEntitledTo.ts";
import { checkRateLimit } from "./rateLimit.ts";
import { runPipeline } from "./pipeline.ts";

/**
 * Edge function entry point for the chat NL-to-SQL pipeline.
 *
 * POST /functions/v1/chat
 * Body: {
 *   "query": "How many activities did I log this week?",
 *   "previousResponseId": "resp_abc123",   // Optional, for follow-up response chaining
 *   "previousConversionId": "conv_abc123"  // Optional, for follow-up SQL context chaining
 * }
 *
 * Returns: Server-Sent Events stream with progress steps, text deltas, and completion signal.
 *
 * Pipeline: auth -> subscription check -> rate limit -> NL-to-SQL -> validate -> execute with RLS -> stream response
 */
Deno.serve((r) =>
  AuthMiddleware(r, async (req, userId) => {
    // ----------------------------------------------------------------
    // 1. Method check: only POST allowed
    // ----------------------------------------------------------------
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    // ----------------------------------------------------------------
    // 2. Auth check: userId must be present (set by AuthMiddleware)
    // ----------------------------------------------------------------
    if (!userId) {
      return new Response(
        JSON.stringify({ message: "Unauthorized" }),
        { status: 401, headers: { "Content-Type": "application/json" } },
      );
    }

    // ----------------------------------------------------------------
    // 3. Subscription check: user must be entitled to "ai-insights"
    // ----------------------------------------------------------------
    const isEntitled = await isEntitledTo({
      userId,
      entitlement: "ai-insights",
    });
    if (!isEntitled) {
      return new Response(
        JSON.stringify({
          message: "Forbidden",
          code: "premium_required",
        }),
        { status: 403, headers: { "Content-Type": "application/json" } },
      );
    }

    // ----------------------------------------------------------------
    // 4. Rate limit check: per-user sliding window (20/hour)
    // ----------------------------------------------------------------
    const rateLimitResult = await checkRateLimit(userId);
    if (!rateLimitResult.allowed) {
      return new Response(
        JSON.stringify({
          message: "You've been busy! Give me a moment to catch up. Try again in a few minutes.",
          code: "rate_limited",
        }),
        { status: 429, headers: { "Content-Type": "application/json" } },
      );
    }

    // ----------------------------------------------------------------
    // 5. Parse and validate request body
    // ----------------------------------------------------------------
    let query: string;
    let previousResponseId: string | undefined;
    let previousConversionId: string | undefined;
    let conversationId: string | undefined;
    try {
      const body = await req.json();
      query = body.query;
      previousResponseId = body.previousResponseId;
      previousConversionId = body.previousConversionId;
      conversationId = body.conversationId;

      if (!query || typeof query !== "string") {
        return new Response(
          JSON.stringify({ error: "Missing or invalid 'query' field" }),
          { status: 400, headers: { "Content-Type": "application/json" } },
        );
      }
    } catch {
      return new Response(
        JSON.stringify({ error: "Invalid JSON body" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    // ----------------------------------------------------------------
    // 6. Log the request
    // ----------------------------------------------------------------
    console.log(
      `[Chat] Request from user ${userId}: "${query}"${
        previousResponseId ? ` (follow-up to ${previousResponseId})` : ""
      }${conversationId ? ` (conversation ${conversationId})` : ""}`,
    );

    // ----------------------------------------------------------------
    // 7. Run pipeline and return SSE stream
    // ----------------------------------------------------------------
    return runPipeline({
      query,
      userId,
      previousResponseId,
      previousConversionId,
      conversationId,
    });
  }),
);

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Run `supabase functions serve chat --env-file ./supabase/functions/.env`
  3. Make an HTTP request (first question):

  curl -N --location --request POST 'http://127.0.0.1:54321/functions/v1/chat' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"query":"How many activities did I log this week?"}'

  4. For follow-up questions, use the responseId and conversionId from the previous response:

  curl -N --location --request POST 'http://127.0.0.1:54321/functions/v1/chat' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"query":"What about last week?", "previousResponseId":"resp_abc123", "previousConversionId":"conv_abc123"}'

*/
