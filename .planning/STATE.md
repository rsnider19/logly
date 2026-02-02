# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-02)

**Core value:** Users can ask natural language questions about their logged data and get friendly, encouraging, data-backed responses
**Current focus:** Phase 2 - Stream Client

## Current Position

Phase: 2 of 5 (Stream Client)
Plan: 0 of TBD in current phase
Status: Not started
Last activity: 2026-02-02 -- Completed Phase 1 (Edge Function)

Progress: [██████░░░░] 20%

## Performance Metrics

**Velocity:**
- Total plans completed: 3
- Total execution time: ~15 min

**By Phase:**

| Phase | Plans | Status |
|-------|-------|--------|
| 01-edge-function | 3/3 | Complete |
| 02-stream-client | 0/? | Not started |

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

### Pending Todos

None yet.

### Blockers/Concerns

- [Research]: SSE reconnection edge cases on iOS need empirical testing

## Session Continuity

Last session: 2026-02-02
Stopped at: Completed Phase 1 (Edge Function)
Resume file: None
