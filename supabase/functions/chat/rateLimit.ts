/**
 * Per-user rate limiting via Upstash Redis.
 *
 * Uses a sliding window algorithm (20 requests per hour per user)
 * to prevent abuse of the chat function.
 *
 * The Ratelimit instance is created at module level for connection
 * reuse across warm invocations of the edge function.
 *
 * Fail-open strategy: if Upstash is unreachable, the request is
 * allowed through and the error is logged. This prevents a Redis
 * outage from taking down the entire chat feature.
 *
 * Environment variables required:
 * - UPSTASH_REDIS_REST_URL
 * - UPSTASH_REDIS_REST_TOKEN
 */

import { Ratelimit } from "npm:@upstash/ratelimit";
import { Redis } from "npm:@upstash/redis";

/**
 * Module-level Ratelimit instance for connection reuse across warm invocations.
 * Redis.fromEnv() reads UPSTASH_REDIS_REST_URL and UPSTASH_REDIS_REST_TOKEN.
 */
const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(20, "1 h"),
  analytics: true,
});

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
 * Fail-open: if Upstash is unreachable, logs the error and allows the request.
 *
 * @param userId - The authenticated user's ID
 * @returns RateLimitResult indicating whether the request is allowed
 */
export async function checkRateLimit(userId: string): Promise<RateLimitResult> {
  try {
    const { success, reset } = await ratelimit.limit(userId);

    if (!success) {
      return { allowed: false, resetMs: reset };
    }

    return { allowed: true };
  } catch (err) {
    // Fail open: if Upstash is down, allow the request and log the error
    console.error("[RateLimit] Upstash error (failing open):", err);
    return { allowed: true };
  }
}
