---
status: resolved
trigger: "Choppy streaming text - typewriter effect feels choppy and not fluid"
created: 2026-02-03T12:00:00Z
updated: 2026-02-03T12:05:00Z
---

## Current Focus

hypothesis: TypewriterBuffer emits one character at a time with Timer.periodic, causing choppy rendering
test: Analyzed code flow from SSE -> TypewriterBuffer -> Provider -> UI
expecting: Character-by-character emission is inefficient for smooth animation
next_action: Report root cause findings

## Symptoms

expected: Smooth, fluid typewriter effect as tokens stream in
actual: Text appears but feels choppy/stuttery
errors: None
reproduction: Send any message to AI and observe streaming response
started: Since typewriter buffer implementation

## Eliminated

None - root cause identified on first hypothesis

## Evidence

- timestamp: 2026-02-03T12:01:00Z
  checked: TypewriterBuffer implementation (typewriter_buffer.dart)
  found: |
    - normalInterval: 5ms per character (200 chars/sec)
    - drainInterval: 1ms per character (1000 chars/sec)
    - Emits ONE CHARACTER at a time via Timer.periodic
    - Each emission rebuilds full accumulated string from StringBuffer
  implication: Character-by-character emission creates excessive state updates

- timestamp: 2026-02-03T12:02:00Z
  checked: State flow through chat_service.dart
  found: |
    - For each character emitted, calls onStateUpdate()
    - Creates new ChatStreamState with current displayText
    - At 200 chars/sec, that's 200 provider state updates per second
  implication: Provider updates 200 times/second during streaming

- timestamp: 2026-02-03T12:03:00Z
  checked: UI update flow through chat_ui_provider.dart
  found: |
    - _onStreamStateChanged listens to chatStreamStateProvider
    - Each state change calls _updateStreamMessage()
    - _updateStreamMessage creates new Message and calls _controller.updateMessage()
    - This triggers UI rebuild for every single character
  implication: Full widget tree rebuild 200 times/second

- timestamp: 2026-02-03T12:04:00Z
  checked: Rendering path in chat_screen.dart
  found: |
    - _buildTextStreamMessage watches chatStreamStateProvider again
    - Creates new StreamState and passes to FlyerChatTextStreamMessage
    - Double-watching: both chat_ui_provider AND chat_screen watch same provider
  implication: Redundant watches amplify rebuild frequency

## Resolution

root_cause: |
  TypewriterBuffer emits characters ONE AT A TIME at 5ms intervals (200 updates/second).
  Each character emission triggers:
  1. Provider state update (ChatStreamState)
  2. Chat controller message update
  3. Full widget rebuild

  This creates 200 rebuilds/second, which exceeds Flutter's 60fps frame budget.
  The GPU cannot keep up, causing frame drops that appear as choppiness.

  Additionally, the FlyerChatTextStreamMessage already handles its own internal
  text animation/rendering, so the per-character emission from TypewriterBuffer
  is redundant - the package expects batched text updates, not character-by-character.

fix: N/A (diagnosis only)
verification: N/A
files_changed: []
