# Project Research Summary

**Project:** Logly AI Insights Chat Feature
**Domain:** AI-powered text-to-SQL chat for personal activity data
**Researched:** 2026-02-02
**Confidence:** HIGH

## Executive Summary

Logly already has a sophisticated backend pipeline for AI chat fully built and deployed. The Supabase edge function implements a 4-stage pipeline (NL-to-SQL conversion, validation, execution, streaming response) using a fine-tuned GPT-4.1-mini model with 338+ training examples. The infrastructure persists all insights and steps, gates access via RevenueCat, and streams responses via SSE. The Flutter side has empty scaffold directories and the necessary chat UI packages (`flutter_chat_ui`, `flyer_chat_text_stream_message`, `gpt_markdown`) already in `pubspec.yaml`. This is an integration and extension project, not a ground-up build.

The recommended approach is to build the Flutter client that consumes the existing SSE stream, implementing all table-stakes features (streaming display, multi-turn conversations, suggested starters, progress indicators, error handling) in Phase 1, then layer on differentiators (follow-up suggestions, conversation history) in Phase 2+. The client will use Dart's `http` package directly for SSE streaming since `supabase_flutter` lacks native support (GitHub Issue #894), following Logly's established Riverpod + Freezed + Repository patterns.

The key risks are security-related: the current implementation bypasses RLS (uses direct Postgres connection), relies on LLM-generated SQL for user scoping, and uses regex-only SQL validation. These must be hardened with a dedicated read-only database role, RLS enforcement, and schema-based validation before production. Secondary risks include latency (two sequential LLM calls), cost management (no per-user rate limits), and SSE fragility on mobile networks.

## Key Findings

### Recommended Stack

The backend stack is complete and well-architected. The Flutter client needs minimal new dependencies: only the `http` package (already a transitive dependency) must be added explicitly for SSE streaming. All chat UI packages are already in `pubspec.yaml` and are the correct choices for this use case.

**Core technologies:**
- **`flutter_chat_ui` + `flutter_chat_core` (^2.11.1 / ^2.9.0):** Purpose-built for AI chat with streaming support, established library (1.58k likes, 77k downloads)
- **`flyer_chat_text_stream_message` (^2.3.0):** Handles SSE text deltas with markdown rendering and fade-in animations, manages streaming states
- **`http` (^1.6.0):** Manual SSE stream parsing since `supabase_flutter` does not support Server-Sent Events (verified limitation)
- **Riverpod + Freezed:** State management and domain models following existing Logly architecture patterns
- **OpenAI Responses API (backend):** Server-managed conversation state via `previous_response_id`, 40-80% token cost savings over Chat Completions API
- **Fine-tuned GPT-4.1-mini:** Domain-specific NL-to-SQL model ($0.40/1M input, $1.60/1M output), fast and cost-effective

**Critical version/configuration notes:**
- Must use `http` package directly for SSE; `supabase.functions.invoke()` does NOT support streaming
- Backend uses dual conversation threads (SQL agent + Response agent) requiring separate ID tracking client-side

### Expected Features

The backend already implements most heavy-lifting server-side. The Flutter client must deliver standard AI chat UX that users expect from ChatGPT, Claude, and WHOOP Coach-style experiences.

**Must have (table stakes):**
- **Streaming response display:** Token-by-token text appearance with sub-2s time-to-first-token (server already streams, client must render)
- **Pipeline progress indicators:** Visual feedback during 3-8s processing ("Reading through your Logly", "Grabbing entries", "Generating response")
- **Suggested starter questions:** Combat blank-page paralysis, teach capabilities (server has `ai_insight_suggested_prompt` table with 3 seed prompts)
- **Multi-turn conversations:** Follow-up question support via `previous_response_id` and `previous_conversion_id` (server-side logic complete)
- **Markdown-formatted responses:** Bold numbers, lists, structured formatting (server outputs markdown, client has `gpt_markdown` package)
- **Graceful error handling:** Network failures, entitlement expiry, bad queries, empty data — all need friendly messaging
- **Pro subscription gating:** RevenueCat `ai-insights` entitlement check (server enforces, client needs gate UI)
- **Standard chat mechanics:** Input handling, auto-scroll, disabled-during-streaming, keyboard management

**Should have (competitive differentiators):**
- **Contextual follow-up suggestions:** 2-3 chips after each response ("Compare to last week", "Show monthly trend") — reduces typing, deepens engagement
- **Conversation history persistence:** Save/browse past conversations, continue where you left off (requires new DB tables + list UI)
- **Encouraging tone with personal records:** Celebrate milestones ("That's your longest run ever!") — transforms data analysis into coaching
- **Haptic and animation feedback:** Polish details that separate premium from passable (client-side only, low effort)

**Defer (v2+):**
- **Data-aware starter personalization:** "You logged 12 yoga sessions this month — ask about your streak!" (high complexity, requires user data analysis)
- **Activity-context deep links:** Tap activity mentions to navigate to detail screens (requires structured responses + entity extraction)
- **Conversation search:** Full-text search across past conversations (requires history feature first)
- **Query confidence indicators:** Show when AI is uncertain (medium transparency research shows this is trust sweet spot)

**Explicitly avoid (anti-features):**
- **Showing raw SQL to users:** Research shows medium transparency is optimal, high transparency decreases engagement
- **Voice input:** Adds platform complexity for marginal benefit (PROJECT.md explicitly defers)
- **Chart generation in responses:** Requires rendering pipeline, chart selection logic, excessive LLM context
- **General-purpose chatbot:** Strict domain boundaries — ONLY answer questions about user's logged data

### Architecture Approach

The architecture is a dual-agent pipeline split across Supabase Edge Functions (already deployed) and Flutter client (to be built). The client follows Logly's established patterns: domain models (Freezed), repositories (data access), services (business logic), providers (Riverpod state management), presentation (UI).

**Major components:**

1. **AI Chat Repository (Flutter):** HTTP POST to `/functions/v1/ai-insights` with Supabase JWT, parses SSE stream into typed `ChatEvent` objects (`StepEvent`, `TextDeltaEvent`, `ResponseIdEvent`, etc.), fetches suggested prompts, fetches history
2. **AI Chat Service (Flutter):** Validates input, coordinates repository calls, checks entitlements, orchestrates between multiple providers (follows existing Logly service pattern)
3. **AI Chat State Provider (Riverpod):** Manages message list, streaming state, `lastResponseId`/`lastConversionId` for multi-turn, step progress, user-scoped state (not `keepAlive` since screen-scoped)
4. **Chat Screen (flutter_chat_ui):** Message rendering, input composer, suggested prompts widget, step progress widget, error states
5. **Edge Function Pipeline (Deno/TS — existing):** Auth middleware, entitlement gate, NL-to-SQL agent (fine-tuned), SQL validator (regex), SQL executor (direct Postgres), Response agent (streaming), persistence

**Key patterns to follow:**
- **Optimistic UI with streaming backfill:** Add user message + placeholder AI message immediately, fill in as deltas arrive
- **Dual-thread conversation state:** Separate `previousResponseId` (Response agent) and `previousConversionId` (SQL agent) — both sent with each request
- **Repository-level SSE parsing:** Transport concerns stay in data layer, domain events (`ChatEvent` sealed class) yielded to service/provider
- **Step progress as in-message UI:** Animated checklist inside AI message bubble during streaming, not separate loading spinner

**Critical anti-patterns to avoid:**
- **Using `supabase.functions.invoke()` for SSE:** SDK returns full response at once, not streamed (Issue #894 still open)
- **Managing full conversation history client-side:** Server manages via `previous_response_id`, do NOT duplicate with message arrays
- **Persisting chat in local Drift/SQLite:** No offline functionality needed (network required), adds complexity without value
- **Parsing SSE by chunk boundaries:** Network can merge/split events; must buffer and split on `\n\n` delimiters

### Critical Pitfalls

Research identified 12 domain-specific pitfalls across severity levels. Top 5 by impact:

1. **Regex-only SQL validation is bypassable** — Current blocklist (`DROP`, `DELETE`, etc.) can be circumvented via encoding, comment injection, or undocumented Postgres functions. **Prevention:** Create dedicated read-only database role with SELECT-only permissions, table allowlisting, `statement_timeout` enforcement, deny system catalog access. Regex is one layer, not the whole defense.

2. **Cross-user data leakage via LLM-generated SQL** — System relies on fine-tuned model to include `WHERE user_id = '...'` but LLM is probabilistic. Current implementation bypasses RLS (direct `SUPABASE_DB_URL` connection). **Prevention:** Never rely on LLM for user scoping. Enforce PostgreSQL Row-Level Security (RLS) policies on all user tables, set session variable `app.current_user_id` before query execution, validate SQL includes user filter post-generation.

3. **Silent wrong results (queries execute but return incorrect data)** — Most dangerous failure mode: user asks "How many runs this week?" and gets `0` due to wrong join, hallucinated column, or semantic misinterpretation. No error signal, user trusts wrong data. **Prevention:** Result sanity checks (if 0 rows but user has data, flag uncertainty), schema validation (reject non-existent columns), EXPLAIN analysis, user feedback mechanism, monitoring dashboard for silent failures.

4. **Fine-tuned model drift when schema changes** — Model trained on current schema, weights frozen. When database evolves (new tables, renamed columns), model generates SQL against old schema. **Prevention:** Schema-in-prompt as primary (already done with `COMPRESSED_SCHEMA`), automated schema sync on migrations, training data versioning, monitoring with alerts on error rate spikes, hybrid approach (fine-tuned for common, base model for novel).

5. **Latency from two sequential LLM calls** — NL-to-SQL (non-streamable, blocks SQL execution) then Response generation (streamable). Creates 3-8s perceived latency on mobile. **Prevention:** Stream intermediate artifacts (already implemented), optimize NL-to-SQL token count, compress query results before response model, consider single-call for simple queries, connection warmup, cache previous messages locally.

**Moderate pitfalls:**
- **Unbounded OpenAI API costs:** No per-user rate limits, heavy users can make feature unprofitable (~$0.003-$0.01/message, 100 messages/day = $0.30-$1.00/day per user)
- **Multi-turn context window exhaustion:** Conversation history accumulates, increases token costs linearly, "lost in the middle" effect degrades quality
- **SSE stream fragility on mobile:** No reconnection logic, no event IDs, iOS background suspension causes silent stream death

**Minor pitfalls:**
- Empty chat state discouraging first use, ambiguous queries without clarification, error messages exposing technical details

## Implications for Roadmap

Based on research, the project splits naturally into 4 phases:

### Phase 1: Foundation — Repository & Domain Models
**Rationale:** SSE stream parsing is the hardest Flutter component (no `supabase_flutter` support, chunk boundary handling tricky). Build and test this foundation first before layering state management and UI. Follows dependency order: data layer before application layer before presentation.

**Delivers:**
- Freezed domain models (`ChatMessage`, `ChatEvent` sealed class, `SuggestedPrompt`, `AiInsightException`)
- AI Chat Repository with HTTP POST to edge function, SSE stream parsing (yields `Stream<ChatEvent>`), suggested prompts fetch
- Comprehensive unit tests for SSE parser (critical: test merged chunks, split events, all event types)

**Addresses features:** None directly (infrastructure layer), but blocks all other features

**Avoids pitfalls:** #8 (SSE fragility) — build with timeouts and error handling from day 1

**Research flag:** **Skip research-phase** — well-documented HTTP streaming patterns, existing edge function code is primary reference

---

### Phase 2: Business Logic — Service & State Management
**Rationale:** With data pipeline working, wire up Riverpod state management following Logly patterns. Service layer validates input and coordinates repository. Provider manages message list, streaming lifecycle, conversation IDs.

**Delivers:**
- AI Chat Service (input validation, entitlement coordination, orchestrates repository)
- AI Chat State Provider (message list, `lastResponseId`/`lastConversionId`, `isStreaming` flag, step progress state)
- Integration tests (mock repository, verify state transitions: idle → streaming → complete/error)

**Addresses features:** Multi-turn conversation logic (store/forward response IDs), error handling coordination

**Avoids pitfalls:** #6 (unbounded costs) — implement rate limiting in service layer, #7 (context exhaustion) — conversation length limits

**Research flag:** **Skip research-phase** — follows existing Logly service/provider patterns exactly

---

### Phase 3: Chat UI — Presentation Layer (MVP Complete)
**Rationale:** With state management working, build visible interface. This phase completes the MVP — all table-stakes features delivered. User can ask questions, see streaming responses, use suggested starters, handle errors, multi-turn conversations work.

**Delivers:**
- Chat Screen with `flutter_chat_ui` integration (message list, input composer, auto-scroll)
- Step progress widget (animated checklist inside AI message bubble showing pipeline stages)
- Suggested prompts widget (tappable chips for empty state and after responses)
- Chat empty state (capability disclosure + starters)
- Route registration in `app_router.dart` with RevenueCat entitlement guard
- Navigation entry point (button/tab to access chat)
- Error state UI (network failures, timeouts, retry buttons)
- Loading states (shimmer for suggested prompts fetch)

**Addresses features:**
- **Table stakes:** Streaming display, progress indicators, suggested starters, markdown formatting, chat input UX, graceful error handling, pro gate, empty data acknowledgment
- **First differentiator:** Contextual follow-up suggestions (2-3 chips after each response)

**Avoids pitfalls:** #10 (empty chat state), #11 (error messages exposing details), #8 (SSE timeouts via client-side fallback)

**Research flag:** **Skip research-phase** — `flutter_chat_ui` is well-documented, existing Logly routing patterns apply

---

### Phase 4: Hardening & Polish
**Rationale:** MVP works end-to-end. This phase addresses security gaps, cost controls, and production readiness. Security hardening (read-only role, RLS) is critical before scaling beyond beta users.

**Delivers:**
- **Security hardening:** Dedicated read-only Postgres role (`ai_query_reader`), RLS policies on user tables, session variable for `app.current_user_id`, schema allowlisting, `statement_timeout` at role level
- **Cost controls:** Per-user message rate limits (daily cap), token usage tracking/aggregation, OpenAI budget alerts, request deduplication
- **Robustness:** Client-side SSE timeout (30s), partial response persistence, fallback polling endpoint for dropped streams, iOS app lifecycle handling
- **Monitoring:** Dashboard for SQL errors, token costs, user feedback, silent failure detection (empty results when user has data)
- **New conversation action:** Button to clear IDs and start fresh context
- **Result sanity checks:** Validate empty results against user data, schema validation of generated SQL, EXPLAIN dry-run

**Addresses features:** None new, hardens existing

**Avoids pitfalls:** #1 (regex bypass), #2 (cross-user leakage), #3 (silent wrong results), #4 (schema drift monitoring), #6 (cost controls), #8 (stream reliability)

**Research flag:** **Needs research-phase** — RLS policy patterns, Postgres role setup, session variable mechanics need focused research during implementation

---

### Phase 5+ (Post-MVP): Differentiators
**Rationale:** With secure, reliable MVP in production, add competitive features that deepen engagement and justify premium pricing.

**Candidate features (prioritize based on user feedback):**
- **Conversation history persistence:** New DB tables (`conversation`, `message`), list UI, conversation selection, message hydration (HIGH complexity)
- **Conversation search:** Full-text search across past messages via Supabase `tsvector` (MEDIUM, requires history first)
- **Data-aware starter personalization:** Analyze user's recent data, generate personalized prompts ("You logged 12 yoga sessions — ask about your streak!") (HIGH complexity)
- **Activity-context deep links:** Make activity mentions tappable, navigate to detail screens (HIGH, requires structured responses + entity extraction)
- **Query confidence indicators:** Show uncertainty when NL-to-SQL model has low confidence (MEDIUM, builds trust via transparency)
- **Encouraging tone with personal records:** Enrich response agent with historical bests, celebrate milestones (MEDIUM, requires best-tracking logic)

**Research flag:** **History + Search need research-phase** (conversation modeling patterns, Supabase FTS best practices)

---

### Phase Ordering Rationale

**Why this sequence:**
1. **Data layer first (Phase 1):** SSE parsing is the hardest technical challenge with least documentation. Get it right before building on top of it. Testable in isolation.
2. **State management second (Phase 2):** Cannot build UI without working state. Service/provider layer is Logly's established pattern, low risk.
3. **UI third (Phase 3):** Completes vertical slice, delivers user value. All table-stakes features in one phase for coherent MVP.
4. **Security/hardening fourth (Phase 4):** MVP works, now production-ready it. Security hardening requires DB schema changes (RLS policies, new role) that are safer to test against working system.
5. **Differentiators last (Phase 5+):** Validate MVP with users before investing in complex features. User feedback will inform which differentiators to prioritize.

**Dependency alignment:**
- Phases 1-3 are strictly sequential (data → state → UI)
- Phase 4 can partially overlap with Phase 3 (e.g., cost monitoring can start during Phase 3 testing)
- Phase 5+ features are independent, can be prioritized dynamically

**Pitfall mitigation:**
- Security pitfalls (#1, #2) addressed in Phase 4 before production scale
- UX pitfalls (#10, #8) addressed in Phase 3 via empty state and timeouts
- Cost/latency pitfalls (#6, #5) addressed in Phase 4 hardening
- Ongoing pitfalls (#4 schema drift, #3 wrong results) addressed via monitoring in Phase 4

### Research Flags

**Phases needing `/gsd:research-phase` during planning:**
- **Phase 4 (Security Hardening):** Postgres role setup, RLS policy patterns for multi-tenant text-to-SQL, session variable mechanics (`SET app.current_user_id`), schema allowlisting approaches
- **Phase 5+ (Conversation History):** Conversation data modeling (thread vs message tables), Supabase FTS for search, hydration strategies for long conversations

**Phases with standard patterns (skip research-phase):**
- **Phase 1 (Repository):** HTTP streaming in Dart is well-documented, SSE parsing is straightforward once buffering is understood
- **Phase 2 (Service/Provider):** Follows existing Logly patterns exactly, internal codebase is the reference
- **Phase 3 (Chat UI):** `flutter_chat_ui` has comprehensive docs and examples, established Logly routing patterns

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Backend fully deployed and working, Flutter packages verified on pub.dev (current versions checked 2026-02-02), SSE limitation confirmed via GitHub Issue #894 |
| Features | HIGH | Based on competitive analysis (WHOOP Coach, ChatGPT Health, Apple Health+), UX research from NN/g and Smashing Magazine, table stakes vs differentiators clearly categorized |
| Architecture | HIGH | Existing edge function code reviewed directly, Flutter patterns match Logly's established codebase, dual-thread conversation state verified in `agent.ts` |
| Pitfalls | HIGH | Critical pitfalls verified via codebase review (raw DB connection, user_id as string literal confirmed in `agent.ts`), security issues cross-referenced with OWASP/PortSwigger, performance issues validated against Google Cloud/AWS production learnings |

**Overall confidence:** HIGH

The combination of complete backend infrastructure (verified by direct code review), established Flutter patterns (existing Logly codebase), and domain-specific research (text-to-SQL is a well-studied problem with clear documentation of failure modes) gives high confidence in the recommended approach.

### Gaps to Address

Despite high overall confidence, several gaps need attention during planning/execution:

1. **RLS policy specifics for text-to-SQL:** General RLS patterns are well-documented, but the specific pattern of setting session variables before executing untrusted SQL needs focused research in Phase 4. The codebase currently bypasses RLS entirely, so this is greenfield implementation.

2. **SSE reconnection edge cases on iOS:** While SSE fragility is documented, the specific behavior when iOS suspends the app mid-stream needs empirical testing. Fallback polling strategy may need refinement based on actual network conditions.

3. **Fine-tuned model retraining cadence:** The training data shows incremental batches (`nl_to_sql_gaps_batch1/2/3.jsonl`) but the optimal retraining trigger (error rate threshold? time interval? schema change severity?) needs to be determined empirically. Start with monitoring, iterate based on drift detection.

4. **Token cost modeling at scale:** Current cost estimates ($0.003-$0.01/message) are based on average token counts from training data. Real usage patterns may differ (longer questions, more complex queries). Monitor actual costs in Phase 3/4 to validate rate limit thresholds.

5. **Conversation history data model:** Deferred to Phase 5+, but worth noting: The existing `user_ai_insight` table logs individual queries but does not model conversations as first-class entities. Designing the `conversation` and `message` schema will require careful thought about thread boundaries, message ordering, and hydration performance.

6. **OpenAI Responses API longevity:** The Responses API is OpenAI's recommended path forward (per their docs), but it is newer than Chat Completions API. Monitor for deprecation notices or major API changes. The `previous_response_id` chaining mechanism is well-documented but less battle-tested than full message history approaches.

**How to handle during planning/execution:**
- **Phase 1-3:** Proceed with high confidence, gaps are post-MVP
- **Phase 4:** Dedicated research spike for RLS patterns before implementation, allocate buffer time for iOS testing
- **Phase 5+:** Validate MVP first, then research conversation modeling based on actual usage patterns observed in production

## Sources

### Primary (HIGH confidence)

**Codebase (verified via direct reading):**
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/agent.ts` — Complete pipeline implementation, dual-thread conversation logic, OpenAI API calls
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/security.ts` — SQL validation regex, keyword blocklist
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/schema.ts` — Compressed schema, NL-to-SQL system prompt
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/streamHandler.ts` — SSE protocol, event types, stream lifecycle
- `/Users/robsnider/StudioProjects/logly/supabase/functions/ai-insights/index.ts` — Auth middleware, entitlement checks
- `/Users/robsnider/StudioProjects/logly/supabase/database.types.ts` — Full database schema
- `/Users/robsnider/StudioProjects/logly/lib/app/router/routes.dart` — Navigation patterns
- `/Users/robsnider/StudioProjects/logly/lib/features/home/application/home_service.dart` — Service pattern reference
- Training data files: `nl_to_sql_gaps_batch1/2/3.jsonl` — Fine-tuning examples, schema patterns

**Official documentation:**
- [OpenAI Responses API](https://platform.openai.com/docs/api-reference/responses) — `previous_response_id` mechanism
- [OpenAI Conversation State](https://platform.openai.com/docs/guides/conversation-state) — Response vs Conversation API comparison
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions) — Edge function architecture
- [Supabase Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security) — RLS patterns
- [PostgreSQL Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html) — RLS documentation
- [flutter_chat_ui on pub.dev](https://pub.dev/packages/flutter_chat_ui) — v2.11.1 verified 2026-02-02
- [flyer_chat_text_stream_message](https://pub.dev/packages/flyer_chat_text_stream_message) — v2.3.0 verified
- [http package](https://pub.dev/packages/http) — v1.6.0 verified
- [supabase-flutter Issue #894](https://github.com/supabase/supabase-flutter/issues/894) — SSE support status (still open)

### Secondary (MEDIUM confidence)

**Security:**
- [OWASP SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [PortSwigger: SQL Injection Bypassing Filters](https://portswigger.net/support/sql-injection-bypassing-common-filters)
- [ICSE 2025: P2SQL Injections](https://dl.acm.org/doi/10.1109/ICSE55347.2025.00007) — Prompt-to-SQL attack vectors
- [Bytebase: Postgres RLS Footguns](https://www.bytebase.com/blog/postgres-row-level-security-footguns/)

**Performance & Architecture:**
- [Google Cloud: Six Failures of Text-to-SQL](https://medium.com/google-cloud/the-six-failures-of-text-to-sql-and-how-to-fix-them-with-agents-ef5fd2b74b68)
- [AWS: Enterprise-grade NL-to-SQL](https://aws.amazon.com/blogs/machine-learning/enterprise-grade-natural-language-to-sql-generation-using-llms-balancing-accuracy-latency-and-scale/)
- [Waii: Cutting SQL Response Times in Half](https://blog.waii.ai/large-latency-models-how-we-cut-sql-response-times-in-half-ea8073689e09)
- [OpenAI: Latency Optimization](https://platform.openai.com/docs/guides/latency-optimization)
- [Microsoft: Context Window Management](https://devblogs.microsoft.com/semantic-kernel/managing-chat-history-for-large-language-models-llms/)

**UX & Features:**
- [NN/g: Prompt Controls in GenAI Chatbots](https://www.nngroup.com/articles/prompt-controls-genai/) — Reducing typing burden
- [Smashing Magazine: AI Interface Design Patterns](https://www.smashingmagazine.com/2025/07/design-patterns-ai-interfaces/)
- [Google PAIR: Errors + Graceful Failure](https://pair.withgoogle.com/chapter/errors-failing/)
- [Cloudscape: GenAI Loading States](https://cloudscape.design/patterns/genai/genai-loading-states/)
- [Salesforce: Text-to-SQL Agent Learnings](https://www.salesforce.com/blog/text-to-sql-agent/)
- [Understanding Algorithm Transparency in Text-to-SQL](https://arxiv.org/html/2410.16283) — Medium transparency optimal

**Competitive:**
- [OpenAI ChatGPT Health](https://macdailynews.com/2026/01/07/openai-launches-chatgpt-health-featuring-apple-health-integration/) — Privacy patterns
- [Feed.fm 2026 Fitness Ecosystem Report](https://www.feed.fm/2026-digital-fitness-ecosystem-report) — AI as table stakes

### Tertiary (LOW confidence, needs validation)

- [Apple Health+ AI Coach](https://apple.gadgethacks.com/news/apple-health-ai-coach-launches-2026-revolutionary-features/) — Upcoming competitive feature (rumor-level)

---

*Research completed: 2026-02-02*
*Ready for roadmap: yes*
