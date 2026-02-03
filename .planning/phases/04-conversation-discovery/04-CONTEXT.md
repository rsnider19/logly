# Phase 4: Conversation & Discovery - Context

**Gathered:** 2026-02-03
**Status:** Ready for planning

<domain>
## Phase Boundary

Multi-turn conversation support with context retention, chat history persistence, starter questions on empty state, and follow-up suggestions after AI responses. Backend owns message persistence; client is presentation layer only.

</domain>

<decisions>
## Implementation Decisions

### Starter Questions
- Source from existing Supabase table `ai_insight_suggested_prompt`
- Display 3 questions on empty chat state
- Use existing column-of-chips UI pattern (already built)
- Stay fixed within session — no refresh option

### Follow-up Suggestions
- AI generates 2-3 contextual suggestions per response
- Sent with the `done` SSE event from edge function
- Displayed as chips below the AI message
- Chips stay visible while user types
- Chips removed when user sends a message (their own or tapping a chip)

### Conversation History
- Multiple conversations supported (not single continuous thread)
- History button in chat screen header opens history list
- Conversations titled by first message snippet (truncated)
- Individual delete via swipe or long-press (no "clear all")

### Session Persistence
- Empty state shown on chat screen open (not auto-load last conversation)
- All messages stored in Supabase (no local Drift cache)
- No limit on conversation history retention
- Paginated loading when viewing a conversation from history (scroll-up loads more)
- Streams continue in background if user navigates away
- Explicit "New Chat" button to start fresh conversation
- Conversation auto-created on first message (not on screen open)
- Backend (edge function) owns all message persistence — client is UI only

### AI Context Window
- All messages stored permanently for analysis/fine-tuning
- Token-conscious approach for active chat context (Claude decides rolling window strategy)

### Claude's Discretion
- Exact pagination page size for history loading
- Rolling window size for AI context (balance token cost vs. context quality)
- History list UI details (sort order, empty state)
- "New Chat" button placement and styling

</decisions>

<specifics>
## Specific Ideas

- Backend controls message storage — client should not write directly to message tables
- Follow-up suggestions are AI-generated (not templates) and come with the done event
- Reuse existing `ai_insight_suggested_prompt` table rather than new starter questions infrastructure

</specifics>

<deferred>
## Deferred Ideas

- Analytics schema for messages (token usage, SQL generated, durations) — Phase 5: Observability
- Auto-timeout to start new conversation after inactivity — not needed for now

</deferred>

---

*Phase: 04-conversation-discovery*
*Context gathered: 2026-02-03*
