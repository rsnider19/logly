---
phase: 03-chat-screen
plan: 01
subsystem: ui
tags: [flutter_chat_ui, flutter_chat_core, go_router, riverpod, sse, streaming, cancellation]

# Dependency graph
requires:
  - phase: 02-stream-client
    provides: ChatStreamState, ChatStreamStateNotifier, ChatService with SSE streaming
provides:
  - ChatRoute at /chat with typed GoRouter navigation
  - Profile FAB wiring (pro users navigate to chat, non-pro see paywall)
  - ChatUiStateNotifier bridge provider mapping ChatStreamState to InMemoryChatController
  - Stream cancellation support in ChatService and ChatStreamStateNotifier
  - ChatScreen placeholder widget
affects: [03-02 chat widget, 03-03 chat UI polish, 04 conversation persistence]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Bridge provider pattern: Riverpod notifier translates domain state to UI controller operations"
    - "Fire-and-forget stream trigger: unawaited() for sendQuestion from bridge, state arrives via listener"
    - "Cancellation flag pattern: _cancelled bool checked per event loop iteration"

key-files:
  created:
    - lib/features/chat/presentation/screens/chat_screen.dart
    - lib/features/chat/presentation/providers/chat_ui_provider.dart
    - lib/features/chat/presentation/providers/chat_ui_provider.g.dart
  modified:
    - lib/app/router/routes.dart
    - lib/app/router/routes.g.dart
    - lib/features/profile/presentation/screens/profile_screen.dart
    - lib/features/chat/application/chat_service.dart
    - lib/features/chat/presentation/providers/chat_stream_provider.dart
    - lib/features/chat/presentation/providers/chat_stream_provider.g.dart

key-decisions:
  - "Used metadata map on TextStreamMessage to pass step data to future custom builder"
  - "Error handling removes both user and AI messages, inserts system message, stores query for input restoration"
  - "Bridge provider uses fire-and-forget sendQuestion with unawaited(), relying on ref.listen for state updates"
  - "Cancellation checks in both event stream loop and typewriter drain loop for responsive stop"

patterns-established:
  - "Bridge provider: ChatUiStateNotifier maps domain ChatStreamState to flutter_chat_core InMemoryChatController operations"
  - "Metadata channel: TextStreamMessage.metadata carries step progress, display text, and stream status for custom builders"
  - "Constants: kLoglyAiUserId and kSystemUserId defined in chat_ui_provider.dart for consistent author IDs"

# Metrics
duration: 6min
completed: 2026-02-02
---

# Phase 3 Plan 01: Route, Navigation, and Bridge Provider Summary

**Chat route at /chat with profile FAB navigation, ChatStreamState-to-InMemoryChatController bridge provider, and stream cancellation support**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-03T02:20:41Z
- **Completed:** 2026-02-03T02:26:50Z
- **Tasks:** 2
- **Files modified:** 9

## Accomplishments
- ChatRoute registered at /chat as top-level GoRoute (full-screen push, outside shell navigation)
- Profile FAB now navigates pro users to chat screen; non-pro users continue to see RevenueCat paywall
- ChatUiStateNotifier bridge provider translates all ChatStreamState transitions into InMemoryChatController operations
- Stream cancellation support with partial text preservation in ChatService and ChatStreamStateNotifier
- Error handling removes user/AI messages, inserts system error, and exposes query for input field restoration

## Task Commits

Each task was committed atomically:

1. **Task 1: Chat route, navigation wiring, and placeholder screen** - `c166cb8` (feat)
2. **Task 2: Stream cancellation and ChatController bridge provider** - `2048457` (feat)

## Files Created/Modified
- `lib/features/chat/presentation/screens/chat_screen.dart` - Placeholder ChatScreen ConsumerStatefulWidget
- `lib/features/chat/presentation/providers/chat_ui_provider.dart` - Bridge provider translating stream state to controller operations
- `lib/features/chat/presentation/providers/chat_ui_provider.g.dart` - Generated Riverpod provider code
- `lib/app/router/routes.dart` - Added ChatRoute at /chat as top-level TypedGoRoute
- `lib/app/router/routes.g.dart` - Generated route code including $chatRoute
- `lib/features/profile/presentation/screens/profile_screen.dart` - FAB navigates to ChatRoute for pro users
- `lib/features/chat/application/chat_service.dart` - Added cancel() method with _cancelled flag
- `lib/features/chat/presentation/providers/chat_stream_provider.dart` - Added cancelStream() method, cleanup on dispose
- `lib/features/chat/presentation/providers/chat_stream_provider.g.dart` - Regenerated provider code

## Decisions Made
- **Metadata as data channel:** Used TextStreamMessage.metadata map to carry step progress, display text, and stream status. Plan 02 custom builders will read this metadata to render step indicators and typewriter text.
- **Error removes both messages:** On error, both the user message and AI placeholder are removed from the controller, and a system message is inserted. This gives a clean slate for retry. The original query is stored in lastErrorQuery for input field restoration.
- **Fire-and-forget stream trigger:** sendMessage() uses `unawaited()` when calling sendQuestion because the stream updates arrive asynchronously via `ref.listen`. This avoids blocking the UI thread.
- **Cancellation in two loops:** The _cancelled flag is checked in both the SSE event stream loop and the typewriter drain loop, ensuring responsive cancellation regardless of which phase the stream is in.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing Critical] Added cancellation cleanup on provider dispose**
- **Found during:** Task 2 (cancelStream implementation)
- **Issue:** The ChatStreamStateNotifier had a placeholder `ref.onDispose(() {})`. When the provider is disposed during an active stream, it should cancel the service to prevent orphaned streams.
- **Fix:** Changed dispose callback to call `_service.cancel()` to clean up any in-progress stream
- **Files modified:** lib/features/chat/presentation/providers/chat_stream_provider.dart
- **Verification:** flutter analyze passes clean
- **Committed in:** 2048457 (Task 2 commit)

---

**Total deviations:** 1 auto-fixed (1 missing critical)
**Impact on plan:** Essential for preventing resource leaks. No scope creep.

## Issues Encountered
None

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- ChatRoute and navigation wiring complete, ready for Plan 02 to replace placeholder with full Chat widget
- Bridge provider ready to drive the Chat widget's message list via InMemoryChatController
- Metadata channel established for step progress and streaming state (Plan 02 custom builders will consume it)
- Stream cancellation wired end-to-end for the stop button (Plan 02 will add the UI control)

---
*Phase: 03-chat-screen*
*Completed: 2026-02-02*
