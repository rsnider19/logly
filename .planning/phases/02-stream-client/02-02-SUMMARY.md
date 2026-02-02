---
phase: 02-stream-client
plan: 02
subsystem: api
tags: [streaming, typewriter, riverpod, stall-detection, retry, chat, state-management]

# Dependency graph
requires:
  - phase: 02-stream-client plan 01
    provides: ChatEvent sealed class, ChatStreamState model, ChatException hierarchy, ChatRepository with sendQuestion()
provides:
  - TypewriterBuffer class with 5ms normal / 1ms drain character emission
  - ChatService with stall detection (30s), auto-retry, and event routing
  - ChatStreamStateNotifier Riverpod notifier exposing ChatStreamState to UI
  - chatStreamStateProvider with keepAlive for app-session persistence
  - Full data pipeline wired: Provider -> Service -> Repository -> Edge Function
affects: [03-chat-ui (UI consumption of chatStreamStateProvider)]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Timer.periodic-based typewriter buffer with variable rate emission"
    - "Stream.timeout for stall detection on SSE event streams"
    - "Callback-based state emission pattern (onStateUpdate) from service to notifier"
    - "Conversation ID persistence in notifier for follow-up chaining"

key-files:
  created:
    - lib/features/chat/application/typewriter_buffer.dart
    - lib/features/chat/application/chat_service.dart
    - lib/features/chat/presentation/providers/chat_stream_provider.dart
  modified: []

key-decisions:
  - "Used property access (event.status) instead of destructured pattern variables to avoid shadowing outer scope variables in switch cases"
  - "Used unawaited() for StreamController.close() calls in non-async methods to satisfy discarded_futures lint"
  - "Used backtick syntax instead of bracket syntax for non-scope doc comment references to satisfy comment_references lint"

patterns-established:
  - "TypewriterBuffer: standalone class with addDelta/markDone/dispose lifecycle, broadcast stream of full accumulated text"
  - "ChatService: callback-based state emission (onStateUpdate) for notifier integration, fresh TypewriterBuffer per request"
  - "ChatStreamStateNotifier: conversation ID persistence across requests, concurrent request blocking via status guard"

# Metrics
duration: 5min
completed: 2026-02-02
---

# Phase 2 Plan 2: Service Layer & State Notifier Summary

**TypewriterBuffer with 5ms/1ms character drip, ChatService with 30s stall detection and silent retry, and Riverpod notifier wiring the full chat data pipeline**

## Performance

- **Duration:** 5 min
- **Started:** 2026-02-02T23:00:00Z
- **Completed:** 2026-02-02T23:04:50Z
- **Tasks:** 2
- **Files created:** 3 source + 2 generated = 5

## Accomplishments
- TypewriterBuffer emits characters at 5ms normal rate with 1ms drain after done signal, broadcasting full accumulated text per emission
- ChatService orchestrates complete stream lifecycle: stall detection, auto-retry, step/text/ID event routing, typewriter buffering
- ChatStreamStateNotifier blocks concurrent requests, preserves conversation IDs for follow-ups, and exposes clean state to UI
- Full data pipeline wired end-to-end: chatStreamStateProvider -> ChatService -> ChatRepository -> supabase edge function

## Task Commits

Each task was committed atomically:

1. **Task 1: Typewriter buffer and chat service** - `01ac258` (feat)
2. **Task 2: Riverpod chat stream state notifier** - `45900c9` (feat)

## Files Created/Modified
- `lib/features/chat/application/typewriter_buffer.dart` - Standalone character drip buffer with normal (5ms) and drain (1ms) modes
- `lib/features/chat/application/chat_service.dart` - Business logic: stall detection, retry, event routing, typewriter orchestration
- `lib/features/chat/application/chat_service.g.dart` - Generated chatServiceProvider
- `lib/features/chat/presentation/providers/chat_stream_provider.dart` - Riverpod notifier with concurrent request blocking and conversation ID persistence
- `lib/features/chat/presentation/providers/chat_stream_provider.g.dart` - Generated chatStreamStateProvider

## Decisions Made
- **Property access over destructuring in switch:** Used `event.status` and `event.name` instead of destructured pattern variables (`:final status`) in switch cases to avoid shadowing outer scope variables (e.g., the outer `status` tracking variable and `responseId`/`conversionId` accumulator variables).
- **unawaited for StreamController.close:** Used `unawaited(_controller.close())` in non-async methods (`dispose`, `_ensureTimerRunning`) to explicitly discard the Future and satisfy the `discarded_futures` lint rule.
- **Backtick doc references:** Used backtick syntax for `responseId` and `conversionId` in class-level doc comments (not visible in class scope) to avoid `comment_references` lint warnings.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed variable shadowing in switch case pattern matching**
- **Found during:** Task 1 (chat_service.dart)
- **Issue:** Using `case ChatStepEvent(:final status)` shadowed the outer `var status` variable, and `case ChatResponseIdEvent(:final responseId)` shadowed the outer `String? responseId` accumulator
- **Fix:** Changed to property access pattern (`event.status`, `event.name`, `event.responseId`, `event.conversionId`) instead of destructured binding
- **Files modified:** lib/features/chat/application/chat_service.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 01ac258 (Task 1 commit)

**2. [Rule 1 - Bug] Fixed discarded_futures lint on StreamController.close()**
- **Found during:** Task 1 (typewriter_buffer.dart)
- **Issue:** `_controller.close()` returns a Future but was called in non-async methods, triggering `discarded_futures` lint
- **Fix:** Wrapped all `_controller.close()` calls with `unawaited()`
- **Files modified:** lib/features/chat/application/typewriter_buffer.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 01ac258 (Task 1 commit)

**3. [Rule 1 - Bug] Fixed comment_references lint on doc comments**
- **Found during:** Task 1 (chat_service.dart) and Task 2 (chat_stream_provider.dart)
- **Issue:** `[onStateUpdate]`, `[responseId]`, `[conversionId]` in doc comments triggered `comment_references` lint because these names aren't visible in class scope
- **Fix:** Changed bracket syntax to backtick syntax for non-scope references
- **Files modified:** lib/features/chat/application/chat_service.dart, lib/features/chat/presentation/providers/chat_stream_provider.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 01ac258 (Task 1), 45900c9 (Task 2)

---

**Total deviations:** 3 auto-fixed (all Rule 1 - Bug/lint)
**Impact on plan:** All auto-fixes necessary for clean analysis. No scope creep.

## Issues Encountered
None - implementation followed the research and plan patterns closely.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Phase 2 (Stream Client) is complete. All data layer components are built and wired.
- The full pipeline is ready for Phase 3 (Chat UI): `chatStreamStateProvider` exposes `ChatStreamState` with `displayText`, `fullText`, `status`, `completedSteps`, `errorMessage`, and conversation IDs.
- The UI layer can `ref.watch(chatStreamStateProvider)` and call `ref.read(chatStreamStateProvider.notifier).sendQuestion(query)` to initiate requests.
- No blockers for Phase 3.

---
*Phase: 02-stream-client*
*Completed: 2026-02-02*
