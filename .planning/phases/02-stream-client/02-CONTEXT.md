# Phase 2: Stream Client - Context

**Gathered:** 2026-02-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Flutter data layer that opens an authenticated SSE connection to the `chat` edge function and parses the stream into typed domain events (`ChatEvent`) for the UI layer to consume. This phase covers the SSE client, event parsing, typewriter text buffering, and connection lifecycle. It does NOT cover UI rendering, chat history persistence, or conversation management — those are Phases 3 and 4.

</domain>

<decisions>
## Implementation Decisions

### Follow-up chaining
- Single conversation at a time — no concurrent chats
- Opening chat fresh = new conversation with no previous IDs (Phase 4 adds persistence)
- Previous response_id and conversion_id are preserved across failed requests — user can retry a failed follow-up without losing context
- New questions are blocked while a response is still streaming — no cancellation/overlap
- Off-topic redirects (sent as text_delta by server) pass through as normal text — no special client-side detection
- Trust the server for ID presence — if response_id or conversion_id is missing, they're null. No client-side validation or warning

### Typewriter text buffering
- Client buffers incoming text_delta events and emits text to the UI one character every 5ms (typewriter effect)
- Fixed 5ms rate regardless of response length
- After the `done` event arrives, speed up the drip rate (e.g., 1ms/char) to finish remaining buffer quickly but still animate
- Step events (start/complete) are emitted instantly with no artificial timing

### Connection lifecycle
- Auto-retry once on network drop (silent to user). If retry also fails, surface an error event
- Retry resends the original question from scratch — partial response is discarded, fresh request
- No wall-clock timeout. Instead, stall detection: if no SSE event arrives for 30 seconds, treat the connection as dead
- Stall triggers the same auto-retry logic (one silent retry, then error)

### Claude's Discretion
- State ownership: whether the stream client holds conversation IDs internally or passes them through to a higher-layer service (pick what fits the repository/service pattern)
- ID timing: whether conversion_id and response_id are emitted as real-time stream events or surfaced after completion
- Full text access: whether to expose a running full-text property alongside the character drip (pick what fits Riverpod state pattern)
- Stream API shape: single `Stream<ChatEvent>` vs callbacks vs other pattern — pick what's idiomatic for the codebase
- Event model design: sealed class hierarchy, granularity of types — pick what's cleanest

</decisions>

<specifics>
## Specific Ideas

- Typewriter effect should feel like ChatGPT/Claude — characters appearing smoothly, not in chunks
- The 5ms/char rate is intentional: consistent, readable pace that doesn't rush the user
- Speed-up after `done` should feel like "catching up" — noticeably faster but not instant dump

</specifics>

<deferred>
## Deferred Ideas

- Multiple concurrent conversations — out of scope, single chat only
- Conversation persistence / restoring previous chat — Phase 4
- Chat history management — Phase 4

</deferred>

---

*Phase: 02-stream-client*
*Context gathered: 2026-02-02*
