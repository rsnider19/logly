---
phase: 04-conversation-discovery
plan: 03
subsystem: api
tags: [supabase, edge-function, sse, persistence, flutter, riverpod]

# Dependency graph
requires:
  - phase: 04-01
    provides: chat_conversations and chat_messages domain models
  - phase: 04-02
    provides: follow-up suggestions extraction in pipeline
provides:
  - Backend-owned persistence (edge function writes to chat tables)
  - SSE done event with conversation_id and follow_up_suggestions
  - Flutter ChatStreamState with conversationId and followUpSuggestions
  - Read-only Flutter repositories for conversations and messages
affects: [conversation-history, conversation-resume, phase-05]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Backend-owned persistence (edge function owns all writes)
    - Read-only Flutter repositories (client only reads for display)
    - Service role key for server-side RLS bypass

key-files:
  created:
    - supabase/functions/chat/persistence.ts
    - lib/features/chat/data/chat_conversation_repository.dart
    - lib/features/chat/data/chat_message_repository.dart
  modified:
    - supabase/functions/chat/index.ts
    - supabase/functions/chat/pipeline.ts
    - supabase/functions/chat/streamHandler.ts
    - lib/features/chat/domain/chat_event.dart
    - lib/features/chat/domain/chat_stream_state.dart

key-decisions:
  - "Backend owns all writes; Flutter client is read-only"
  - "Conversation created on first message with truncated title"
  - "User message saved before processing; AI message saved after completion"
  - "conversation_id included in done event for client tracking"

patterns-established:
  - "Backend-owned persistence: edge function uses service_role to bypass RLS"
  - "Read-only client pattern: repositories have getX methods, no insert/update"
  - "Metadata enrichment: steps and follow-up suggestions stored in message metadata"

# Metrics
duration: 12min
completed: 2026-02-03
---

# Phase 4 Plan 3: Backend Persistence Summary

**Edge function persistence module with conversation/message CRUD, SSE done event with conversation_id, and read-only Flutter repositories**

## Performance

- **Duration:** 12 min
- **Started:** 2026-02-03T10:10:00Z
- **Completed:** 2026-02-03T10:22:00Z
- **Tasks:** 3
- **Files modified:** 14 (including generated files)

## Accomplishments
- Created persistence.ts module with getOrCreateConversation, saveUserMessage, saveAssistantMessage, updateConversationIds
- Updated pipeline to persist conversations and messages at correct lifecycle points
- Extended SSE done event to include conversation_id and follow_up_suggestions
- Added conversationId and followUpSuggestions to Flutter ChatStreamState
- Created read-only ChatConversationRepository and ChatMessageRepository

## Task Commits

Each task was committed atomically:

1. **Task 1: Create edge function persistence module** - `0ca2832` (feat)
2. **Task 2: Update done event with conversation_id and parse in Flutter** - `ec26e0a` (feat)
3. **Task 3: Create read-only Flutter repositories for conversations and messages** - `8a3fcc3` (feat)

## Files Created/Modified

**Created:**
- `supabase/functions/chat/persistence.ts` - Backend persistence CRUD functions using service_role
- `lib/features/chat/data/chat_conversation_repository.dart` - Read-only conversation fetching
- `lib/features/chat/data/chat_message_repository.dart` - Read-only message fetching

**Modified:**
- `supabase/functions/chat/index.ts` - Accept conversationId in request body
- `supabase/functions/chat/pipeline.ts` - Integrate persistence lifecycle
- `supabase/functions/chat/streamHandler.ts` - Add conversation_id to DoneMessage
- `lib/features/chat/domain/chat_event.dart` - Add conversationId and followUpSuggestions to ChatDoneEvent
- `lib/features/chat/domain/chat_stream_state.dart` - Add conversationId and followUpSuggestions fields

## Decisions Made

1. **Backend owns all writes** - Edge function uses service_role key to bypass RLS for writes. Client only reads data for display. This matches the architectural decision from phase planning.

2. **Conversation title from first message** - Title is truncated to 50 chars with ellipsis if longer. Simple and effective for history list display.

3. **Persistence lifecycle** - User message saved immediately before processing; AI message saved after streaming completes with full content and metadata.

4. **Metadata enrichment** - Assistant messages store follow_up_suggestions and completed steps in JSONB metadata column for future UI features.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required. Persistence uses existing Supabase service_role key.

## Next Phase Readiness

- Persistence layer complete, ready for conversation history UI
- ChatStreamState has conversationId for tracking active conversation
- Repositories ready for conversation list screen
- Follow-up suggestions available in state for suggestion chip UI

---
*Phase: 04-conversation-discovery*
*Completed: 2026-02-03*
