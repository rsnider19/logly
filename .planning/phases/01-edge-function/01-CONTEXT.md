# Phase 1: Edge Function - Context

**Gathered:** 2026-02-02
**Status:** Ready for planning

<domain>
## Phase Boundary

A new `chat` Supabase edge function that accepts natural language questions, converts them to safe Postgres queries via OpenAI GPT-4o-mini, executes them against user-scoped data, and streams a friendly response back via SSE. Includes security guardrails, rate limiting, and a two-call pipeline (SQL generation → response composition). The Flutter client, chat UI, conversation persistence, and observability are separate phases.

</domain>

<decisions>
## Implementation Decisions

### SQL generation guardrails
- Off-topic questions get a gentle redirect: "I can only help with your Logly data! Try asking about your activities or streaks."
- AI has access to all user-scoped data (not just activities/logs) — RLS handles row-level scoping
- Complex queries use best-effort approach — if the query times out, the timeout guardrail catches it
- Generated SQL is never shown to the user — always hidden
- Hard limit of 100 rows per query — AI is instructed to aggregate in SQL, not fetch raw rows for post-processing
- Health-related correlations include a brief disclaimer ("This isn't medical advice")
- Schema is hardcoded in the system prompt for reliable SQL generation
- One SQL query per question — no multi-query support
- GPT-4o-mini for both SQL generation and response composition
- Two separate OpenAI calls: (1) generate SQL, (2) compose friendly response from query results
- Response generation (Call 2) is streamed token-by-token via SSE

### Security & access control
- Edge function validates pro subscription server-side before processing — can't be bypassed
- Write protection via RLS policies + SQL validation (check generated SQL for write operations before executing)
- Prompt injection defense: input sanitization layer + hardened system prompt — two layers of defense
- Rate limiting: ~20 questions per hour per user
- Rate limit message is friendly: warm cooldown message, not a technical error
- Production only — no debug or admin modes (observability comes in Phase 5)

### SSE stream structure
- Simplified step labels (2-3 steps), not the full internal pipeline — friendly & casual tone
- Step labels: "Understanding your question...", "Looking up your data...", etc.
- No spinner during response streaming — spinner only for pre-response steps, then transitions to streaming text
- Step events use start + complete pairs: spinner on start, checkmark on complete
- Completed steps stay visible with checkmarks; on error, completed steps keep checkmarks and error appears below
- Event types: `step`, `text_delta`, `response_id`, `error`, `done`
- `response_id` is a dedicated SSE event (not embedded in done)
- `done` event is just a completion signal — no metadata
- Standard SSE (`text/event-stream`) with JSON payloads for all events

### Response personality & tone
- Encouraging coach personality — celebrates wins, motivates, keeps things positive
- Concise with context — direct answer plus 1-2 sentences of encouragement or insight
- Emojis used sparingly for warmth at key moments, not every sentence
- Markdown formatting: bold key numbers, bullet lists for multiple data points
- When no data found: acknowledge the gap and gently encourage ("I don't see any runs logged last week. Want to start tracking your runs?")

### Claude's Discretion
- Context passing strategy for follow-up questions (how prior Q&A context is passed to SQL generation)
- Exact statement timeout value for SQL execution
- Specific input sanitization patterns for prompt injection defense
- Exact rate limit implementation approach (in-memory, database counter, etc.)
- Step label copy refinement

</decisions>

<specifics>
## Specific Ideas

- Two-call pipeline: Call 1 generates SQL only, execute it, Call 2 composes friendly response from results — clean separation of concerns
- Rate limit message should feel warm, not punishing: "You've been busy! Give me a moment to catch up."
- Steps should feel like a friend working on your question, not a loading screen

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 01-edge-function*
*Context gathered: 2026-02-02*
