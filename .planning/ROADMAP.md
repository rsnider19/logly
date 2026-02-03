# Roadmap: Logly AI Chat

## Overview

Build an AI-powered chat feature from scratch that lets Logly users ask natural language questions about their logged activity data and receive friendly, data-backed responses. The work spans a new Supabase edge function (text-to-SQL pipeline with SSE streaming), a Flutter client that consumes that stream, a polished chat UI with step progress indicators, multi-turn conversation support with persistence, and server-side observability for cost and quality monitoring. The feature is gated behind the existing pro subscription.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Edge Function** - New `chat` Supabase edge function with text-to-SQL pipeline, SSE streaming, and security guardrails
- [x] **Phase 2: Stream Client** - Flutter data layer with SSE stream parsing, domain models, and auth-forwarded connection to edge function
- [x] **Phase 3: Chat Screen** - Core chat UI with streaming display, step progress, markdown rendering, navigation, and pro gate
- [x] **Phase 4: Conversation & Discovery** - Multi-turn context retention, chat history persistence, starter questions, and follow-up suggestions
- [ ] **Phase 5: Observability** - Server-side logging of generated SQL, durations, token usage, and metrics storage for reporting

## Phase Details

### Phase 1: Edge Function
**Goal**: A deployed Supabase edge function accepts natural language questions, converts them to safe Postgres queries via OpenAI GPT, executes them against user-scoped data, and streams a friendly response back via SSE
**Depends on**: Nothing (first phase)
**Requirements**: EDGE-01, EDGE-02, EDGE-03, EDGE-04, EDGE-05, EDGE-06, EDGE-07, EDGE-08
**Success Criteria** (what must be TRUE):
  1. Calling the `chat` edge function with a natural language question and valid JWT returns a streamed SSE response containing step events and a friendly text answer
  2. Generated SQL is write-protected via RLS policies and SQL validation so that write operations are impossible
  3. Generated SQL is automatically scoped to the authenticated user's data via RLS enforcement -- no cross-user data is ever returned
  4. Long-running or malformed queries are terminated by a statement timeout before they can degrade the database
  5. A follow-up question sent with `previous_response_id` produces a context-aware response that references the prior conversation
**Plans**: 3 plans

Plans:
- [x] 01-01-PLAN.md -- Foundation: schema, prompts, SQL security validation, SSE stream handler
- [x] 01-02-PLAN.md -- Pipeline: rate limiting, RLS query executor, SQL generator, response generator, orchestrator
- [x] 01-03-PLAN.md -- Entry point: auth/subscription/rate-limit gating, Deno config, integration verification

### Phase 2: Stream Client
**Goal**: The Flutter app can open an authenticated SSE connection to the `chat` edge function and parse the stream into typed domain events that higher layers can consume
**Depends on**: Phase 1
**Requirements**: PIPE-01, PIPE-02, PIPE-03
**Success Criteria** (what must be TRUE):
  1. Sending a question from Flutter opens an SSE connection to the edge function and yields a `Stream<ChatEvent>` of typed domain events (step, text delta, response ID, error, done)
  2. The user's Supabase JWT is forwarded with every request so the edge function can authenticate and scope data
  3. If the stream stalls or the network drops, the connection times out and surfaces a clear error event rather than hanging indefinitely
**Plans**: 2 plans

Plans:
- [x] 02-01-PLAN.md -- Domain models (ChatEvent, ChatStreamState, ChatException), SSE line-buffer parser, and ChatRepository
- [x] 02-02-PLAN.md -- TypewriterBuffer, ChatService with stall detection and retry, ChatStreamStateNotifier provider

### Phase 3: Chat Screen
**Goal**: Users can open a chat screen, type a question, and see a streaming AI response with step-by-step progress indicators, markdown formatting, and graceful error handling
**Depends on**: Phase 2
**Requirements**: CHAT-01, CHAT-02, CHAT-03, CHAT-04, CHAT-05, CHAT-06, CHAT-07, CHAT-08, DISC-02, ACCS-01
**Success Criteria** (what must be TRUE):
  1. Tapping the existing LoglyAI button on the profile screen navigates to the chat screen (no new navigation elements needed)
  2. Non-pro users are blocked from accessing the chat screen and see a prompt to upgrade their subscription
  3. After sending a question, the user sees step progress indicators (spinner with friendly label per step, checkmark when complete) followed by a streaming text response appearing token-by-token below the steps
  4. AI responses render markdown formatting (bold, lists, headers) correctly
  5. When a request fails (network error, timeout, server error), the user sees a friendly error message with a retry option -- no technical details exposed
**Plans**: 4 plans

Plans:
- [x] 03-01-PLAN.md -- Route, navigation, bridge provider (Riverpod-to-ChatController), stream cancellation
- [x] 03-02-PLAN.md -- ChatScreen with Chat widget, custom composer (send/stop), empty state (welcome + chips)
- [x] 03-03-PLAN.md -- Error text restoration, polish, and visual verification checkpoint
- [x] 03-04-PLAN.md -- Gap closure: step summary visibility, smooth streaming, message alignment, error restoration fix

### Phase 4: Conversation & Discovery
**Goal**: Users can have multi-turn conversations with context, see suggested starter questions on an empty chat, see follow-up suggestions after each response, and have their chat history persisted across sessions
**Depends on**: Phase 3
**Requirements**: CONV-01, CONV-02, CHAT-09, DISC-01
**Success Criteria** (what must be TRUE):
  1. After receiving a response, the user can ask a follow-up question and the AI answer reflects the full conversation context (not just the latest question in isolation)
  2. When the user opens the chat screen with no messages, they see suggested starter questions they can tap to send immediately
  3. After each AI response, 2-3 contextual follow-up suggestions appear as tappable chips that send without additional typing
  4. Closing and reopening the app preserves the conversation -- the user sees their previous messages and can continue where they left off
**Plans**: 4 plans

Plans:
- [x] 04-01-PLAN.md -- Data foundation: Supabase migration (chat_conversations, chat_messages), Drift tables, Freezed domain models
- [x] 04-02-PLAN.md -- Edge function follow-up suggestions, starter prompts repository, dynamic empty state
- [x] 04-03-PLAN.md -- ChatFollowUpEvent parsing, Supabase repositories, persistence service with Drift caching
- [x] 04-04-PLAN.md -- UI integration: follow-up chips, persistence wiring, conversation loading on screen open

### Phase 5: Observability
**Goal**: Every AI chat interaction is logged server-side with generated SQL, step durations, and token usage so that cost, quality, and performance can be monitored and reported
**Depends on**: Phase 1 (edge function must exist); can run in parallel with Phases 3-4 on the backend side
**Requirements**: OBSV-01, OBSV-02, OBSV-03, OBSV-04, OBSV-05, OBSV-06
**Success Criteria** (what must be TRUE):
  1. Every user query produces a log record in Supabase containing the generated SQL text
  2. Each log record includes three separate duration measurements: NL-to-SQL generation time, SQL execution time, and response generation time
  3. Each log record includes token usage counts (input tokens and output tokens) for every OpenAI API call made during the request
  4. A Supabase query can produce a report showing total token cost, average latency per step, and error rates over a given time period
**Plans**: TBD

Plans:
- [ ] 05-01: TBD
- [ ] 05-02: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 --> 2 --> 3 --> 4 --> 5
Note: Phase 5 (Observability) depends only on Phase 1 and can partially overlap with Phases 3-4.

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Edge Function | 3/3 | Complete | 2026-02-02 |
| 2. Stream Client | 2/2 | Complete | 2026-02-02 |
| 3. Chat Screen | 4/4 | Complete | 2026-02-03 |
| 4. Conversation & Discovery | 4/4 | Complete | 2026-02-03 |
| 5. Observability | 0/2 | Not started | - |
