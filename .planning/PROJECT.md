# Logly

## What This Is

Logly is a Flutter mobile app for tracking and logging personal activities (fitness, wellness, lifestyle). Users log activities with metrics, sync health data from Apple HealthKit/Google Health Connect, view statistics and streaks, and get AI-powered insights. Available on iOS and Android with Supabase as the backend.

## Core Value

Users can effortlessly track any personal activity and see meaningful patterns in their behavior over time.

## Requirements

### Validated

- ✓ User can sign in with Apple or Google OAuth — existing
- ✓ User session persists across app restarts — existing
- ✓ User can browse and select from an activity catalog — existing
- ✓ User can log activities with custom detail fields and metrics — existing
- ✓ User can view daily activity history with pagination — existing
- ✓ User can view activity statistics, streaks, and trends — existing
- ✓ User can sync health data from Apple HealthKit / Google Health Connect — existing
- ✓ User can manage profile and preferences — existing
- ✓ User can subscribe to pro features via in-app purchase (RevenueCat) — existing
- ✓ User receives local push notification reminders — existing
- ✓ App works offline with local Drift/SQLite caching — existing
- ✓ Errors tracked via Sentry in production builds — existing
- ✓ Feature flags and A/B testing via GrowthBook — existing

### Active

- [ ] AI chat: User can ask natural language questions about their logged data
- [ ] AI chat: System converts questions to Postgres queries via Supabase edge function
- [ ] AI chat: OpenAI GPT generates and executes queries against user's data
- [ ] AI chat: Responses are friendly, encouraging, and data-backed
- [ ] AI chat: Multi-turn conversations with context retention
- [ ] AI chat: Chat history persisted in Supabase
- [ ] AI chat: Dedicated chat screen accessible from main navigation
- [ ] AI chat: Suggested starter questions shown on empty chat
- [ ] AI chat: Gated behind pro subscription

### Out of Scope

- Real-time streaming responses (v1 sends complete responses) — keep initial implementation simple
- Voice input for chat — text input sufficient for v1
- Chat export or sharing — no clear user need yet
- AI-initiated proactive insights/notifications — build reactive chat first, proactive later
- Image or chart generation in responses — text-based analysis for v1

## Context

- Existing codebase is well-structured with clean architecture (domain/data/application/presentation layers)
- Chat UI packages already in pubspec: `flutter_chat_core`, `flutter_chat_ui`, `flyer_chat_text_stream_message`, `gpt_markdown`
- Supabase edge functions (TypeScript/Deno) already used in the project
- RevenueCat subscription infrastructure already in place for pro gating
- Database schema accessible via `supabase/schema.ts` for LLM context
- The text-to-SQL approach requires careful security: read-only access, user-scoped queries, timeouts

## Constraints

- **AI Provider**: OpenAI GPT via API — user preference
- **Security**: API keys must stay server-side in Supabase edge functions — never in client
- **Data Access**: Generated SQL must be scoped to the authenticated user's data only — prevent cross-user data leaks
- **Query Safety**: Read-only queries only, with timeout limits — prevent destructive or runaway queries
- **Subscription**: Feature gated behind existing pro subscription — no new payment infrastructure
- **Tech Stack**: Flutter + Supabase + Riverpod — match existing architecture patterns

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Text-to-SQL over function calling | Maximum flexibility for user questions at the cost of response time | — Pending |
| OpenAI GPT as AI provider | User preference | — Pending |
| Supabase edge function for AI routing | Keeps API keys server-side, enables rate limiting and query validation | — Pending |
| Chat history in Supabase (not local) | Syncs across devices, survives reinstalls | — Pending |
| Pro-only feature | AI API costs require monetization gate | — Pending |

---
*Last updated: 2026-02-02 after initialization*
