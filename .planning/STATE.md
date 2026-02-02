# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-02)

**Core value:** Users can ask natural language questions about their logged data and get friendly, encouraging, data-backed responses
**Current focus:** Phase 2 - Stream Client

## Current Position

Phase: 2 of 5 (Stream Client)
Plan: 1 of 2 in current phase
Status: In progress
Last activity: 2026-02-02 -- Completed 02-01-PLAN.md (Domain Models & SSE Data Layer)

Progress: [██████░░░░░░░░░░░░░░] 30%

## Performance Metrics

**Velocity:**
- Total plans completed: 4
- Total execution time: ~21 min

**By Phase:**

| Phase | Plans | Status |
|-------|-------|--------|
| 01-edge-function | 3/3 | Complete |
| 02-stream-client | 1/2 | In progress |

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- [Roadmap]: Backend `chat` edge function built from scratch (not reusing `ai-insights`)
- [Roadmap]: Flutter chat UI uses `flutter_chat_ui` with flat layout, ChatGPT/Claude style
- [Roadmap]: Step progress shown inline within the AI message (spinners then checkmarks, streaming text below)
- [Roadmap]: Observability is a distinct phase with its own backend logging concerns
- [01-01]: Off-topic detection handled in SQL generation prompt via structured JSON output
- [01-01]: SSE protocol uses start/complete step status, text_delta events, and done completion signal
- [01-02]: Off-topic redirect sent as text_delta event (renders as chat message, not error)
- [01-02]: runPipeline returns synchronous Response for immediate SSE stream start
- [01-02]: conversion_id sent before step complete for early follow-up chain availability
- [01-03]: Replaced Upstash Redis rate limiting with Postgres-based approach (chat_rate_limits table)
- [01-03]: User ID injected into NL-to-SQL prompt for explicit WHERE user_id filtering
- [01-03]: JWT claims set before SET LOCAL ROLE switch for reliable auth.uid()
- [01-03]: SQL validation strips trailing semicolons (LLMs commonly append them)
- [01-03]: Sunday-start week calculation formula added to prompt
- [02-01]: Used @JsonKey for camelCase server fields (responseId, conversionId) to override global snake_case config
- [02-01]: Cast response.data as Stream<List<int>> instead of http.ByteStream to avoid transitive dependency import
- [02-01]: Null-aware map element syntax (?value) for optional request body fields in Dart 3.10

### Pending Todos

None.

### Blockers/Concerns

- [Research]: SSE reconnection edge cases on iOS need empirical testing

## Session Continuity

Last session: 2026-02-02
Stopped at: Completed 02-01-PLAN.md (Domain Models & SSE Data Layer)
Resume file: None
