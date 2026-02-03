---
status: diagnosed
phase: 03-chat-screen
source: [03-01-SUMMARY.md, 03-02-SUMMARY.md, 03-03-SUMMARY.md]
started: 2026-02-03T03:00:00Z
updated: 2026-02-03T04:25:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Navigate to Chat from Profile
expected: On the Profile tab, tap the LoglyAI FAB. You should navigate to a full-screen chat screen.
result: pass

### 2. Pro Gate for Non-Pro Users
expected: If you are NOT a pro subscriber, tapping the LoglyAI FAB should show the RevenueCat paywall instead of navigating to chat.
result: pass

### 3. Empty State with Welcome and Suggestions
expected: On the chat screen with no messages, you should see a LoglyAI welcome screen with a sparkles icon, welcome title/subtitle, and 3 tappable suggestion chips.
result: pass

### 4. Send via Suggestion Chip
expected: Tap one of the suggestion chips (e.g., "What did I do this week?"). It should send immediately as a message without needing to type anything.
result: pass

### 5. Step Progress Indicators
expected: After sending a question, you should see step progress indicators — a spinner with a friendly label for each step. When a step completes, the spinner becomes a checkmark.
result: pass

### 6. Collapsed Step Summary
expected: After all steps complete and the text response finishes streaming, the step indicators should collapse into a single-line summary like "Processed in N steps (X.Xs)".
result: issue
reported: "they collappsed and disappeared"
severity: major

### 7. Streaming Text Response
expected: The AI response text should appear token-by-token (typewriter effect) below the step progress indicators, not all at once.
result: issue
reported: "it does, but it doesnt feel fluid; it feels a bit choppy"
severity: minor

### 8. Markdown Rendering
expected: AI responses should render markdown formatting correctly — bold, italic, lists, headers, code blocks rendered with proper formatting (not raw markdown syntax).
result: pass

### 9. Message Layout (Flat, No Bubbles)
expected: User messages appear in flat cards (left-aligned, full-width). AI messages appear as plain text (no bubbles), ChatGPT/Claude style.
result: issue
reported: "right-align the message bubbles, but the text inside should still be left aligned"
severity: cosmetic

### 10. Composer Send/Stop Toggle
expected: Before sending, the composer shows a send button (arrow icon). During streaming, it changes to a stop button (square icon). After streaming completes, it returns to send.
result: pass

### 11. Composer Disabled During Streaming
expected: While the AI is responding, the text input should be disabled with a "Waiting for response..." placeholder hint.
result: pass

### 12. Stop/Cancel Streaming
expected: While the AI is responding, tap the stop button. Streaming should stop and any partial text received so far should be preserved in the message.
result: pass

### 13. Error Message Display
expected: If a request fails (e.g., network error, server error), a friendly inline error message should appear — no raw technical details exposed.
result: pass

### 14. Error Text Restoration
expected: After an error occurs, your original question text should be automatically restored in the composer input field, so you can retry without retyping.
result: issue
reported: "the composer was unlocked, but the text was not restored"
severity: major

## Summary

total: 14
passed: 10
issues: 4
pending: 0
skipped: 0

## Gaps

- truth: "After all steps complete and the text response finishes streaming, the step indicators should collapse into a single-line summary like 'Processed in N steps (X.Xs)'"
  status: failed
  reason: "User reported: they collappsed and disappeared"
  severity: major
  test: 6
  root_cause: "textMessageBuilder (_buildTextMessage) does not render step progress for completed AI messages, even though metadata is correctly passed"
  artifacts:
    - path: "lib/features/chat/presentation/screens/chat_screen.dart"
      issue: "_buildTextMessage (lines 143-147) only renders GptMarkdown for AI messages, ignoring metadata containing step summary data"
  missing:
    - "_buildTextMessage needs to call _buildStepProgress(message.metadata, theme) for AI messages (when !isSentByMe) before GptMarkdown, wrapped in a Column with CrossAxisAlignment.start"
  debug_session: ".planning/debug/step-summary-disappearing.md"

- truth: "The AI response text should appear token-by-token (typewriter effect) below the step progress indicators, not all at once"
  status: failed
  reason: "User reported: it does, but it doesnt feel fluid; it feels a bit choppy"
  severity: minor
  test: 7
  root_cause: "TypewriterBuffer emits 200 state updates/second (one per character at 5ms intervals), causing excessive widget rebuilds that exceed Flutter's 60fps frame budget"
  artifacts:
    - path: "lib/features/chat/application/typewriter_buffer.dart"
      issue: "Emits one character at a time via Timer.periodic at 5ms intervals (lines 71-90), causing 200+ state updates per second"
    - path: "lib/features/chat/application/chat_service.dart"
      issue: "Lines 280-304 - every character triggers onStateUpdate(), creating new ChatStreamState per character"
    - path: "lib/features/chat/presentation/providers/chat_ui_provider.dart"
      issue: "Lines 140-155 - _onStreamStateChanged calls _updateStreamMessage() for every state change, triggering UI rebuild per character"
  missing:
    - "Batch character emissions (emit 3-5 characters per tick instead of 1) or throttle state updates to ~30-60 updates/second max (16-33ms intervals)"
  debug_session: ""

- truth: "User messages appear in flat cards (left-aligned, full-width). AI messages appear as plain text (no bubbles), ChatGPT/Claude style"
  status: failed
  reason: "User reported: right-align the message bubbles, but the text inside should still be left aligned"
  severity: cosmetic
  test: 9
  root_cause: "The _buildChatMessage wrapper applies the same left-aligned layout to all messages; it does not use the isSentByMe parameter to right-align user messages"
  artifacts:
    - path: "lib/features/chat/presentation/screens/chat_screen.dart"
      issue: "Lines 109-115 - _buildChatMessage wraps child in Padding only, with no Align/Row widget to position user messages on the right based on isSentByMe"
  missing:
    - "Wrap child in Row or Align widget that uses isSentByMe to set alignment: when isSentByMe is true, use Alignment.centerRight to push user message card to right side"
  debug_session: ""

- truth: "After an error occurs, your original question text should be automatically restored in the composer input field, so you can retry without retyping"
  status: failed
  reason: "User reported: the composer was unlocked, but the text was not restored"
  severity: major
  test: 14
  root_cause: "Race condition - ChatScreen's ref.listen reads lastErrorQuery before ChatUiStateNotifier._handleError sets it"
  artifacts:
    - path: "lib/features/chat/presentation/screens/chat_screen.dart"
      issue: "ref.listen on chatStreamStateProvider reads lastErrorQuery at lines 57-63, but execution order vs ChatUiStateNotifier's listener is not guaranteed"
    - path: "lib/features/chat/presentation/providers/chat_ui_provider.dart"
      issue: "_handleError sets _lastErrorQuery at line 243, but this runs in a separate listener callback with no ordering guarantee"
  missing:
    - "Listen to chatUiStateProvider instead (which is the result of _handleError processing), or make lastErrorQuery part of notifier's exposed state so write-then-read sequence is guaranteed"
  debug_session: ".planning/debug/error-text-restoration.md"
