---
phase: 05-observability
plan: 01
subsystem: database
tags: [postgresql, telemetry, observability, rls, supabase]

# Dependency graph
requires:
  - phase: 04-conversation-discovery
    provides: chat_conversations table for FK reference
provides:
  - chat_telemetry_log table with 27 columns for all metrics
  - TelemetryRecord interface and persistTelemetry function
  - Example SQL queries for cost, latency, and error reporting
affects: [05-02-pipeline-integration]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Denormalized telemetry table (one row per request)"
    - "BEFORE INSERT trigger for computed columns"
    - "Service role only RLS (no user policies)"
    - "Fire-and-forget persistence pattern"

key-files:
  created:
    - supabase/migrations/20260204000000_create_chat_telemetry_log.sql
    - supabase/functions/chat/telemetry.ts
    - supabase/snippets/observability_reports.sql
  modified: []

key-decisions:
  - "sql_fingerprint computed by database trigger (not edge function)"
  - "All timing/token columns NULLABLE for partial failure support"
  - "No user-facing RLS policies (service role only access)"
  - "Token prices as CTE in report queries (not stored in table)"

patterns-established:
  - "Telemetry persistence is non-blocking and never throws"
  - "Fingerprint uses md5(lower(regexp_replace(sql, whitespace))) for pattern grouping"

# Metrics
duration: 3min
completed: 2026-02-03
---

# Phase 5 Plan 1: Telemetry Schema & Persistence Summary

**Denormalized chat_telemetry_log table with 27 columns, trigger-based SQL fingerprinting, and fire-and-forget persistence module**

## Performance

- **Duration:** 3 min
- **Started:** 2026-02-03T20:01:08Z
- **Completed:** 2026-02-03T20:03:47Z
- **Tasks:** 3
- **Files created:** 3

## Accomplishments

- Created `chat_telemetry_log` table with all metrics from CONTEXT.md (identifiers, content, errors, flags, models, timing, tokens)
- Implemented `TelemetryRecord` interface and `persistTelemetry` function following existing persistence.ts patterns
- Documented 7 SQL report queries covering cost, latency, errors, per-user stats, SQL patterns, off-topic rate, and model comparison

## Task Commits

Each task was committed atomically:

1. **Task 1: Create chat_telemetry_log migration** - `b45b6cf` (feat)
2. **Task 2: Create telemetry persistence module** - `c902a63` (feat)
3. **Task 3: Create observability report queries** - `78f5f26` (feat)

## Files Created/Modified

- `supabase/migrations/20260204000000_create_chat_telemetry_log.sql` - Telemetry table schema with 27 columns, 4 indexes, fingerprint trigger, service-role-only RLS
- `supabase/functions/chat/telemetry.ts` - TelemetryRecord interface and persistTelemetry function with fire-and-forget pattern
- `supabase/snippets/observability_reports.sql` - 7 documented SQL queries for dashboard reporting

## Decisions Made

1. **Fingerprint computed by trigger** - Simpler edge function code, consistent computation, eliminates need for Deno crypto
2. **No user policies** - RLS enabled but no SELECT/INSERT policies for authenticated role; service role bypasses RLS
3. **Token prices in CTE** - Prices ($0.15/1M input, $0.60/1M output for gpt-4o-mini) embedded in queries, easy to update

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Deno not installed in execution environment, could not run `deno check`. Verified telemetry.ts follows exact same patterns as existing persistence.ts which is confirmed working in production.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Telemetry schema ready for pipeline integration
- Next plan (05-02) will wire telemetry capture into chat pipeline
- All exports (TelemetryRecord, persistTelemetry) ready to import

---
*Phase: 05-observability*
*Completed: 2026-02-03*
