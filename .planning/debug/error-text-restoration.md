---
status: diagnosed
trigger: "Error text restoration not working - composer unlocks after error but text not restored"
created: 2026-02-03T00:00:00Z
updated: 2026-02-03T00:00:00Z
symptoms_prefilled: true
goal: find_root_cause_only
---

## Current Focus

hypothesis: There is a race condition - ChatUiStateNotifier.ref.listen fires BEFORE ChatScreen's ref.listen
test: Analyze the order of listener execution
expecting: Find that _handleError sets _lastErrorQuery AFTER ChatScreen's listener reads it
next_action: Analyze timing of the two listeners

## Symptoms

expected: When chat request fails, the failed query text is auto-populated back into composer
actual: Composer unlocks after error, but input field remains empty
errors: None observed
reproduction: Trigger a chat error, observe composer remains empty
started: After recent error text restoration implementation

## Eliminated

## Evidence

- timestamp: 2026-02-03T00:01:00Z
  checked: chat_screen.dart lines 54-65 - ref.listen implementation
  found: |
    ref.listen(chatStreamStateProvider, (prev, next) {
      if (next.status == ChatConnectionStatus.error && prev?.status != ChatConnectionStatus.error) {
        final errorQuery = ref.read(chatUiStateProvider.notifier).lastErrorQuery;
        if (errorQuery != null) {
          _textController.text = errorQuery;
          _textController.selection = TextSelection.fromPosition(...);
        }
      }
    });
  implication: ChatScreen listens to chatStreamStateProvider and tries to read lastErrorQuery when error detected

- timestamp: 2026-02-03T00:02:00Z
  checked: chat_ui_provider.dart lines 60-62 and 215-249 - ChatUiStateNotifier's listener
  found: |
    ChatUiStateNotifier ALSO has ref.listen(chatStreamStateProvider, _onStreamStateChanged)
    In _handleError (line 243): _lastErrorQuery = _pendingUserQuery is set INSIDE _handleError
    _handleError is called when status == ChatConnectionStatus.error
  implication: TWO listeners exist for the same provider state change

- timestamp: 2026-02-03T00:03:00Z
  checked: Listener execution order analysis
  found: |
    When chatStreamStateProvider emits error status:
    1. ChatUiStateNotifier.ref.listen fires _onStreamStateChanged -> _handleError
    2. ChatScreen.ref.listen fires and reads lastErrorQuery
    BUT - Riverpod listener order is NOT guaranteed!
    If ChatScreen's listener fires FIRST, _lastErrorQuery is still null because
    _handleError hasn't run yet to set it.
  implication: Race condition between two listeners - ChatScreen reads before ChatUiStateNotifier writes

## Resolution

root_cause: Race condition - Two ref.listen callbacks on chatStreamStateProvider execute in undefined order. ChatScreen reads lastErrorQuery before ChatUiStateNotifier._handleError sets it.
fix:
verification:
files_changed: []
