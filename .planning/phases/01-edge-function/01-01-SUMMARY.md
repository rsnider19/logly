---
phase: 01-edge-function
plan: 01
subsystem: api
tags: [deno, typescript, sse, sql-validation, prompt-injection, openai, text-to-sql]

# Dependency graph
requires: []
provides:
  - "COMPRESSED_SCHEMA constant for NL-to-SQL system prompts"
  - "NL_TO_SQL_INSTRUCTIONS with RLS-based scoping, off-topic detection, 100-row limit"
  - "RESPONSE_INSTRUCTIONS with encouraging coach personality and markdown formatting"
  - "validateSqlQuery function for SELECT-only enforcement and injection detection"
  - "sanitizeUserInput function for prompt injection defense"
  - "createProgressStream SSE utility with step/text_delta/response_id/conversion_id/error/done events"
  - "createSSEHeaders utility for standard SSE response headers"
affects: [01-02-PLAN, 01-03-PLAN]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "SSE event protocol: step (start/complete), text_delta, response_id, conversion_id, error, done"
    - "Dual defense layers: SQL validation (regex) + input sanitization (adversarial pattern stripping)"
    - "RLS-based user scoping: no user_id filters in generated SQL"

key-files:
  created:
    - supabase/functions/chat/schema.ts
    - supabase/functions/chat/prompts.ts
    - supabase/functions/chat/security.ts
    - supabase/functions/chat/streamHandler.ts
  modified: []

key-decisions:
  - "RLS-based scoping: NL_TO_SQL_INSTRUCTIONS explicitly tell LLM NOT to filter by user_id"
  - "Off-topic detection handled in SQL generation prompt (not a separate call)"
  - "Step events use start/complete pairs (not in_progress/complete like ai-insights)"
  - "Text streaming uses text_delta event type (not text like ai-insights)"
  - "Added done event as explicit completion signal (not in ai-insights)"
  - "Kept conversion_id event for follow-up SQL context chaining"

patterns-established:
  - "SSE protocol: { type, ...payload } JSON with data: prefix and double newline"
  - "Security: validateSqlQuery returns { valid, error? } interface"
  - "Sanitization: sanitizeUserInput strips then truncates, logs warnings for monitoring"

# Metrics
duration: 5min
completed: 2026-02-02
---

# Phase 1 Plan 1: Foundation Files Summary

**Chat edge function foundation: schema, NL-to-SQL prompts with RLS scoping and off-topic detection, SQL validation with injection blocking, input sanitization, and SSE stream handler with step/text_delta/done protocol**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-02T15:49:09Z
- **Completed:** 2026-02-02T15:54:28Z
- **Tasks:** 2
- **Files created:** 4

## Accomplishments
- Database schema constant ready for embedding in LLM system prompts
- NL-to-SQL instructions with RLS-based user scoping (no user_id filters), off-topic detection, 100-row hard limit, and health disclaimer
- Response instructions with encouraging coach personality, markdown formatting, and health disclaimer support
- SQL validation blocking 16 dangerous keywords with word boundaries plus 7 injection patterns plus 2000 char limit
- Input sanitization stripping 10 adversarial prompt injection patterns with monitoring warnings plus 500 char truncation
- SSE stream handler implementing the exact event protocol from CONTEXT.md decisions

## Task Commits

Each task was committed atomically:

1. **Task 1: Create schema and prompts files** - `c918b7f` (feat)
2. **Task 2: Create security validation and SSE stream handler** - `e336fa1` (feat)

## Files Created/Modified
- `supabase/functions/chat/schema.ts` - Compressed database schema constant (COMPRESSED_SCHEMA) for system prompt embedding
- `supabase/functions/chat/prompts.ts` - NL_TO_SQL_INSTRUCTIONS and RESPONSE_INSTRUCTIONS for the two-call pipeline
- `supabase/functions/chat/security.ts` - validateSqlQuery (SQL safety) and sanitizeUserInput (prompt injection defense)
- `supabase/functions/chat/streamHandler.ts` - createProgressStream (SSE events) and createSSEHeaders utilities

## Decisions Made
- **RLS-based scoping over user_id injection**: Instructions tell the LLM NOT to add user_id filters since RLS handles row scoping. This is a security improvement over ai-insights which relied on LLM-generated WHERE clauses.
- **Off-topic detection in SQL generation prompt**: Handled via structured JSON output (`offTopic: true` with `redirectMessage`) in the same call, avoiding an extra API call.
- **conversion_id event kept**: Despite RESEARCH.md noting it might not be needed, the plan explicitly includes it for follow-up SQL context chaining.
- **Step status naming**: Uses "start"/"complete" instead of ai-insights' "in_progress"/"complete" to match CONTEXT.md spinner/checkmark behavior.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- All four foundation files are importable and ready for Plan 02 (pipeline orchestrator)
- prompts.ts imports schema.ts (cross-file dependency verified)
- security.ts and streamHandler.ts are self-contained (no external dependencies)
- All files pass `deno check` with zero type errors

---
*Phase: 01-edge-function*
*Completed: 2026-02-02*
