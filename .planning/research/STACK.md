# Technology Stack: AI Insights Chat Feature

**Project:** Logly -- AI Chat with Text-to-SQL
**Researched:** 2026-02-02
**Mode:** Ecosystem (Stack dimension for subsequent milestone)
**Overall Confidence:** HIGH

---

## Context: What Already Exists

The backend edge function is **fully built and deployed**. The Flutter-side feature directories exist but are empty (`.gitkeep` only). This stack research focuses on what the Flutter client needs to consume the existing SSE-streaming edge function, plus any upgrades needed on the backend side.

### Already Built (Backend -- Supabase Edge Function)

| Component | Technology | Version | Status |
|-----------|-----------|---------|--------|
| Edge Function Runtime | Deno (Supabase Edge Functions) | Latest | Deployed |
| LLM -- NL-to-SQL | OpenAI GPT-4.1-mini (fine-tuned) | `ft:gpt-4.1-mini-2025-04-14:logly-llc::CwW7bj3O` | Deployed |
| LLM -- Response Generation | OpenAI GPT-4.1-mini | `gpt-4.1-mini` | Deployed |
| OpenAI SDK (Node/Deno) | `openai` (npm) | 4.103.0 (pinned in agent.ts) | Deployed |
| Postgres Driver | `@db/postgres` (JSR) | 0.19.5 | Deployed |
| Schema Validation | `zod` (npm) | Used inline | Deployed |
| API Style | OpenAI Responses API with `previous_response_id` | Current | Deployed |
| Streaming | Custom SSE via ReadableStream | N/A | Deployed |
| DB Tables | `user_ai_insight`, `user_ai_insight_step`, `ai_insight_suggested_prompt` | Migrated | Deployed |

### Already in pubspec.yaml (Flutter-side)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_chat_core` | ^2.9.0 | Chat data models, controllers, theming |
| `flutter_chat_ui` | ^2.11.1 | Chat UI widget library (Flyer Chat v2) |
| `flyer_chat_text_stream_message` | ^2.3.0 | Streaming text message widget with markdown + fade-in |
| `gpt_markdown` | ^1.1.5 | Markdown rendering for LLM responses |

---

## Recommended Stack

### Flutter Client -- Chat UI Layer

These packages are **already in pubspec.yaml** and are the correct choices. No changes needed.

| Technology | Version | Purpose | Confidence |
|-----------|---------|---------|------------|
| `flutter_chat_ui` | ^2.11.1 | Full chat UI: message list, composer, scrolling, two-sided pagination | HIGH |
| `flutter_chat_core` | ^2.9.0 | Core models (`TextMessage`, `TextStreamMessage`), `ChatController` interface, `ChatTheme` | HIGH |
| `flyer_chat_text_stream_message` | ^2.3.0 | Renders streaming AI responses with markdown + fade-in animation. Manages `StreamState` (thinking/streaming/complete/error) | HIGH |
| `gpt_markdown` | ^1.1.5 | Renders LLM markdown output (bold, lists, tables, code blocks, LaTeX). Drop-in replacement for deprecated `flutter_markdown` | HIGH |

**Why Flyer Chat v2:** This is the leading open-source chat UI kit for Flutter (1.58k likes, 77k downloads). v2 is a complete rewrite designed explicitly for generative AI agents and LLM-based assistants. The `TextStreamMessage` type and stream manager pattern are purpose-built for the exact use case Logly needs -- SSE text streaming from an AI backend. The official example app includes a Gemini integration that demonstrates the exact pattern.

**Why NOT alternatives:**
- `stream_chat_flutter` (Stream) -- Proprietary backend required, overkill for a single AI chat feature
- `dash_chat` -- v1-era design, no streaming support, unmaintained
- `chatview` -- No streaming message support, limited customization
- Custom from scratch -- Reinventing pagination, animations, message layout is unnecessary when Flyer Chat handles it

### Flutter Client -- SSE/HTTP Streaming Layer

This is the critical gap. `supabase_flutter` does **NOT** support SSE streaming responses from edge functions (GitHub Issue #894, still open as of Feb 2026). A custom HTTP client is required.

| Technology | Version | Purpose | Confidence |
|-----------|---------|---------|------------|
| `http` | ^1.6.0 | Dart's official HTTP client. Use `Client.send()` with `StreamedRequest` to POST to edge function and receive SSE stream | HIGH |

**Why `http` and not a dedicated SSE package:**
- The `http` package is already a transitive dependency of `supabase_flutter` -- no new dependency needed
- The SSE protocol from the edge function is simple (just `data: {json}\n\n` lines) -- a full SSE client with reconnection/Last-Event-ID tracking is unnecessary
- The edge function returns a finite stream (one request = one pipeline run), not an infinite event source
- Parsing is straightforward: split on `\n\n`, strip `data: ` prefix, JSON decode

**Why NOT these alternatives:**
- `supabase_flutter` `functions.invoke()` -- Returns `FunctionResponse`, not a stream. No SSE support. Would require waiting for the full response (defeating the purpose of streaming)
- `flutter_http_sse` -- Adds unnecessary dependency for a simple finite stream
- `flutter_client_sse` -- Same: designed for long-lived SSE connections with reconnection, not needed here
- `dio` -- Not in the project, adding it for one use case is overkill
- `sse_channel` -- Bidirectional SSE protocol, not what this edge function uses

**Implementation Pattern:**

```dart
/// Send POST to edge function, receive SSE stream
Stream<SSEEvent> sendQuery(String query, {String? previousResponseId, String? previousConversionId}) async* {
  final client = http.Client();
  final request = http.StreamedRequest('POST', Uri.parse('$baseUrl/functions/v1/ai-insights'));
  request.headers['Authorization'] = 'Bearer $accessToken';
  request.headers['Content-Type'] = 'application/json';
  request.headers['Accept'] = 'text/event-stream';

  final body = jsonEncode({
    'query': query,
    if (previousResponseId != null) 'previousResponseId': previousResponseId,
    if (previousConversionId != null) 'previousConversionId': previousConversionId,
  });
  request.sink.add(utf8.encode(body));
  request.sink.close();

  final response = await client.send(request);
  // Parse SSE: split by double newline, extract data field, JSON decode
  yield* response.stream
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .where((line) => line.startsWith('data: '))
      .map((line) => line.substring(6))
      .map((json) => SSEEvent.fromJson(jsonDecode(json)));
}
```

### Flutter Client -- State Management

| Technology | Version | Purpose | Confidence |
|-----------|---------|---------|------------|
| `riverpod` + `riverpod_annotation` | ^3.2.0 / ^4.0.1 | State management (already in project) | HIGH |
| `freezed` + `freezed_annotation` | ^3.0.6 / ^3.1.0 | Immutable domain models (already in project) | HIGH |

Follow existing project patterns:
- `ChatController` implementation as a `@Riverpod(keepAlive: true)` notifier
- Domain models (`InsightMessage`, `SuggestedPrompt`, `ChatSession`) as `@freezed` classes
- Repository pattern for data access, Service pattern for business logic

### Flutter Client -- Routing & Gating

| Technology | Version | Purpose | Confidence |
|-----------|---------|---------|------------|
| `go_router` + `go_router_builder` | ^17.0.1 / ^4.1.3 | Typed route for AI Insights screen (already in project) | HIGH |
| `purchases_flutter` | ^9.10.7 | RevenueCat subscription check for pro gating (already in project) | HIGH |

### Backend -- Edge Function (No Changes Needed)

The existing backend stack is solid and well-architected. Key observations:

| Component | Current | Assessment | Confidence |
|-----------|---------|-----------|------------|
| OpenAI Responses API | `previous_response_id` chaining | Correct choice. Simpler than Conversations API for this use case. Server-managed state with 40-80% cache improvement over Chat Completions | HIGH |
| Fine-tuned GPT-4.1-mini | `ft:gpt-4.1-mini-2025-04-14:logly-llc::CwW7bj3O` | Excellent for NL-to-SQL. Low cost ($0.40/1M input, $1.60/1M output), fast, fine-tuned on domain-specific training data | HIGH |
| GPT-4.1-mini (response gen) | `gpt-4.1-mini` | Good choice. Slightly higher temperature (0.7) for natural language is appropriate | HIGH |
| SQL Validation | Regex-based blocklist | Adequate for SELECT-only queries. Fast, no LLM overhead. Catches the common attack vectors | MEDIUM |
| Direct Postgres Connection | `@db/postgres` via `SUPABASE_DB_URL` | Bypasses PostgREST for raw SQL execution -- necessary for dynamic queries. Row limit (20) is sensible | HIGH |
| SSE Streaming | Custom `ReadableStream` with `TextEncoder` | Clean implementation. Step progress + text deltas + response/conversion IDs | HIGH |
| Persistence | `user_ai_insight` + `user_ai_insight_step` tables | Good debugging/analytics. Step-level logging with token usage and timing | HIGH |

### Backend -- Potential Upgrades (Optional, Not Blocking)

| Upgrade | Current | Suggested | Rationale | Priority |
|---------|---------|-----------|-----------|----------|
| OpenAI npm package | 4.103.0 (pinned) | ^6.16.0 | Major version jump. v5/v6 have better Responses API types, streaming helpers. Not blocking but recommended for maintenance | LOW |
| Zod | Inline (v3 era) | ^4.3.5 | Zod 4 is stable, faster, better TypeScript inference. Current usage is minimal so low urgency | LOW |
| Conversations API | `previous_response_id` | Keep as-is | Conversations API is more complex, designed for long-lived threads. `previous_response_id` is simpler and sufficient for this single-session chat pattern | N/A |

---

## Full Dependency Summary

### New Dependencies to Add (Flutter)

| Package | Version | Purpose | Notes |
|---------|---------|---------|-------|
| `http` | ^1.6.0 | SSE streaming HTTP client for edge function | Already a transitive dependency of `supabase_flutter`; adding it explicitly gives direct access |

### Existing Dependencies to Use (No Version Changes)

| Package | Current Version | Purpose |
|---------|----------------|---------|
| `flutter_chat_core` | ^2.9.0 | Chat models and controllers |
| `flutter_chat_ui` | ^2.11.1 | Chat UI widgets |
| `flyer_chat_text_stream_message` | ^2.3.0 | Streaming text messages |
| `gpt_markdown` | ^1.1.5 | Markdown rendering |
| `flutter_riverpod` | ^3.2.0 | State management |
| `riverpod_annotation` | ^4.0.1 | Code-gen annotations |
| `freezed_annotation` | ^3.1.0 | Immutable models |
| `supabase_flutter` | ^2.12.0 | Auth, DB access (non-streaming) |
| `go_router` | ^17.0.1 | Navigation |
| `purchases_flutter` | ^9.10.7 | Subscription gating |
| `shimmer` | ^3.0.0 | Loading states |
| `uuid` | ^4.5.2 | Message ID generation |

### Dev Dependencies (No Changes)

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.10.5 | Code generation |
| `freezed` | ^3.0.6 | Freezed codegen |
| `riverpod_generator` | ^4.0.2 | Riverpod codegen |
| `mocktail` | ^1.0.4 | Testing mocks |

### Installation

```bash
# Only one new explicit dependency needed
fvm dart pub add http

# Code generation after adding domain models
fvm dart run build_runner build --delete-conflicting-outputs
```

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Chat UI | Flyer Chat v2 (already added) | stream_chat_flutter | Proprietary backend, SaaS pricing, overkill |
| Chat UI | Flyer Chat v2 | Custom widgets | Reinventing message list, pagination, animations |
| Streaming | `http` package (manual SSE) | `supabase_flutter` invoke | No SSE support (Issue #894 still open) |
| Streaming | `http` package | `flutter_http_sse` | Unnecessary dependency for simple finite stream |
| Streaming | `http` package | `dio` | Not in project, adding for one use case |
| Markdown | `gpt_markdown` (already added) | `flutter_markdown` | Being discontinued; `gpt_markdown` is the replacement |
| LLM API | OpenAI Responses API | Chat Completions API | Responses API has better caching, stateful chaining, is OpenAI's recommended path forward |
| LLM API | `previous_response_id` | Conversations API | Simpler for single-session chat; Conversations API adds complexity without benefit here |
| NL-to-SQL Model | Fine-tuned GPT-4.1-mini | GPT-4.1 (full) | 5x more expensive, marginal accuracy gain for domain-specific fine-tuned model |
| NL-to-SQL Model | Fine-tuned GPT-4.1-mini | GPT-5 mini | Could be worth evaluating for accuracy, but existing fine-tuning investment in 4.1-mini is substantial |

---

## Architecture Integration Notes

### How the Flutter Client Connects to Existing Backend

```
Flutter App                         Supabase Edge Function (existing)
-----------                         ---------------------------------

1. User types question
2. ChatController adds
   UserMessage to message list
3. ChatController adds
   TextStreamMessage (thinking)
4. InsightsRepository sends         POST /functions/v1/ai-insights
   HTTP POST with auth token   -->  { query, previousResponseId, previousConversionId }
5. Parse SSE events:           <--  data: {"type":"step","name":"...","status":"in_progress"}
   - step events update             data: {"type":"step","name":"...","status":"complete"}
     TextStreamMessage state         data: {"type":"conversion_id","conversionId":"..."}
   - text deltas append to           data: {"type":"text","delta":"..."}
     TextStreamMessage content        data: {"type":"text","delta":"..."}
   - response_id/conversion_id       data: {"type":"response_id","responseId":"..."}
     stored for follow-ups           data: {"type":"conversion_id","conversionId":"..."}
6. On stream complete,
   replace TextStreamMessage
   with final TextMessage
7. Store responseId +
   conversionId for next turn
```

### SSE Event Types (from existing `streamHandler.ts`)

| Event Type | Payload | Flutter Action |
|-----------|---------|---------------|
| `step` | `{ name, status }` | Update progress indicator (thinking/converting/executing/responding) |
| `text` | `{ delta }` | Append to `TextStreamMessage.text`, update `StreamState` to streaming |
| `error` | `{ message }` | Show error in chat, update `StreamState` to error |
| `response_id` | `{ responseId }` | Store for `previousResponseId` on next query |
| `conversion_id` | `{ conversionId }` | Store for `previousConversionId` on next query |

### Auth Token Access

The edge function requires a JWT. Get it from the existing Supabase session:

```dart
final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;
```

---

## Confidence Assessment

| Area | Level | Reason |
|------|-------|--------|
| Chat UI packages | HIGH | Already in pubspec, verified current versions on pub.dev, Flyer Chat v2 is purpose-built for AI streaming |
| SSE streaming approach | HIGH | Well-documented pattern, `http` package is stable and official, edge function SSE format is simple and known |
| Backend stack | HIGH | Already deployed and working, code reviewed, well-architected |
| State management integration | HIGH | Following established project patterns (Riverpod + Freezed) |
| `supabase_flutter` SSE limitation | HIGH | Verified: GitHub Issue #894 still open, confirmed by maintainer response |

## Sources

- [flutter_chat_ui on pub.dev](https://pub.dev/packages/flutter_chat_ui) -- v2.11.1, verified 2026-02-02
- [flutter_chat_core on pub.dev](https://pub.dev/packages/flutter_chat_core) -- v2.9.0, verified 2026-02-02
- [flyer_chat_text_stream_message on pub.dev](https://pub.dev/packages/flyer_chat_text_stream_message) -- v2.3.0, verified 2026-02-02
- [gpt_markdown on pub.dev](https://pub.dev/packages/gpt_markdown) -- v1.1.5, verified 2026-02-02
- [http on pub.dev](https://pub.dev/packages/http) -- v1.6.0, verified 2026-02-02
- [supabase-flutter SSE Issue #894](https://github.com/supabase/supabase-flutter/issues/894) -- Still open as of 2026-02-02
- [OpenAI Responses API docs](https://platform.openai.com/docs/api-reference/responses) -- Recommended over Chat Completions for new projects
- [OpenAI Conversation State guide](https://platform.openai.com/docs/guides/conversation-state) -- `previous_response_id` vs Conversations API
- [OpenAI GPT-4.1-mini pricing](https://platform.openai.com/docs/pricing) -- $0.40/1M input, $1.60/1M output
- [OpenAI fine-tuning best practices](https://platform.openai.com/docs/guides/fine-tuning-best-practices)
- [openai npm package](https://www.npmjs.com/package/openai) -- v6.16.0 latest (current project uses 4.103.0)
- [Zod on npm](https://www.npmjs.com/package/zod) -- v4.3.5 latest
- [@db/postgres on JSR](https://jsr.io/@db/postgres) -- v0.19.5 latest
- Existing codebase: `supabase/functions/ai-insights/agent.ts`, `streamHandler.ts`, `schema.ts`, `security.ts`
