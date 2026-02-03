---
status: diagnosed
trigger: "Collapsed Step Summary Disappearing - After all steps complete and the text response finishes streaming, the step indicators should collapse into a single-line summary like 'Processed in N steps (X.Xs)'. Instead, they collapse and completely disappear."
created: 2026-02-03T00:00:00Z
updated: 2026-02-03T00:00:00Z
---

## Current Focus

hypothesis: When stream completes, message is converted from TextStreamMessage to TextMessage, but textMessageBuilder does NOT render step progress
test: Verify textMessageBuilder does not call _buildStepProgress while textStreamMessageBuilder does
expecting: Confirm textMessageBuilder lacks step progress rendering
next_action: Verify the message type change on completion causes step summary to disappear

## Symptoms

expected: Step progress indicators collapse into a visible summary line showing step count and duration ("Processed in N steps (X.Xs)")
actual: Steps collapse and disappear entirely - no summary line is visible
errors: None reported
reproduction: Complete a multi-step operation, wait for text response to finish streaming, observe steps collapse
started: Unknown

## Eliminated

## Evidence

- timestamp: 2026-02-03T00:01:00Z
  checked: chat_screen.dart _buildTextStreamMessage (line 154-183)
  found: TextStreamMessage builder DOES render _buildStepProgress(message.metadata, theme) - this is correct
  implication: Steps show correctly during streaming

- timestamp: 2026-02-03T00:02:00Z
  checked: chat_screen.dart _buildTextMessage (line 122-148)
  found: TextMessage builder does NOT call _buildStepProgress at all - only renders Card (user) or GptMarkdown (AI)
  implication: When message converts to TextMessage, step progress is lost

- timestamp: 2026-02-03T00:03:00Z
  checked: chat_ui_provider.dart _finalizeMessage (line 185-212)
  found: On ChatConnectionStatus.completed, replaces TextStreamMessage with TextMessage via Message.text() constructor
  implication: The message type changes from TextStreamMessage to TextMessage, triggering different builder

- timestamp: 2026-02-03T00:04:00Z
  checked: chat_ui_provider.dart _finalizeMessage metadata (line 197-203)
  found: Metadata IS passed to the new TextMessage with stepsCollapsed=true, steps list, stepCount, stepDurationMs
  implication: Data exists but textMessageBuilder ignores it

## Resolution

root_cause: When streaming completes, _finalizeMessage converts TextStreamMessage to TextMessage. The textMessageBuilder (for AI messages) only renders GptMarkdown and does not call _buildStepProgress, even though metadata with stepsCollapsed=true is correctly passed.
fix: Modify _buildTextMessage to call _buildStepProgress for AI messages (when !isSentByMe) before rendering GptMarkdown, similar to how _buildTextStreamMessage does it.
verification:
files_changed: []
