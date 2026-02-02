---
phase: 01-edge-function
plan: 03
subsystem: api
tags: [deno, typescript, supabase, edge-function, postgres, rate-limiting, sse, integration]

# Dependency graph
requires:
  - phase: 01-01
    provides: "Foundation files: schema, prompts, security validation, SSE stream handler"
  - phase: 01-02
    provides: "Pipeline files: rate limiter, query executor, SQL generator, response generator, orchestrator"
provides:
  - "chat edge function entry point with auth/subscription/rate-limit/body-parsing gates"
  - "Deno config for chat function"
  - "Postgres-based rate limiting via chat_rate_limits table"
  - "SQL validation with trailing semicolon handling and relaxed injection patterns"
  - "User ID injection into NL-to-SQL prompt for correct filtering"
  - "supabase config.toml entry for chat function"
affects: []

# Tech tracking
tech-stack:
  added:
    - "jsr:@db/postgres (Postgres client for rate limiting)"
  removed:
    - "npm:@upstash/ratelimit (replaced by Postgres-based rate limiting)"
    - "npm:@upstash/redis (no longer needed)"
  patterns:
    - "Postgres-based rate limiting with hourly window upserts (ON CONFLICT)"
    - "User ID injected into LLM prompt for correct WHERE clauses"
    - "Trailing semicolon stripping in SQL validation"
    - "JWT claims set before role switch for reliable auth.uid() resolution"

key-files:
  created:
    - supabase/functions/chat/index.ts
    - supabase/functions/chat/deno.json
    - supabase/migrations/20260202000000_create_chat_rate_limits.sql
  modified:
    - supabase/functions/chat/rateLimit.ts
    - supabase/functions/chat/security.ts
    - supabase/functions/chat/prompts.ts
    - supabase/functions/chat/sqlGenerator.ts
    - supabase/functions/chat/queryExecutor.ts
    - supabase/functions/chat/pipeline.ts
    - supabase/config.toml

key-decisions:
  - "Replaced Upstash Redis rate limiting with Postgres-based approach using chat_rate_limits table"
  - "User ID injected directly into NL-to-SQL prompt instead of relying on CURRENT_USER or auth.uid() in SQL"
  - "Trailing semicolons stripped from generated SQL before validation (LLMs commonly append them)"
  - "INTO removed from dangerous keywords (INSERT already covers INSERT INTO)"
  - "SQL comment injection pattern relaxed to only block mid-query comments (allow trailing -- comments)"
  - "JWT claims set before SET LOCAL ROLE switch for reliable session config"
  - "Sunday-start week calculation pattern added to prompt with explicit formula"

patterns-established:
  - "Postgres rate limiting: upsert with ON CONFLICT on (user_id, window_start) for atomic counter increment"
  - "Dynamic prompt building: buildNlToSqlInstructions(userId) instead of static prompt constant"
  - "SQL validation preprocessing: strip trailing semicolons before pattern matching"

# Metrics
completed: 2026-02-02
---

# Phase 1 Plan 3: Entry Point & Integration Summary

**Chat edge function entry point with Postgres-based rate limiting, SQL validation hardening, and verified end-to-end pipeline**

## Accomplishments
- Edge function entry point with auth -> subscription -> rate limit -> parse -> pipeline flow
- Replaced Upstash Redis rate limiting with Postgres-based approach (no external dependency)
- Fixed SQL validation false positives: trailing semicolons, INTO keyword, comment patterns
- Injected user ID into NL-to-SQL prompt for correct WHERE user_id filtering
- Added explicit Sunday-start week calculation formula to prompt
- Fixed JWT claim setup ordering (before role switch) for reliable auth.uid()
- Verified full pipeline end-to-end: natural language question -> SQL -> execution -> streaming response

## Task Commits

1. **Task 1: Create entry point and Deno config** - `3234b47` (feat)
2. **Rate limiter rewrite** - `916dbb2` (refactor)
3. **SQL validation fixes** - `f7da90b`, `8e446af` (fix)
4. **User ID prompt injection** - `5dbc3e9` (fix)
5. **Week calculation fix** - `d78f809` (fix)
6. **Query executor fix** - `5534900` (fix)
7. **Debug cleanup** - `53a63fc` (chore)

## Files Created/Modified
- `supabase/functions/chat/index.ts` - Entry point with auth/sub/rate-limit/body gates
- `supabase/functions/chat/deno.json` - Deno config for chat function
- `supabase/functions/chat/rateLimit.ts` - Rewritten from Upstash to Postgres-based
- `supabase/functions/chat/security.ts` - Relaxed validation, trailing semicolon handling
- `supabase/functions/chat/prompts.ts` - Dynamic prompt with user ID, Sunday-start weeks
- `supabase/functions/chat/sqlGenerator.ts` - Uses buildNlToSqlInstructions(userId)
- `supabase/functions/chat/queryExecutor.ts` - JWT claims before role switch
- `supabase/functions/chat/pipeline.ts` - Cleaned up error messages
- `supabase/config.toml` - Added [functions.chat] section
- `supabase/migrations/20260202000000_create_chat_rate_limits.sql` - Rate limit table

## Deviations from Plan

1. **Upstash -> Postgres**: Rate limiting switched from Upstash Redis to Postgres-based approach to eliminate external dependency
2. **SQL validation hardening**: Multiple fixes needed for LLM-generated SQL patterns (trailing semicolons, INTO keyword, comment patterns)
3. **User ID in prompt**: Changed from RLS-only scoping to explicit user_id filtering in generated SQL
4. **JWT claim ordering**: Moved set_config calls before SET LOCAL ROLE for reliable auth context

## Issues Encountered

1. **SQL validation false positive**: Generated SQL ended with semicolons, triggering the trailing semicolon injection pattern
2. **CURRENT_USER mismatch**: LLM used CURRENT_USER (Postgres role name) instead of UUID for user_id filter
3. **Week calculation**: Postgres date_trunc('week') starts Monday; needed explicit Sunday-start formula

## Verified Behavior
- POST with valid JWT returns SSE stream with step events, text deltas, and done signal
- Natural language questions produce correct SQL, execute, and return friendly responses
- Rate limiting uses Postgres chat_rate_limits table with hourly windows

---
*Phase: 01-edge-function*
*Completed: 2026-02-02*
