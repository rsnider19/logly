# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-02-02)

**Core value:** Users can ask natural language questions about their logged data and get friendly, encouraging, data-backed responses
**Current focus:** Phase 4 - Conversation & Discovery

## Current Position

Phase: 4 of 5 (Conversation & Discovery)
Plan: 0 of 3 in current phase (not started)
Status: Ready to plan
Last activity: 2026-02-03 -- Phase 3 (Chat Screen) complete and verified

Progress: [█████████████████░░░] 85%

## Performance Metrics

**Velocity:**
- Total plans completed: 9
- Total execution time: ~40 min

**By Phase:**

| Phase | Plans | Status |
|-------|-------|--------|
| 01-edge-function | 3/3 | Complete |
| 02-stream-client | 2/2 | Complete |
| 03-chat-screen | 4/4 | Complete |

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
- [02-02]: Property access over destructuring in switch cases to avoid variable shadowing
- [02-02]: unawaited() wrapper for StreamController.close() in non-async methods
- [02-02]: Callback-based state emission (onStateUpdate) from service to notifier pattern
- [03-01]: TextStreamMessage.metadata map used as data channel for step progress and stream status
- [03-01]: Error handling removes user+AI messages, inserts system message, stores query for input restoration
- [03-01]: Fire-and-forget stream trigger with unawaited(), state arrives via ref.listen
- [03-01]: Cancellation flag checked in both SSE event loop and typewriter drain loop
- [03-02]: Added provider as direct dependency for ComposerHeightNotifier access from flutter_chat_ui
- [03-02]: Custom composer uses Positioned in Chat Stack with height reporting via addPostFrameCallback
- [03-02]: StreamState mapping: domain ChatStreamState -> package StreamState for FlyerChatTextStreamMessage
- [03-02]: unawaited() for sendMessage in _handleSendMessage to satisfy discarded_futures lint
- [03-03]: Parent-owned TextEditingController in ChatScreen for persistence across composer rebuilds
- [03-03]: ref.listen on chatStreamStateProvider for error transition detection and query restoration
- [03-03]: _textController.clear() in parent _handleSendMessage for suggestion chip send support
- [03-04]: 16ms base interval matches 60fps frame timing for smoother animation
- [03-04]: 5 chars per tick reduces state updates from ~200/sec to ~60/sec
- [03-04]: addPostFrameCallback ensures cross-listener ordering without coupling providers

### Pending Todos

None.

### Blockers/Concerns

- [Research]: SSE reconnection edge cases on iOS need empirical testing

## Session Continuity

Last session: 2026-02-03
Stopped at: Phase 3 complete, ready to plan Phase 4
Resume file: None
