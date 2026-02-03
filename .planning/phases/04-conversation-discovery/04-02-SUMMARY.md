---
phase: 04
plan: 02
subsystem: chat
tags: [sse, follow-ups, prompts, supabase, riverpod]

dependency-graph:
  requires:
    - 04-01 (chat history tables with ai_insight_suggested_prompt table)
    - 01-01 (SSE protocol with done event)
  provides:
    - Follow-up suggestions in done SSE event
    - Dynamic starter prompts from Supabase
    - Shimmer loading state for prompts
  affects:
    - 04-03 (may consume follow-up suggestions in UI)

tech-stack:
  added: []
  patterns:
    - Marker-based text extraction for LLM output parsing
    - AsyncValue.when for loading/error/data states

key-files:
  created:
    - lib/features/chat/data/chat_suggested_prompt_repository.dart
    - lib/features/chat/data/chat_suggested_prompt_repository.g.dart
    - lib/features/chat/presentation/providers/chat_starter_prompts_provider.dart
    - lib/features/chat/presentation/providers/chat_starter_prompts_provider.g.dart
  modified:
    - supabase/functions/chat/streamHandler.ts
    - supabase/functions/chat/prompts.ts
    - supabase/functions/chat/pipeline.ts
    - lib/features/chat/presentation/widgets/chat_empty_state.dart

decisions:
  - key: follow-up-in-done-event
    choice: "Include follow_up_suggestions in done SSE event, not as separate event"
    reason: "Per user decision - simpler protocol, done event is natural completion point"
  - key: marker-based-extraction
    choice: "Use HTML comment marker <!-- FOLLOW_UPS: [...] --> for follow-up JSON"
    reason: "Hidden from markdown rendering, easily parseable, no conflict with response text"
  - key: streaming-filter
    choice: "Strip marker from text deltas before sending to client"
    reason: "Marker should never appear in UI, but we need full text for extraction"

metrics:
  duration: "3 minutes"
  completed: "2026-02-03"
---

# Phase 4 Plan 02: Follow-up Suggestions & Starter Prompts Summary

Follow-up suggestions embedded in done SSE event using marker extraction; starter prompts fetched from Supabase with shimmer loading.

## What Was Built

### Edge Function Updates

1. **DoneMessage interface** (`streamHandler.ts`):
   - Added optional `follow_up_suggestions?: string[]` field
   - Updated `sendDone(followUpSuggestions?: string[])` to accept and include suggestions

2. **Response instructions** (`prompts.ts`):
   - Added `FOLLOW_UP_MARKER` constant for extraction
   - Added FOLLOW-UP SUGGESTIONS section to RESPONSE_INSTRUCTIONS
   - LLM now appends `<!-- FOLLOW_UPS: ["...", "..."] -->` to responses

3. **Pipeline extraction** (`pipeline.ts`):
   - Accumulates full response text during streaming
   - Filters marker from text deltas (never shown in UI)
   - Extracts follow-ups after streaming completes
   - Passes suggestions to `sendDone(followUps)`

### Flutter Updates

1. **ChatSuggestedPromptRepository** (new):
   - Fetches from `ai_insight_suggested_prompt` table
   - Filters by `is_active = true`, orders by `display_order`
   - Uses `@Riverpod(keepAlive: true)` per project patterns

2. **chatStarterPromptsProvider** (new):
   - Auto-disposing future provider
   - Returns prompts from repository
   - Falls back to hardcoded prompts on error or empty

3. **ChatEmptyState** (updated):
   - Converted to ConsumerWidget
   - Watches `chatStarterPromptsProvider`
   - Shows shimmer chips during loading
   - Shows fallback chip on error

## Technical Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Follow-up location | In done event | Simpler protocol, natural completion point |
| Marker format | HTML comment | Hidden from markdown, no text conflicts |
| Streaming filter | Strip during delta | Clean UI while preserving full text |
| Provider type | Auto-dispose | Prompts don't need keepAlive, re-fetch is fine |

## Deviations from Plan

None - plan executed exactly as written.

## Commits

| Commit | Type | Description |
|--------|------|-------------|
| 7657b49 | feat | Add follow-up suggestions to done SSE event |
| 50efb97 | feat | Add starter prompts repository and provider |
| 63cd9bd | feat | Update ChatEmptyState to use dynamic prompts |

## Verification Results

- [x] Done event has follow_up_suggestions field
- [x] Pipeline extracts follow-ups from marker
- [x] Repository fetches from ai_insight_suggested_prompt
- [x] Provider exists with fallback logic
- [x] ChatEmptyState uses provider
- [x] Build runner generates .g.dart files
- [x] Zero analyzer errors in modified files

## Next Phase Readiness

**Ready for 04-03:**
- Follow-up suggestions available in done event payload
- Flutter UI can consume suggestions from done event once ChatEvent is updated
- Starter prompts already displaying from Supabase

**Dependencies satisfied:**
- ai_insight_suggested_prompt table exists (from previous migration)
- SSE done event updated to carry suggestions
