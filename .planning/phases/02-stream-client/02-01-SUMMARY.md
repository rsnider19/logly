---
phase: 02-stream-client
plan: 01
subsystem: api
tags: [sse, streaming, freezed, riverpod, supabase-functions, chat, domain-models]

# Dependency graph
requires:
  - phase: 01-edge-function
    provides: chat edge function with SSE protocol (step, text_delta, response_id, conversion_id, error, done)
provides:
  - ChatEvent sealed class with 6 union variants for SSE event deserialization
  - ChatStreamState Freezed model for stream lifecycle tracking
  - ChatException hierarchy with 5 typed exceptions (connection, auth, premium, rateLimit, stall)
  - SseEventTransformer for TCP chunk buffering and SSE line parsing
  - ChatRepository with sendQuestion() returning Stream<ChatEvent>
  - chatRepositoryProvider for Riverpod dependency injection
affects: [02-stream-client plan 02 (service layer), 03-chat-ui (UI consumption)]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Freezed sealed class with @Freezed(unionKey: 'type') for SSE event deserialization"
    - "StreamTransformerBase for SSE line buffering (handles TCP chunk splitting)"
    - "async* generator with yield* for stream-based repository methods"
    - "Null-aware map elements (?value) for optional request body fields"

key-files:
  created:
    - lib/features/chat/domain/chat_event.dart
    - lib/features/chat/domain/chat_stream_state.dart
    - lib/features/chat/domain/chat_exception.dart
    - lib/features/chat/data/sse_event_parser.dart
    - lib/features/chat/data/chat_repository.dart
  modified: []

key-decisions:
  - "Used @JsonKey(name: 'responseId') for camelCase server fields to override global snake_case config"
  - "Cast response.data as Stream<List<int>> instead of http.ByteStream to avoid adding http as direct dependency"
  - "Used switch expression for HTTP status code mapping in repository error handling"

patterns-established:
  - "SSE streaming: ByteStream -> Utf8Decoder -> SseEventTransformer -> ChatEvent.fromJson pipeline"
  - "ChatEvent union: @FreezedUnionValue maps to server type field values"
  - "Chat exceptions: ChatException base extends AppException, specific subtypes for each HTTP error"

# Metrics
duration: 6min
completed: 2026-02-02
---

# Phase 2 Plan 1: Domain Models & SSE Data Layer Summary

**Freezed sealed ChatEvent with 6 SSE variants, TCP-buffered SSE parser, and chat repository streaming via supabase_flutter**

## Performance

- **Duration:** 6 min
- **Started:** 2026-02-02T22:51:34Z
- **Completed:** 2026-02-02T22:57:29Z
- **Tasks:** 2
- **Files created:** 5 source + 5 generated = 10

## Accomplishments
- ChatEvent sealed class deserializes all 6 server SSE event types with Freezed union key matching
- SseEventTransformer correctly buffers arbitrary TCP chunks and emits complete SSE event payloads on \n\n boundaries
- ChatRepository connects to chat edge function via supabase_flutter, returning typed Stream<ChatEvent>
- HTTP error codes (401, 403, 429) map to specific ChatException subtypes for the service layer

## Task Commits

Each task was committed atomically:

1. **Task 1: Domain models and exception hierarchy** - `7ba5d47` (feat)
2. **Task 2: SSE event parser and chat repository** - `156b292` (feat)

## Files Created/Modified
- `lib/features/chat/domain/chat_event.dart` - Freezed sealed class with 6 SSE event variants
- `lib/features/chat/domain/chat_stream_state.dart` - Freezed state model with connection status, text, steps, IDs
- `lib/features/chat/domain/chat_exception.dart` - Exception hierarchy (connection, auth, premium, rateLimit, stall)
- `lib/features/chat/data/sse_event_parser.dart` - StreamTransformer buffering chunks and splitting on \n\n
- `lib/features/chat/data/chat_repository.dart` - Repository with SSE stream pipeline and Riverpod provider
- `lib/features/chat/domain/chat_event.freezed.dart` - Generated Freezed code
- `lib/features/chat/domain/chat_event.g.dart` - Generated JSON serialization
- `lib/features/chat/domain/chat_stream_state.freezed.dart` - Generated Freezed code
- `lib/features/chat/domain/chat_stream_state.g.dart` - Generated JSON serialization
- `lib/features/chat/data/chat_repository.g.dart` - Generated Riverpod provider

## Decisions Made
- **JsonKey for camelCase fields:** Server sends `responseId` and `conversionId` in camelCase, but the project's global `build.yaml` uses `field_rename: snake`. Added `@JsonKey(name: 'responseId')` and `@JsonKey(name: 'conversionId')` to override for these fields only.
- **Stream<List<int>> cast instead of http.ByteStream:** Avoided adding `package:http` as a direct dependency by casting `response.data` to `Stream<List<int>>` (the supertype of `ByteStream`). This keeps the dependency tree clean.
- **Switch expression for status codes:** Used Dart switch expression for HTTP status-to-exception mapping, providing exhaustive default handling.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed analyzer lint for doc reference bracket syntax**
- **Found during:** Task 1 (chat_event.dart)
- **Issue:** `[unionKey]` in doc comment triggered `comment_references` lint (bracket syntax implies code reference)
- **Fix:** Changed to backtick syntax: `` `unionKey` ``
- **Files modified:** lib/features/chat/domain/chat_event.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 7ba5d47 (Task 1 commit)

**2. [Rule 3 - Blocking] Removed http package import to fix depend_on_referenced_packages lint**
- **Found during:** Task 2 (chat_repository.dart)
- **Issue:** `package:http` is a transitive dependency (via `supabase_flutter`), not a direct one. Import triggered `depend_on_referenced_packages` warning.
- **Fix:** Cast `response.data` as `Stream<List<int>>` (supertype of `ByteStream`) instead of `http.ByteStream`
- **Files modified:** lib/features/chat/data/chat_repository.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 156b292 (Task 2 commit)

**3. [Rule 1 - Bug] Used null-aware map element syntax for optional body fields**
- **Found during:** Task 2 (chat_repository.dart)
- **Issue:** `if (x != null) 'key': x` triggered `use_null_aware_elements` lint in Dart 3.10
- **Fix:** Changed to `'key': ?value` null-aware element syntax
- **Files modified:** lib/features/chat/data/chat_repository.dart
- **Verification:** `fvm flutter analyze` passes clean
- **Committed in:** 156b292 (Task 2 commit)

---

**Total deviations:** 3 auto-fixed (2 bug/lint, 1 blocking dependency)
**Impact on plan:** All auto-fixes necessary for clean analysis. No scope creep.

## Issues Encountered
None - implementation followed the research patterns closely.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- Domain models, SSE parser, and repository are ready for Plan 02 (service layer with typewriter buffer, stall detection, and retry logic)
- ChatStreamState provides the state shape the service layer will populate
- ChatException hierarchy provides all error types the service needs to catch and translate
- No blockers for continuing to Plan 02

---
*Phase: 02-stream-client*
*Completed: 2026-02-02*
