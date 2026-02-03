---
phase: 05-observability
plan: 02
subsystem: backend
tags: [telemetry, observability, tokens, timing, pipeline, openai]

# Dependency graph
requires:
  - phase: 05-01
    provides: chat_telemetry_log table and persistTelemetry function
provides:
  - Token usage capture from OpenAI responses (SQL and response generators)
  - Complete pipeline telemetry integration with timing and TTFB
  - Error tracking for all failure paths
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Token usage extraction from OpenAI usage object"
    - "TTFB measurement from request start to first text delta"
    - "Fire-and-forget telemetry persistence in finally block"
    - "Partial failure support with nullable telemetry fields"

key-files:
  created: []
  modified:
    - supabase/functions/chat/sqlGenerator.ts
    - supabase/functions/chat/responseGenerator.ts
    - supabase/functions/chat/pipeline.ts

key-decisions:
  - "Token usage extracted from OpenAI response.usage object including cached_tokens"
  - "TTFB calculated from absolute request start (not response generation start)"
  - "Telemetry persisted as fire-and-forget in finally block (never blocks response)"
  - "Error telemetry captures partial timing for failed steps"

patterns-established:
  - "Generator functions return usage alongside response data"
  - "Pipeline captures timing around each async operation"
  - "Telemetry as Partial<TelemetryRecord> during execution, cast at persist time"

# Metrics
duration: 4min
completed: 2026-02-03
---

# Phase 5 Plan 2: Telemetry Pipeline Integration Summary

**Token usage and timing capture integrated into chat pipeline with fire-and-forget persistence**

## Performance

- **Duration:** 4 min
- **Started:** 2026-02-03T20:05:00Z
- **Completed:** 2026-02-03T20:09:29Z
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments

- Modified `sqlGenerator.ts` to return token usage (input, output, cached tokens) from OpenAI API
- Modified `responseGenerator.ts` to extract and return token usage from streaming completion event
- Integrated complete telemetry capture into `pipeline.ts` with timing for all three pipeline steps
- Implemented TTFB measurement from request start to first text delta
- Added error telemetry for all failure paths (sql_generation, sql_validation, sql_execution, response_generation, unexpected)

## Task Commits

Each task was committed atomically:

1. **Task 1: Add token usage to SQL generator** - `564c593` (feat)
2. **Task 2: Add token usage to response generator** - `a1cd80d` (feat)
3. **Task 3: Integrate telemetry capture into pipeline** - `4c4f660` (feat)

## Files Created/Modified

- `supabase/functions/chat/sqlGenerator.ts` - Added `usage` field to `GenerateSQLResult` interface, extract tokens from response
- `supabase/functions/chat/responseGenerator.ts` - Added `usage` field to `ResponseGeneratorResult`, extract from `response.completed` event
- `supabase/functions/chat/pipeline.ts` - Full telemetry integration: timing capture, token extraction, TTFB, error tracking, fire-and-forget persistence

## Decisions Made

1. **Token extraction from OpenAI response** - Use `response.usage?.input_tokens`, `output_tokens`, and `input_tokens_details?.cached_tokens` with nullish coalescing to 0
2. **Self-correction path handling** - When SQL generation triggers self-correction, extract usage from the repair response instead
3. **TTFB from absolute start** - Capture `performance.now()` at request start (before any async work), not at response generation start

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Deno not installed in execution environment, could not run `deno check`. Verified code follows existing TypeScript patterns and consistent with working codebase.

## User Setup Required

None - this plan only modifies edge function code.

## Next Phase Readiness

- Phase 5 Observability complete
- Every chat request now produces a telemetry log record with:
  - Generated SQL and fingerprint (computed by trigger)
  - Three duration measurements (NL-to-SQL, SQL execution, response generation)
  - Token usage from both OpenAI calls
  - TTFB (time to first byte)
  - Error tracking with partial failure support
- Report queries documented in `supabase/snippets/observability_reports.sql`

---
*Phase: 05-observability*
*Completed: 2026-02-03*
