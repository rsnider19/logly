/**
 * Per-user rate limiting via Postgres.
 *
 * Uses an hourly window with a counter in the `chat_rate_limits` table
 * (20 requests per hour per user) to prevent abuse of the chat function.
 *
 * Fail-open strategy: if Postgres is unreachable, the request is
 * allowed through and the error is logged. This prevents a database
 * issue from taking down the entire chat feature.
 *
 * Environment variables required:
 * - SUPABASE_DB_URL
 */

import { Client } from "jsr:@db/postgres";

/** Maximum requests allowed per hourly window. */
const MAX_REQUESTS_PER_HOUR = 20;

/**
 * Result of a rate limit check.
 *
 * @property allowed - Whether the request is within the rate limit
 * @property resetMs - Timestamp (epoch ms) when the limit resets (only present when blocked)
 */
export interface RateLimitResult {
  allowed: boolean;
  resetMs?: number;
}

/**
 * Checks whether the given user is within the rate limit.
 *
 * Uses an upsert on `chat_rate_limits` keyed by (user_id, window_start)
 * where window_start is truncated to the current hour. If the count
 * exceeds MAX_REQUESTS_PER_HOUR, the request is blocked.
 *
 * Fail-open: if Postgres is unreachable, logs the error and allows the request.
 *
 * @param userId - The authenticated user's ID
 * @returns RateLimitResult indicating whether the request is allowed
 */
export async function checkRateLimit(userId: string): Promise<RateLimitResult> {
  const client = new Client(Deno.env.get("SUPABASE_DB_URL"));

  try {
    await client.connect();

    // Upsert: increment the counter for the current hour window,
    // or insert a new row with count=1 if none exists.
    // Returns the current count and window_start after the upsert.
    const result = await client.queryObject<{ request_count: number; window_start: string }>`
      INSERT INTO public.chat_rate_limits (user_id, window_start, request_count)
      VALUES (${userId}::uuid, date_trunc('hour', now()), 1)
      ON CONFLICT (user_id, window_start)
      DO UPDATE SET request_count = chat_rate_limits.request_count + 1
      RETURNING request_count, window_start
    `;

    const { request_count, window_start } = result.rows[0];

    if (request_count > MAX_REQUESTS_PER_HOUR) {
      // Calculate when the current window expires (window_start + 1 hour)
      const resetMs = new Date(window_start).getTime() + 60 * 60 * 1000;
      return { allowed: false, resetMs };
    }

    return { allowed: true };
  } catch (err) {
    // Fail open: if Postgres is down, allow the request and log the error
    console.error("[RateLimit] Postgres error (failing open):", err);
    return { allowed: true };
  } finally {
    await client.end();
  }
}
