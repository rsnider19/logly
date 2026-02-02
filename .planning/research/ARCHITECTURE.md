# Architecture Patterns

**Domain:** AI Chat with Text-to-SQL in a Flutter + Supabase App
**Project:** Logly AI Insights Chat
**Researched:** 2026-02-02

## Executive Summary

This architecture research covers how to build a text-to-SQL AI chat feature within Logly's existing Flutter + Supabase stack. The system already has a working NL-to-SQL edge function pipeline (`supabase/functions/ai-insights/`) that converts natural language to SQL, executes it, and streams a friendly response via SSE. The Flutter side has empty scaffold directories (`lib/features/ai_insights/`) with chat packages already in `pubspec.yaml`. The architecture task is therefore about **integrating and extending what exists**, not building from scratch.

The core architecture is a **dual-agent pipeline** running in a Supabase edge function: an NL-to-SQL agent (fine-tuned GPT-4.1-mini) generates read-only SQL, a security validator checks it, the query executes against Postgres, and a response agent (GPT-4.1-mini) streams a friendly answer back via SSE. The Flutter client renders this stream using `flutter_chat_ui` with `flyer_chat_text_stream_message` for token-by-token display. Conversation continuity uses OpenAI's `previous_response_id` mechanism (server-managed, stateless on client aside from IDs). Chat history is persisted to `user_ai_insight` in Supabase.

---

## Recommended Architecture

### High-Level System Diagram

```
+------------------------------------------+
|           Flutter Client (Dart)          |
|                                          |
|  +------------------------------------+  |
|  |         Chat Screen (UI)           |  |
|  |  - flutter_chat_ui + controllers   |  |
|  |  - flyer_chat_text_stream_message  |  |
|  |  - gpt_markdown for rendering      |  |
|  |  - Suggested prompts on empty chat |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |     AI Chat Provider (Riverpod)    |  |
|  |  - Manages chat state (messages)   |  |
|  |  - Holds responseId/conversionId   |  |
|  |  - Handles streaming lifecycle     |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |    AI Chat Service (Application)   |  |
|  |  - Validates input                 |  |
|  |  - Coordinates with repository     |  |
|  |  - Manages entitlement check       |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |  AI Chat Repository (Data Layer)   |  |
|  |  - HTTP POST to edge function      |  |
|  |  - SSE stream parsing              |  |
|  |  - Returns Stream<ChatEvent>       |  |
|  |  - Fetches suggested prompts       |  |
|  |  - Fetches chat history            |  |
|  +------------------+-----------------+  |
+------------------------------------------+
                     | HTTPS + SSE
                     | (Supabase Auth JWT)
                     v
+------------------------------------------+
|     Supabase Edge Function (Deno/TS)     |
|     POST /functions/v1/ai-insights       |
|                                          |
|  +------------------------------------+  |
|  |        Auth Middleware              |  |
|  |  - JWT verification                |  |
|  |  - Entitlement check (ai-insights) |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |     NL-to-SQL Agent (Stage 1)      |  |
|  |  - Fine-tuned GPT-4.1-mini         |  |
|  |  - Schema-aware SQL generation     |  |
|  |  - JSON structured output          |  |
|  |  - Self-correction on parse fail   |  |
|  |  - previous_response_id for turns  |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |    SQL Security Validator (Stage 2)|  |
|  |  - SELECT-only enforcement         |  |
|  |  - Dangerous keyword blocklist     |  |
|  |  - Injection pattern detection     |  |
|  |  - No LLM calls (regex-based)      |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |    SQL Executor (Stage 3)          |  |
|  |  - Direct Postgres connection      |  |
|  |  - Row limit (MAX_ROWS = 20)       |  |
|  |  - SUPABASE_DB_URL connection      |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |   Response Agent (Stage 4)         |  |
|  |  - GPT-4.1-mini (non-fine-tuned)   |  |
|  |  - Streams via SSE text deltas     |  |
|  |  - Friendly, non-technical tone    |  |
|  |  - Markdown formatting             |  |
|  +------------------+-----------------+  |
|                     |                    |
|  +------------------v-----------------+  |
|  |    Persistence (Background)        |  |
|  |  - user_ai_insight record          |  |
|  |  - user_ai_insight_step records    |  |
|  |  - Service role Supabase client    |  |
|  +------------------------------------+  |
+------------------------------------------+
                     |
                     v
+------------------------------------------+
|         PostgreSQL 17 (Supabase)         |
|                                          |
|  Tables queried by NL-to-SQL agent:      |
|  - user_activity (user-scoped via SQL)   |
|  - user_activity_detail                  |
|  - user_activity_sub_activity            |
|  - activity / activity_category          |
|  - activity_detail / sub_activity        |
|  - activity_embedding (FTS)              |
|                                          |
|  Persistence tables:                     |
|  - user_ai_insight                       |
|  - user_ai_insight_step                  |
|  - ai_insight_suggested_prompt           |
+------------------------------------------+
```

### Component Boundaries

| Component | Responsibility | Communicates With | Layer |
|-----------|---------------|-------------------|-------|
| **Chat Screen** | Renders messages, input, suggested prompts, step progress indicators | AI Chat Provider | Presentation |
| **AI Chat Provider** | Manages chat message list, streaming state, response/conversion IDs for follow-ups | AI Chat Service, Chat Screen | Presentation |
| **AI Chat Service** | Validates user input, coordinates repository calls, checks entitlements | AI Chat Repository, Entitlement Provider | Application |
| **AI Chat Repository** | HTTP POST to edge function, SSE stream parsing, history/prompt fetching | Supabase Edge Function, Supabase PostgREST | Data |
| **Edge Function (index.ts)** | Request handling, auth middleware, entitlement gate | Agent Pipeline | Backend |
| **Agent Pipeline (agent.ts)** | Orchestrates NL-to-SQL, validation, execution, response generation | OpenAI API, PostgreSQL, Supabase (persistence) | Backend |
| **SQL Validator (security.ts)** | Regex-based SQL safety checks | Agent Pipeline | Backend |
| **Stream Handler (streamHandler.ts)** | SSE message encoding, progress events | Agent Pipeline | Backend |
| **Schema Definition (schema.ts)** | Compressed schema + NL-to-SQL system prompt | NL-to-SQL Agent | Backend |

### Data Flow

#### Happy Path: User Sends a Question

```
1. User types question in Chat Screen
2. Chat Screen dispatches to AI Chat Provider
3. Provider adds user message to local message list (optimistic)
4. Provider adds placeholder AI message (loading state)
5. Provider calls AI Chat Service.sendMessage(query, previousResponseId?, previousConversionId?)
6. Service validates input (non-empty, length limits)
7. Service calls AI Chat Repository.streamInsight(query, previousResponseId, previousConversionId)
8. Repository makes HTTP POST to /functions/v1/ai-insights with:
   - body: { query, previousResponseId?, previousConversionId? }
   - headers: { Authorization: Bearer <supabase_jwt> }
9. Response is an SSE stream. Repository transforms byte stream into Stream<ChatEvent>
10. ChatEvent types map to SSE message types:
    - StepEvent(name, status) -> Provider updates step progress UI
    - TextDeltaEvent(delta) -> Provider appends to current AI message text
    - ResponseIdEvent(id) -> Provider stores for next follow-up
    - ConversionIdEvent(id) -> Provider stores for next follow-up
    - ErrorEvent(message) -> Provider shows error in AI message bubble
11. When stream completes, Provider finalizes the AI message
12. Chat Screen re-renders with complete message (markdown rendered)
```

#### Follow-Up Question Flow

```
1. User types follow-up question
2. Provider sends query + stored previousResponseId + previousConversionId
3. Edge function passes previousConversionId to NL-to-SQL agent
   (OpenAI uses previous_response_id for conversation context)
4. Edge function chains Response agent from SQL agent's response
   (conversionResponseId becomes previous_response_id for Response agent)
5. New responseId and conversionId returned for next turn
```

#### SSE Message Protocol (Already Implemented)

```
Edge Function -> Client SSE Messages:

data: {"type":"step","name":"Reading through your Logly","status":"in_progress"}\n\n
data: {"type":"conversion_id","conversionId":"resp_abc123"}\n\n
data: {"type":"step","name":"Reading through your Logly","status":"complete"}\n\n
data: {"type":"step","name":"Grabbing the relevant entries","status":"in_progress"}\n\n
data: {"type":"step","name":"Grabbing the relevant entries","status":"complete"}\n\n
data: {"type":"step","name":"Verifying my work","status":"in_progress"}\n\n
data: {"type":"step","name":"Verifying my work","status":"complete"}\n\n
data: {"type":"step","name":"Generating your response","status":"in_progress"}\n\n
data: {"type":"step","name":"Generating your response","status":"complete"}\n\n
data: {"type":"text","delta":"You logged "}\n\n
data: {"type":"text","delta":"**12 activities** "}\n\n
data: {"type":"text","delta":"this week!"}\n\n
data: {"type":"response_id","responseId":"resp_xyz789"}\n\n
[stream ends]
```

---

## Component Architecture Details

### Flutter Client: Feature Module Structure

Following the existing Logly architecture pattern (domain/data/application/presentation):

```
lib/features/ai_insights/
  domain/
    chat_message.dart          # Freezed model for chat messages
    chat_event.dart            # Freezed sealed class for SSE events
    ai_insight_exception.dart  # Custom exception
    suggested_prompt.dart      # Freezed model for suggested prompts
  data/
    ai_chat_repository.dart    # HTTP + SSE streaming to edge function
  application/
    ai_chat_service.dart       # Business logic, validation, coordination
  presentation/
    screens/
      ai_chat_screen.dart      # Main chat screen
    widgets/
      step_progress_widget.dart    # Animated pipeline step indicators
      suggested_prompts_widget.dart # Starter question chips
      chat_empty_state.dart        # Empty state with prompts
    providers/
      ai_chat_state_provider.dart  # Riverpod StateNotifier for chat
```

### Flutter Client: SSE Stream Parsing

The repository layer must handle SSE parsing. Since `supabase-flutter` does not have first-class SSE support (tracked in [GitHub Issue #894](https://github.com/supabase/supabase-flutter/issues/894)), the recommended approach is a direct HTTP client:

**Confidence: HIGH** (verified against existing codebase pattern in `agent.ts` and community patterns)

```dart
/// Approach: Use dart:io HttpClient or http package directly
/// (NOT supabase.functions.invoke for SSE streams)
///
/// 1. Make POST request with Supabase JWT in Authorization header
/// 2. Read response body as byte stream
/// 3. Decode UTF-8, split on '\n\n' boundaries
/// 4. Parse JSON from 'data: ' prefixed lines
/// 5. Yield typed ChatEvent objects

Stream<ChatEvent> streamInsight({
  required String query,
  String? previousResponseId,
  String? previousConversionId,
}) async* {
  // Use http.Client for streaming POST
  // Parse SSE: accumulate buffer, split on '\n\n'
  // Handle chunk boundaries (multiple events in one chunk, split events)
  // Yield ChatEvent.step / ChatEvent.text / ChatEvent.responseId / etc.
}
```

Key concern: SSE chunks can arrive merged or split across boundaries. The parser must buffer and split on `\n\n` delimiters, not assume one event per chunk.

### Flutter Client: Chat State Management

**Confidence: HIGH** (follows existing Riverpod patterns in codebase)

The provider manages:
- `List<ChatMessage>` -- the visible message list
- `String? lastResponseId` -- for follow-up chaining (Response Agent)
- `String? lastConversionId` -- for follow-up chaining (SQL Agent)
- `bool isStreaming` -- whether a response is currently streaming
- `List<StepProgress>` -- current pipeline step statuses

The provider should be a `Notifier` (not `keepAlive`) since it is screen-scoped. When the user navigates away and returns, a fresh conversation starts. Persisted history is loaded from Supabase if needed.

### Edge Function: Already Implemented

The edge function at `supabase/functions/ai-insights/` is **fully implemented** with:
- `index.ts` -- Entry point, auth middleware, entitlement check, request parsing
- `agent.ts` -- Full 4-stage pipeline (NL-to-SQL, validate, execute, respond)
- `security.ts` -- Regex-based SQL validation
- `schema.ts` -- Compressed database schema + NL-to-SQL system prompt
- `streamHandler.ts` -- SSE stream creation and message encoding

The edge function uses OpenAI's Responses API with `previous_response_id` for multi-turn context. It maintains two separate conversation threads: one for the SQL agent (`previousConversionId`) and one for the Response agent (`previousResponseId`). This is important because the SQL agent needs deterministic, structured output while the Response agent produces friendly prose.

### Database: Existing Schema

**Chat persistence** is already modeled:

| Table | Purpose | Key Columns |
|-------|---------|-------------|
| `user_ai_insight` | One row per question/answer turn | `user_query`, `openai_response_id`, `openai_conversion_id`, `previous_response_id`, `previous_conversion_id`, timing/cost fields |
| `user_ai_insight_step` | Pipeline step telemetry | `step_name`, `input_context`, `output_result`, `token_usage`, `duration_ms` |
| `ai_insight_suggested_prompt` | Starter questions for empty chat | `prompt_text`, `display_order`, `is_active` |

---

## Security Model

### Confidence: HIGH (verified from existing code + PostgreSQL documentation)

The text-to-SQL security model uses **defense in depth** with four layers:

#### Layer 1: Authentication and Authorization (Edge Function)

- **JWT verification**: `AuthMiddleware` verifies the Supabase JWT using `supabaseAdminClient.auth.getClaims(token)`. Extracts `userId` from claims.
- **Entitlement check**: `isEntitledTo({ userId, entitlement: "ai-insights" })` queries `revenue_cat.user_has_feature()` to verify pro subscription.
- **Effect**: Unauthenticated or non-subscribed users get 401/403 before any AI processing.

#### Layer 2: SQL Generation Constraints (LLM Prompt)

- **System prompt rules**: The NL-to-SQL instructions explicitly state "Only SELECT queries allowed" and "Always filter user_activity* tables by user_id".
- **Schema scoping**: The compressed schema only exposes the 8 tables relevant for analytics queries. System tables, auth tables, and the `revenue_cat` schema are not in the schema prompt.
- **Structured output**: JSON schema enforcement (`{ sqlQuery: string }`) constrains model output format.
- **Low temperature (0.1)**: Reduces creativity/deviation in SQL generation.
- **Fine-tuned model**: Trained on 338+ examples specific to this domain, reducing likelihood of off-schema queries.
- **User ID injection**: The user's ID is passed in the prompt (`[user_id: UUID]`), and the model is trained to use it in WHERE clauses.

#### Layer 3: SQL Validation (Regex-Based, No LLM)

- **SELECT-only**: Query must start with `SELECT`.
- **Dangerous keyword blocklist**: `DROP`, `DELETE`, `INSERT`, `UPDATE`, `ALTER`, `TRUNCATE`, `CREATE`, `GRANT`, `REVOKE`, `EXEC`, `EXECUTE`, `INTO`, `COPY`, `VACUUM`, `REINDEX`, `CLUSTER`.
- **Injection pattern detection**: Trailing semicolons, multi-statement, SQL comments (`--`, `/* */`), hex escapes, UNION SELECT.
- **Effect**: Any query that passes this validator is provably read-only at the syntactic level.

#### Layer 4: Database Connection Security

- **Connection string**: Uses `SUPABASE_DB_URL` environment variable (service role or dedicated role).
- **Row limiting**: Results capped at `MAX_ROWS = 20` in application code.
- **Connection lifecycle**: New connection per query, closed in `finally` block.

#### Current Security Gap (Documented)

The `executeQuery` function in `agent.ts` connects using `SUPABASE_DB_URL` which is likely the service role connection string. This means:
- RLS is bypassed (service role has `BYPASSRLS`)
- The user_id scoping relies entirely on the LLM generating correct WHERE clauses
- If the LLM generates a query without user_id filtering (e.g., `SELECT * FROM user_activity`), it could return other users' data

**Recommendation for hardening** (can be addressed in a later phase):

```sql
-- Create a dedicated read-only role for AI queries
CREATE ROLE ai_query_reader WITH LOGIN PASSWORD 'secure_password' NOBYPASSRLS;
GRANT USAGE ON SCHEMA public TO ai_query_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ai_query_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ai_query_reader;

-- Set statement timeout at role level (5 seconds)
ALTER ROLE ai_query_reader SET statement_timeout = '5000';

-- Enable RLS on user_activity tables
-- (RLS policies already exist for these tables via Supabase)
-- The ai_query_reader role would respect them

-- Set session variable before each query for RLS
SET app.current_user_id = '<user_id>';
```

This would add database-level enforcement on top of the existing LLM-prompt and regex-validation layers. However, implementing this requires:
1. A separate database connection string for the AI role
2. Setting session variables before each query
3. RLS policies that reference `current_setting('app.current_user_id')`

For v1, the existing 3-layer defense (auth + prompt constraints + regex validation) is adequate given the fine-tuned model's training. The dedicated role should be a Phase 2 hardening item.

---

## Patterns to Follow

### Pattern 1: Optimistic UI with Streaming Backfill

**What:** Add the user's message to the chat immediately, then add a placeholder AI message that fills in as SSE events arrive.

**When:** Every message send.

**Why:** Users see their message instantly. The AI response builds up token-by-token, matching modern chat AI UX expectations (ChatGPT, Claude, etc.).

**Implementation:**
```
1. User sends message
2. Immediately: Add UserMessage to list, add AiMessage(text: "", isStreaming: true)
3. Show step progress indicators in the AiMessage bubble
4. As text deltas arrive: append to AiMessage.text, rebuild widget
5. On stream complete: set AiMessage.isStreaming = false
6. On error: replace AiMessage content with error message + retry button
```

### Pattern 2: Dual-Thread Conversation State

**What:** Maintain two separate OpenAI conversation thread IDs: one for the SQL agent and one for the Response agent.

**When:** Every multi-turn conversation.

**Why:** The existing edge function already implements this. The SQL agent needs its own conversation history to resolve "what about last week?" style follow-ups where "last week" requires understanding the previous SQL context. The Response agent chains from the SQL agent's response for data context awareness.

**Implementation:**
- Client stores `lastResponseId` (Response agent) and `lastConversionId` (SQL agent)
- Both are sent with each follow-up request
- Edge function passes `previousConversionId` to `convertToSql()` and chains the SQL response ID to `generateStreamingResponse()`
- On new conversation, both are null/omitted

### Pattern 3: Step Progress as In-Message UI

**What:** Show pipeline progress steps (e.g., "Reading through your Logly", "Grabbing the relevant entries") as animated checklist items inside the AI message bubble, not as a separate UI element.

**When:** During the streaming phase before text starts arriving.

**Why:** Keeps the user informed during the 2-5 second delay between sending a question and receiving text. The step names are user-friendly (already defined in `streamHandler.ts`) and each transitions through `pending -> in_progress -> complete`.

### Pattern 4: Repository-Level SSE Parsing

**What:** SSE stream parsing lives in the repository layer, yielding typed `ChatEvent` objects. The service and provider layers never see raw bytes or SSE protocol details.

**When:** Always.

**Why:** Follows the existing Logly architecture where repositories handle transport concerns and return domain objects. The provider/service layers work with clean Dart types.

```dart
// Domain events (Freezed sealed class)
@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.step({required String name, required String status}) = StepEvent;
  const factory ChatEvent.textDelta({required String delta}) = TextDeltaEvent;
  const factory ChatEvent.responseId({required String id}) = ResponseIdEvent;
  const factory ChatEvent.conversionId({required String id}) = ConversionIdEvent;
  const factory ChatEvent.error({required String message}) = ErrorEvent;
}
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Managing Full Conversation History on Client

**What:** Storing and sending the entire message history with each request (like Chat Completions API).

**Why bad:** The existing edge function uses OpenAI's Responses API with `previous_response_id` for server-side conversation state. Sending full history would duplicate state, increase payload size, and conflict with the current design.

**Instead:** Store only `lastResponseId` and `lastConversionId` on the client. OpenAI's server manages the full conversation context. The edge function passes these IDs through.

### Anti-Pattern 2: Using supabase.functions.invoke() for SSE

**What:** Using the built-in `supabase.functions.invoke()` Dart method to receive SSE streams.

**Why bad:** The `supabase-flutter` SDK does not have first-class SSE support ([Issue #894](https://github.com/supabase/supabase-flutter/issues/894)). Using it for streaming results in the entire response arriving at once (not streamed) or other parsing issues. The SDK's `FunctionsClient` is designed for request-response, not streaming.

**Instead:** Use Dart's `http` package or `HttpClient` directly to make the POST request and process the response body as a byte stream. Manually add the Supabase JWT to the Authorization header.

### Anti-Pattern 3: Persisting Chat History in Local Drift/SQLite

**What:** Storing chat messages in the local Drift database for offline access.

**Why bad:** AI chat requires network access to function (edge function + OpenAI API). Caching messages locally adds complexity without value -- the user cannot interact with the AI offline. The `user_ai_insight` table in Supabase already persists all conversations server-side.

**Instead:** Load previous messages from Supabase on screen entry if needed. Keep the current conversation in Riverpod state only. Do not create Drift tables for chat.

### Anti-Pattern 4: Parsing SSE by Assuming One Event Per Chunk

**What:** Treating each received byte chunk as containing exactly one SSE event.

**Why bad:** Network buffering can merge multiple events into one chunk (`data: {...}\n\ndata: {...}\n\n`) or split a single event across chunks. This causes JSON parse failures and lost events.

**Instead:** Implement a buffer-based parser that accumulates bytes, decodes to UTF-8 string, splits on `\n\n` boundaries, and processes each complete `data: ` line individually.

### Anti-Pattern 5: Creating a New Conversation Thread Per Message

**What:** Not passing `previousResponseId`/`previousConversionId` on follow-up messages, causing each question to be treated as isolated.

**Why bad:** Users expect "What about last month?" to reference their previous question. Without conversation threading, every question requires full context in the query text.

**Instead:** Store and forward both IDs from each response. Clear them only when starting a "New Conversation."

---

## Suggested Build Order

Based on component dependencies, the recommended implementation sequence:

### Phase 1: Domain Models + Repository (Foundation)

Build the data pipeline from Flutter to the edge function.

**Dependencies:** None (edge function already exists)

1. **Domain models** (`ChatMessage`, `ChatEvent`, `SuggestedPrompt`, exception)
2. **AI Chat Repository** (HTTP POST, SSE parsing, suggested prompts fetch)
3. **Unit tests** for SSE parser (critical -- test merged chunks, split events, all event types)

**Rationale:** The repository is the hardest Flutter component because SSE parsing is tricky and `supabase-flutter` lacks native support. Get this right first.

### Phase 2: Service + Provider (Business Logic)

Wire up state management.

**Dependencies:** Phase 1 models and repository

4. **AI Chat Service** (input validation, entitlement coordination)
5. **AI Chat State Provider** (message list, streaming state, conversation IDs)
6. **Integration tests** (mock repository, verify state transitions)

### Phase 3: Chat UI (Presentation)

Build the visible interface.

**Dependencies:** Phase 2 provider

7. **Chat Screen** with `flutter_chat_ui` integration
8. **Step progress widget** (animated checklist in message bubble)
9. **Suggested prompts widget** (chips for empty state)
10. **Route registration** in `app_router.dart`
11. **Navigation entry point** (button on home or in bottom nav)

### Phase 4: Polish and Hardening

**Dependencies:** Phase 3 working end-to-end

12. **Error handling** (network errors, timeout, entitlement expired)
13. **New conversation** action (clears IDs, fresh state)
14. **Chat history loading** (fetch previous insights from `user_ai_insight`)
15. **Edge function security hardening** (dedicated read-only DB role -- optional for v1)

---

## Scalability Considerations

| Concern | Current (100s of users) | At 10K users | At 100K users |
|---------|------------------------|--------------|---------------|
| **Edge function cold starts** | Negligible impact, Deno starts fast | Supabase auto-scales edge functions | Consider connection pooling for DB |
| **OpenAI API latency** | 2-5s per pipeline run is acceptable | Same -- each request is independent | May want response caching for common queries |
| **Database query performance** | Fine with indexed tables | Add read replicas if needed | Dedicated read replica for AI queries |
| **Conversation state** | OpenAI stores responses (free with `store: true`) | OpenAI manages TTL/cleanup | Monitor storage costs, may need cleanup |
| **SSE connection duration** | 5-15s per stream, short-lived | No connection pooling needed | Edge function timeout (150s) is generous |
| **Token costs** | Fine-tuned mini model is cost-effective | Monitor via `user_ai_insight_step` telemetry | Consider per-user daily limits |

---

## Technology Integration Points

### Existing Infrastructure (No Changes Needed)

| Component | Status | Notes |
|-----------|--------|-------|
| Edge function pipeline | Complete | `supabase/functions/ai-insights/` -- fully working |
| Database schema | Complete | `user_ai_insight`, `user_ai_insight_step`, `ai_insight_suggested_prompt` tables exist |
| Auth middleware | Complete | JWT verification + entitlement check |
| RevenueCat subscription | Complete | `FeatureCode.aiInsights` already defined |
| Fine-tuned model | Complete | 338+ training examples, deployed |
| Chat packages | In pubspec | `flutter_chat_ui`, `flutter_chat_core`, `flyer_chat_text_stream_message`, `gpt_markdown` |

### New Components (Must Build)

| Component | Effort | Complexity |
|-----------|--------|------------|
| Domain models (Freezed) | Low | Low |
| SSE stream parser | Medium | High (chunk boundary handling) |
| AI Chat Repository | Medium | Medium |
| AI Chat Service | Low | Low |
| AI Chat State Provider | Medium | Medium (streaming lifecycle) |
| Chat Screen UI | Medium | Medium (flutter_chat_ui integration) |
| Step progress widget | Low | Low |
| Suggested prompts widget | Low | Low |
| Route + navigation | Low | Low |

---

## Sources

### Codebase (PRIMARY -- verified by direct reading)
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/agent.ts` -- Full pipeline implementation
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/security.ts` -- SQL validation
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/schema.ts` -- Schema + NL-to-SQL prompt
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/streamHandler.ts` -- SSE protocol
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/index.ts` -- Entry point + auth
- `/Users/robsnider/StudioProjects/logly/supabase/database.types.ts` -- Full database schema
- `/Users/robsnider/StudioProjects/logly/lib/app/router/routes.dart` -- Existing navigation structure
- `/Users/robsnider/StudioProjects/logly/lib/features/home/application/home_service.dart` -- Service pattern reference

### Official Documentation
- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions) -- Edge function architecture
- [Supabase Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security) -- RLS patterns
- [OpenAI Responses API -- Conversation State](https://platform.openai.com/docs/guides/conversation-state) -- `previous_response_id` mechanism
- [OpenAI Responses API Reference](https://platform.openai.com/docs/api-reference/responses/create) -- API specification
- [PostgreSQL Predefined Roles](https://www.postgresql.org/docs/current/predefined-roles.html) -- `pg_read_all_data` role
- [PostgreSQL Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) -- RLS documentation

### Community / WebSearch (MEDIUM confidence)
- [supabase-flutter SSE Issue #894](https://github.com/supabase/supabase-flutter/issues/894) -- SSE support status
- [flutter_chat_ui GitHub](https://github.com/flyerhq/flutter_chat_ui) -- Chat UI package
- [flyer_chat_text_stream_message](https://pub.dev/packages/flyer_chat_text_stream_message) -- Streaming text message widget
- [Crunchy Data: Control Runaway Queries](https://www.crunchydata.com/blog/control-runaway-postgres-queries-with-statement-timeout) -- statement_timeout patterns
- [Microsoft NL-to-SQL Architecture](https://techcommunity.microsoft.com/blog/azurearchitectureblog/nl-to-sql-architecture-alternatives/4136387) -- Architecture patterns
- [Cambridge Core: Security in Text-to-SQL](https://resolve.cambridge.org/core/journals/natural-language-processing/article/enhancing-security-in-texttosql-systems-a-novel-dataset-and-agentbased-framework/4D0F32A20438C18FD1F84DC7BD908F97) -- Security framework research
