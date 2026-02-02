# Requirements: Logly AI Chat

**Defined:** 2026-02-02
**Core Value:** Users can ask natural language questions about their logged data and get friendly, encouraging, data-backed responses

## v1 Requirements

### Edge Function

- [ ] **EDGE-01**: New `chat` Supabase edge function with text-to-SQL pipeline
- [ ] **EDGE-02**: Accepts natural language question and converts to Postgres query via OpenAI GPT
- [ ] **EDGE-03**: Executes generated SQL read-only against user-scoped data
- [ ] **EDGE-04**: Analyzes query results and generates friendly, encouraging response
- [ ] **EDGE-05**: Streams response via SSE (step progress events + response text)
- [ ] **EDGE-06**: Supports multi-turn context via OpenAI's `previous_response_id`
- [ ] **EDGE-07**: Dedicated read-only Postgres role with RLS enforcement
- [ ] **EDGE-08**: Statement timeout on generated queries

### Data Pipeline

- [ ] **PIPE-01**: SSE stream connection from Flutter client to `chat` edge function
- [ ] **PIPE-02**: Auth token (JWT) forwarded to edge function
- [ ] **PIPE-03**: Stream timeout and disconnect handling

### Chat UI

- [ ] **CHAT-01**: Dedicated chat screen using `flutter_chat_ui` with flat layout (no message bubbles)
- [ ] **CHAT-02**: Streaming text display with token-by-token rendering
- [ ] **CHAT-03**: Markdown rendering in AI responses
- [ ] **CHAT-04**: Step progress indicators — spinner + friendly label while in progress, checkmark when done
- [ ] **CHAT-05**: Steps and streaming response are sequential within the same message (steps above, response below)
- [ ] **CHAT-06**: Only one progress section visible at a time — previous message's steps removed when new message sent
- [ ] **CHAT-07**: Steps use consumer-friendly labels (not technical descriptions)
- [ ] **CHAT-08**: Loading, error, and empty states handled gracefully
- [ ] **CHAT-09**: Suggested follow-up questions after each AI response

### Conversation

- [ ] **CONV-01**: Multi-turn conversations with context retention
- [ ] **CONV-02**: Chat history persisted in Supabase

### Discovery

- [ ] **DISC-01**: Suggested starter questions shown on empty chat
- [ ] **DISC-02**: Chat accessible via existing LoglyAI button on profile screen

### Access Control

- [ ] **ACCS-01**: Chat gated behind pro subscription

### Observability

- [ ] **OBSV-01**: Log generated SQL for each user query
- [ ] **OBSV-02**: Track duration of SQL generation (NL → SQL via OpenAI)
- [ ] **OBSV-03**: Track duration of SQL query execution
- [ ] **OBSV-04**: Track duration of response generation (results → friendly response via OpenAI)
- [ ] **OBSV-05**: Log token usage (input + output) for every OpenAI API call
- [ ] **OBSV-06**: All metrics stored in Supabase for reporting

## v2 Requirements

### Conversation Management

- **CONV-03**: Conversation history list (browse past conversations)
- **CONV-04**: Conversation deletion
- **CONV-05**: Conversation search

### Discovery Enhancements

- **DISC-03**: Personalized starter questions based on user's activity types
- **DISC-04**: Deep links from stats screens ("Ask AI about this")

### Access Control Enhancements

- **ACCS-02**: Per-user rate limiting to control API costs
- **ACCS-03**: Usage indicator (messages remaining)
- **ACCS-04**: Free user teaser (preview chat, prompt upgrade)

### Security Hardening

- **SECR-01**: SQL validation hardening beyond regex (structured parser)
- **SECR-02**: Table/column allowlisting

### Offline

- **OFFL-01**: Local caching of past responses for offline viewing

## Out of Scope

| Feature | Reason |
|---------|--------|
| Voice input | Text input sufficient for v1 |
| Chart/image generation in responses | Text-based analysis for v1 |
| Proactive AI notifications | Build reactive chat first |
| Chat export or sharing | No clear user need yet |
| Reuse of existing `ai-insights` edge function | Building fresh `chat` function instead |
| Message reactions (thumbs up/down) | Defer until usage patterns understood |
| Real-time streaming from multiple data sources | Single Postgres source for v1 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| EDGE-01 | — | Pending |
| EDGE-02 | — | Pending |
| EDGE-03 | — | Pending |
| EDGE-04 | — | Pending |
| EDGE-05 | — | Pending |
| EDGE-06 | — | Pending |
| EDGE-07 | — | Pending |
| EDGE-08 | — | Pending |
| PIPE-01 | — | Pending |
| PIPE-02 | — | Pending |
| PIPE-03 | — | Pending |
| CHAT-01 | — | Pending |
| CHAT-02 | — | Pending |
| CHAT-03 | — | Pending |
| CHAT-04 | — | Pending |
| CHAT-05 | — | Pending |
| CHAT-06 | — | Pending |
| CHAT-07 | — | Pending |
| CHAT-08 | — | Pending |
| CHAT-09 | — | Pending |
| CONV-01 | — | Pending |
| CONV-02 | — | Pending |
| DISC-01 | — | Pending |
| DISC-02 | — | Pending |
| ACCS-01 | — | Pending |
| OBSV-01 | — | Pending |
| OBSV-02 | — | Pending |
| OBSV-03 | — | Pending |
| OBSV-04 | — | Pending |
| OBSV-05 | — | Pending |
| OBSV-06 | — | Pending |

**Coverage:**
- v1 requirements: 31 total
- Mapped to phases: 0
- Unmapped: 31 ⚠️

---
*Requirements defined: 2026-02-02*
*Last updated: 2026-02-02 after initial definition*
