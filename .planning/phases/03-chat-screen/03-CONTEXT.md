# Phase 3: Chat Screen - Context

**Gathered:** 2026-02-02
**Status:** Ready for planning

<domain>
## Phase Boundary

Core chat UI where users type a question and see a streaming AI response with step-by-step progress indicators, markdown formatting, and graceful error handling. Navigation uses the existing LoglyAI button on the profile screen. Pro gate is already handled by RevenueCat paywall. Multi-turn conversation, persistence, and follow-up suggestions are Phase 4.

</domain>

<decisions>
## Implementation Decisions

### Message layout & styling
- Flat layout (no bubbles) — ChatGPT/Claude style
- User messages displayed in a flat card (0 elevation), AI messages without a card — visual distinction without labels
- No labels or avatars — the card vs no-card difference identifies who's speaking
- Spacing only between messages — no divider lines, no background alternation
- AI response text slightly larger font than user messages
- Rich markdown rendering using the `gpt_markdown` library — bold, italic, lists, headers, code blocks
- Typewriter effect for streaming text (using existing TypewriterBuffer from Phase 2)
- Smart auto-scroll — pins to bottom while near bottom, stops if user scrolls up

### Step progress display
- Steps show as spinner + friendly label while processing, checkmark replaces spinner on complete
- Once all steps complete and response starts streaming, steps collapse into a non-expandable summary
- Summary format: "Processed in N steps (X.Xs)" — includes both step count and total duration
- Summary is informational only — not tappable, not expandable

### Input & sending behavior
- Floating rounded text field above the keyboard (not fixed to bottom edge)
- Send icon button on the right
- Auto-expanding input for multi-line questions — grows up to ~4-5 lines, then scrolls internally
- While streaming: input stays visible but disabled with placeholder like "Waiting for response..."
- Stop button replaces send button during streaming — cancels request and keeps any partial text displayed

### Error handling
- Errors appear inline in the chat flow, styled as an error message (not a toast or snackbar)
- On error: user's original message is removed from chat and placed back in the input field so they can edit or re-send
- Error message shows in chat with friendly wording — no technical details exposed

### Empty state
- Branded welcome screen with Logly AI logo/icon and welcome message
- 3 suggestion chips below the welcome — tapping a chip sends that message immediately and starts the chat

### Pro gate
- Already handled by RevenueCat paywall — no additional UI needed in the chat screen

### Claude's Discretion
- Exact spinner animation style
- Specific placeholder text wording
- Welcome screen illustration/icon design
- Suggestion chip content (the 3 starter questions)
- Exact card styling (border radius, padding, background color)
- Stop button icon and positioning details
- Error message wording

</decisions>

<specifics>
## Specific Ideas

- Layout inspired by Claude's web UI — user messages in cards, AI messages plain
- Use `gpt_markdown` library (user specified) for markdown rendering
- TypewriterBuffer already exists from Phase 2 — use it for the streaming text effect

</specifics>

<deferred>
## Deferred Ideas

- Suggestion chips after AI responses (follow-up suggestions) — Phase 4
- Multi-turn conversation context — Phase 4
- Chat history persistence — Phase 4
- Starter questions on empty chat (the smart/dynamic ones) — Phase 4 (Phase 3 uses static suggestions)

</deferred>

---

*Phase: 03-chat-screen*
*Context gathered: 2026-02-02*
