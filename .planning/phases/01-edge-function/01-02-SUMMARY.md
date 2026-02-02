---
phase: 01-edge-function
plan: 02
subsystem: api
tags: [deno, typescript, openai, gpt-4o-mini, upstash, redis, rate-limiting, rls, postgres, sse, text-to-sql, streaming]

# Dependency graph
requires:
  - phase: 01-01
    provides: "Foundation files: schema, prompts, security validation, SSE stream handler"
provides:
  - "checkRateLimit function for per-user Upstash Redis rate limiting (20/hour sliding window)"
  - "executeWithRLS function for RLS-enforced SQL execution with statement timeout"
  - "generateSQL function for NL-to-SQL conversion with off-topic detection and self-correction"
  - "generateStreamingResponse function for token-by-token streaming response via OpenAI"
  - "runPipeline orchestrator connecting all pipeline steps with SSE progress events"
  - "PipelineInput interface for edge function entry point integration"
affects: [01-03-PLAN]

# Tech tracking
tech-stack:
  added:
    - "npm:@upstash/ratelimit (sliding window rate limiting)"
    - "npm:@upstash/redis (Redis client for Upstash)"
  patterns:
    - "Fail-open rate limiting: Redis outage does not block chat requests"
    - "RLS enforcement via SET LOCAL ROLE authenticated + dual JWT claim config in transaction"
    - "Discriminated union schema for NL-to-SQL output (offTopic: true/false)"
    - "Self-correction retry for structured output parse failures"
    - "Pipeline orchestrator with async background execution and immediate Response return"

key-files:
  created:
    - supabase/functions/chat/rateLimit.ts
    - supabase/functions/chat/queryExecutor.ts
    - supabase/functions/chat/sqlGenerator.ts
    - supabase/functions/chat/responseGenerator.ts
    - supabase/functions/chat/pipeline.ts
  modified: []

key-decisions:
  - "Fail-open rate limiting: if Upstash Redis is unreachable, requests are allowed through (logged for monitoring)"
  - "UUID validation on userId before SQL interpolation for defense-in-depth"
  - "Off-topic redirect sent as text_delta event so it renders as a chat message in the UI"
  - "runPipeline returns synchronous Response (not async) for immediate SSE stream start"
  - "conversion_id sent before step complete to ensure client has it for follow-up chaining"

patterns-established:
  - "Rate limiting: module-level Ratelimit instance for connection reuse across warm invocations"
  - "RLS execution: BEGIN -> SET LOCAL timeout -> SET LOCAL ROLE -> set_config claims -> query -> COMMIT"
  - "SQL generation: Zod schema for runtime validation + manual JSON schema for OpenAI text.format"
  - "Response streaming: jsonToCsv helper for token-efficient data context"
  - "Pipeline: (async () => { ... })() pattern with immediate Response return"

# Metrics
duration: 5min
completed: 2026-02-02
---

# Phase 1 Plan 2: Pipeline Files Summary

**NL-to-SQL pipeline with Upstash rate limiting, RLS-enforced query execution, GPT-4o-mini SQL generation with off-topic detection, streaming response generation, and 2-step progress orchestrator**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-02T15:57:02Z
- **Completed:** 2026-02-02T16:01:58Z
- **Tasks:** 2
- **Files created:** 5

## Accomplishments
- Per-user rate limiting via Upstash Redis with 20 requests/hour sliding window and fail-open strategy
- RLS-enforced SQL execution with authenticated role switching, dual JWT claim formats, 10s statement timeout, and 100-row limit
- NL-to-SQL conversion with GPT-4o-mini structured output, discriminated union for off-topic detection, and self-correction retry on parse failure
- Streaming response generation with encouraging coach personality and CSV-based token optimization for query results
- Pipeline orchestrator with exactly 2 user-visible progress steps, off-topic handling, and comprehensive error messages

## Task Commits

Each task was committed atomically:

1. **Task 1: Create rate limiter and query executor** - `e5d66e5` (feat)
2. **Task 2: Create SQL generator, response generator, and pipeline orchestrator** - `71ccee2` (feat)

## Files Created/Modified
- `supabase/functions/chat/rateLimit.ts` - Per-user rate limiting via Upstash Redis (checkRateLimit export)
- `supabase/functions/chat/queryExecutor.ts` - RLS-enforced SQL execution with statement timeout (executeWithRLS export)
- `supabase/functions/chat/sqlGenerator.ts` - NL-to-SQL conversion with off-topic detection (generateSQL, hashUserId exports)
- `supabase/functions/chat/responseGenerator.ts` - Streaming friendly response via OpenAI (generateStreamingResponse export)
- `supabase/functions/chat/pipeline.ts` - Pipeline orchestrator wiring all steps together (runPipeline export, PipelineInput interface)

## Decisions Made
- **Fail-open rate limiting**: If Upstash Redis is unreachable, the request is allowed through and the error is logged. This prevents a Redis outage from taking down the entire chat feature. The alternative (fail-closed) would make chat availability dependent on Redis.
- **Off-topic redirect as text_delta**: When the LLM detects an off-topic question, the redirect message is sent as a `text_delta` event rather than an `error` event. This renders it as a normal chat message in the UI, which feels friendlier.
- **Synchronous Response return**: `runPipeline()` returns a `Response` (not `Promise<Response>`) by running the pipeline in an immediately-invoked async function. This ensures the SSE stream starts immediately without awaiting the first pipeline step.
- **conversion_id sent before step complete**: The conversion_id event is sent before the "Understanding your question..." step completes, ensuring the client has the SQL context chain ID as early as possible for follow-up support.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - environment variables for Upstash Redis (UPSTASH_REDIS_REST_URL, UPSTASH_REDIS_REST_TOKEN) will be configured during deployment, not during development.

## Next Phase Readiness
- All five pipeline files are importable and ready for Plan 03 (entry point integration)
- pipeline.ts imports from all foundation files (prompts, security, streamHandler) and pipeline files (sqlGenerator, queryExecutor, responseGenerator)
- All files pass `deno check` with zero type errors
- PipelineInput interface matches the expected shape from the entry point pattern in RESEARCH.md
- runPipeline returns a Response directly (not async), matching the expected usage in index.ts

---
*Phase: 01-edge-function*
*Completed: 2026-02-02*
