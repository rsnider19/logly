# Requirements Archive: Logly AI Chat v1

**Archived:** 2026-02-03
**Defined:** 2026-02-02
**Core Value:** Users can ask natural language questions about their logged data and get friendly, encouraging, data-backed responses

## v1 Requirements (All Complete)

### Edge Function

- [x] **EDGE-01**: New `chat` Supabase edge function with text-to-SQL pipeline
- [x] **EDGE-02**: Accepts natural language question and converts to Postgres query via OpenAI GPT
- [x] **EDGE-03**: Executes generated SQL read-only against user-scoped data
- [x] **EDGE-04**: Analyzes query results and generates friendly, encouraging response
- [x] **EDGE-05**: Streams response via SSE (step progress events + response text)
- [x] **EDGE-06**: Supports multi-turn context via OpenAI's `previous_response_id`
- [x] **EDGE-07**: Write protection via RLS policies and SQL validation
- [x] **EDGE-08**: Statement timeout on generated queries

### Data Pipeline

- [x] **PIPE-01**: SSE stream connection from Flutter client to `chat` edge function
- [x] **PIPE-02**: Auth token (JWT) forwarded to edge function
- [x] **PIPE-03**: Stream timeout and disconnect handling

### Chat UI

- [x] **CHAT-01**: Dedicated chat screen using `flutter_chat_ui` with flat layout (no message bubbles)
- [x] **CHAT-02**: Streaming text display with token-by-token rendering
- [x] **CHAT-03**: Markdown rendering in AI responses
- [x] **CHAT-04**: Step progress indicators — spinner + friendly label while in progress, checkmark when done
- [x] **CHAT-05**: Steps and streaming response are sequential within the same message (steps above, response below)
- [x] **CHAT-06**: Only one progress section visible at a time — previous message's steps removed when new message sent
- [x] **CHAT-07**: Steps use consumer-friendly labels (not technical descriptions)
- [x] **CHAT-08**: Loading, error, and empty states handled gracefully
- [x] **CHAT-09**: Suggested follow-up questions after each AI response

### Conversation

- [x] **CONV-01**: Multi-turn conversations with context retention
- [x] **CONV-02**: Chat history persisted in Supabase

### Discovery

- [x] **DISC-01**: Suggested starter questions shown on empty chat
- [x] **DISC-02**: Chat accessible via existing LoglyAI button on profile screen

### Access Control

- [x] **ACCS-01**: Chat gated behind pro subscription

### Observability

- [x] **OBSV-01**: Log generated SQL for each user query
- [x] **OBSV-02**: Track duration of SQL generation (NL → SQL via OpenAI)
- [x] **OBSV-03**: Track duration of SQL query execution
- [x] **OBSV-04**: Track duration of response generation (results → friendly response via OpenAI)
- [x] **OBSV-05**: Log token usage (input + output) for every OpenAI API call
- [x] **OBSV-06**: All metrics stored in Supabase for reporting

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| EDGE-01 | Phase 1: Edge Function | Complete |
| EDGE-02 | Phase 1: Edge Function | Complete |
| EDGE-03 | Phase 1: Edge Function | Complete |
| EDGE-04 | Phase 1: Edge Function | Complete |
| EDGE-05 | Phase 1: Edge Function | Complete |
| EDGE-06 | Phase 1: Edge Function | Complete |
| EDGE-07 | Phase 1: Edge Function | Complete |
| EDGE-08 | Phase 1: Edge Function | Complete |
| PIPE-01 | Phase 2: Stream Client | Complete |
| PIPE-02 | Phase 2: Stream Client | Complete |
| PIPE-03 | Phase 2: Stream Client | Complete |
| CHAT-01 | Phase 3: Chat Screen | Complete |
| CHAT-02 | Phase 3: Chat Screen | Complete |
| CHAT-03 | Phase 3: Chat Screen | Complete |
| CHAT-04 | Phase 3: Chat Screen | Complete |
| CHAT-05 | Phase 3: Chat Screen | Complete |
| CHAT-06 | Phase 3: Chat Screen | Complete |
| CHAT-07 | Phase 3: Chat Screen | Complete |
| CHAT-08 | Phase 3: Chat Screen | Complete |
| CHAT-09 | Phase 4: Conversation & Discovery | Complete |
| CONV-01 | Phase 4: Conversation & Discovery | Complete |
| CONV-02 | Phase 4: Conversation & Discovery | Complete |
| DISC-01 | Phase 4: Conversation & Discovery | Complete |
| DISC-02 | Phase 3: Chat Screen | Complete |
| ACCS-01 | Phase 3: Chat Screen | Complete |
| OBSV-01 | Phase 5: Observability | Complete |
| OBSV-02 | Phase 5: Observability | Complete |
| OBSV-03 | Phase 5: Observability | Complete |
| OBSV-04 | Phase 5: Observability | Complete |
| OBSV-05 | Phase 5: Observability | Complete |
| OBSV-06 | Phase 5: Observability | Complete |

## Coverage Summary

- **v1 requirements:** 31 total
- **Shipped:** 31
- **Dropped:** 0
- **Mapped to phases:** 31

## Out of Scope (Deferred to v2+)

| Feature | Reason |
|---------|--------|
| Voice input | Text input sufficient for v1 |
| Chart/image generation in responses | Text-based analysis for v1 |
| Proactive AI notifications | Build reactive chat first |
| Chat export or sharing | No clear user need yet |
| Reuse of existing `ai-insights` edge function | Building fresh `chat` function instead |
| Message reactions (thumbs up/down) | Defer until usage patterns understood |
| Real-time streaming from multiple data sources | Single Postgres source for v1 |

---
*Archived: 2026-02-03*
*Originally defined: 2026-02-02*
