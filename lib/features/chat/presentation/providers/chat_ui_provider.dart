import 'dart:async';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:logly/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_ui_provider.g.dart';

/// User ID for the LoglyAI assistant in chat messages.
const kLoglyAiUserId = 'logly-ai';

/// System author ID for error/system messages.
const kSystemUserId = 'system';

const _uuid = Uuid();

/// Bridge provider that translates [ChatStreamState] emissions from the
/// stream layer into [InMemoryChatController] operations (insert, update,
/// remove) that the `flutter_chat_ui` Chat widget observes.
///
/// This is the central orchestration point between the SSE stream and
/// the chat UI. It maps each state transition (connecting, streaming,
/// completing, completed, error) into the corresponding controller
/// mutation.
@Riverpod(keepAlive: true)
class ChatUiStateNotifier extends _$ChatUiStateNotifier {
  late InMemoryChatController _controller;

  /// The current user's ID (from Supabase auth).
  late String _currentUserId;

  /// ID of the current AI message being streamed into the controller.
  String? _currentAiMessageId;

  /// The user's question text, kept for error restoration.
  String? _pendingUserQuery;

  /// ID of the user message, kept for error removal.
  String? _pendingUserMessageId;

  /// When the first step event arrived (for step duration calculation).
  DateTime? _stepStartTime;

  /// Whether steps have been collapsed into a summary line.
  bool _stepsCollapsed = false;

  /// Last failed query text for input field restoration.
  String? _lastErrorQuery;

  @override
  InMemoryChatController build() {
    final userId = ref.watch(currentUserProvider)?.id;
    _currentUserId = userId ?? 'anonymous';

    _controller = InMemoryChatController();

    ref
      ..listen(chatStreamStateProvider, _onStreamStateChanged)
      ..onDispose(() => _controller.dispose());

    return _controller;
  }

  /// The last query that failed, for restoring to the input field.
  String? get lastErrorQuery => _lastErrorQuery;

  /// Clears the stored error query after it has been restored to input.
  void clearLastErrorQuery() => _lastErrorQuery = null;

  /// Sends a user message and initiates the AI stream.
  ///
  /// Inserts the user message and a streaming AI placeholder into the
  /// controller, then triggers the stream via the notifier.
  Future<void> sendMessage(String query) async {
    final userMsgId = _uuid.v4();
    final aiMsgId = _uuid.v4();

    // Insert user message
    await _controller.insertMessage(
      Message.text(
        id: userMsgId,
        authorId: _currentUserId,
        text: query,
        createdAt: DateTime.now(),
      ),
    );

    _pendingUserQuery = query;
    _pendingUserMessageId = userMsgId;
    _currentAiMessageId = aiMsgId;
    _stepStartTime = null;
    _stepsCollapsed = false;

    // Insert AI streaming placeholder
    await _controller.insertMessage(
      Message.textStream(
        id: aiMsgId,
        authorId: kLoglyAiUserId,
        streamId: _uuid.v4(),
        createdAt: DateTime.now(),
      ),
    );

    // Trigger the stream (fire-and-forget; state updates arrive via listener)
    unawaited(ref.read(chatStreamStateProvider.notifier).sendQuestion(query));
  }

  /// Resets the conversation, clearing all messages and stream state.
  Future<void> clearMessages() async {
    await _controller.setMessages([]);
    _currentAiMessageId = null;
    _pendingUserQuery = null;
    _pendingUserMessageId = null;
    _stepStartTime = null;
    _stepsCollapsed = false;
    _lastErrorQuery = null;
    ref.read(chatStreamStateProvider.notifier).resetConversation();
  }

  /// Handles stream state transitions and maps them to controller operations.
  Future<void> _onStreamStateChanged(
    ChatStreamState? previous,
    ChatStreamState next,
  ) async {
    if (_currentAiMessageId == null) return;

    switch (next.status) {
      case ChatConnectionStatus.idle:
        // Nothing to do on idle
        break;

      case ChatConnectionStatus.connecting:
        // Connecting -- the TextStreamMessage placeholder is already inserted.
        // Update metadata to indicate connecting state.
        await _updateStreamMessage(next);

      case ChatConnectionStatus.streaming:
        // Track step start time on first step event
        if (next.currentStepName != null && _stepStartTime == null) {
          _stepStartTime = DateTime.now();
        }

        // Detect steps collapse: steps finished, text is flowing, not yet collapsed
        if (next.completedSteps.isNotEmpty &&
            next.currentStepName == null &&
            next.displayText.isNotEmpty &&
            !_stepsCollapsed) {
          _stepsCollapsed = true;
        }

        await _updateStreamMessage(next);

      case ChatConnectionStatus.completing:
        // Text is done — finalize stream message to TextMessage.
        // Keep _currentAiMessageId so we can update suggestions later.
        await _finalizeMessage(next, clearTracking: false);

      case ChatConnectionStatus.completed:
        if (_currentAiMessageId != null) {
          final msg = _findMessageById(_currentAiMessageId!);
          if (msg is TextStreamMessage) {
            // Buffer-based flow: finalize directly from streaming → completed.
            // Suggestions are already in the state so they're included in
            // the finalized TextMessage metadata.
            await _finalizeMessage(next);
          } else {
            // Two-phase flow (completing → completed): already finalized,
            // just add suggestions.
            await _addSuggestionsToFinalizedMessage(next);
          }
        }

      case ChatConnectionStatus.error:
        await _handleError(next);
    }
  }

  /// Updates the existing TextStreamMessage with current metadata.
  Future<void> _updateStreamMessage(ChatStreamState streamState) async {
    final aiMsgId = _currentAiMessageId;
    if (aiMsgId == null) return;

    final oldMsg = _findMessageById(aiMsgId);
    if (oldMsg == null || oldMsg is! TextStreamMessage) return;

    final newMsg = Message.textStream(
      id: oldMsg.id,
      authorId: oldMsg.authorId,
      streamId: oldMsg.streamId,
      createdAt: oldMsg.createdAt,
      metadata: _buildStreamMetadata(streamState),
    );

    await _controller.updateMessage(oldMsg, newMsg);
  }

  /// Replaces the TextStreamMessage with a final TextMessage on completion.
  ///
  /// When [clearTracking] is false, keeps `_currentAiMessageId` so the
  /// message can be updated with follow-up suggestions later.
  Future<void> _finalizeMessage(
    ChatStreamState streamState, {
    bool clearTracking = true,
  }) async {
    final aiMsgId = _currentAiMessageId;
    if (aiMsgId == null) return;

    final oldMsg = _findMessageById(aiMsgId);
    if (oldMsg == null) return;

    final newMsg = Message.text(
      id: aiMsgId,
      authorId: kLoglyAiUserId,
      text: streamState.fullText,
      createdAt: oldMsg.createdAt,
      metadata: {
        'steps': streamState.completedSteps.map((s) => s.name).toList(),
        'stepsCollapsed': true,
        'stepCount': streamState.completedSteps.length,
        if (_stepStartTime != null)
          'stepDurationMs': DateTime.now().difference(_stepStartTime!).inMilliseconds,
        if (streamState.followUpSuggestions.isNotEmpty)
          'followUpSuggestions': streamState.followUpSuggestions,
      },
    );

    await _controller.updateMessage(oldMsg, newMsg);

    if (clearTracking) {
      _currentAiMessageId = null;
      _pendingUserQuery = null;
      _pendingUserMessageId = null;
    }
  }

  /// Updates the already-finalized TextMessage with follow-up suggestions.
  Future<void> _addSuggestionsToFinalizedMessage(ChatStreamState streamState) async {
    final aiMsgId = _currentAiMessageId;
    if (aiMsgId == null) return;

    final oldMsg = _findMessageById(aiMsgId);
    if (oldMsg == null || oldMsg is! TextMessage) return;

    if (streamState.followUpSuggestions.isNotEmpty) {
      final newMetadata = Map<String, dynamic>.from(oldMsg.metadata ?? {});
      newMetadata['followUpSuggestions'] = streamState.followUpSuggestions;

      final newMsg = Message.text(
        id: oldMsg.id,
        authorId: oldMsg.authorId,
        text: oldMsg.text,
        createdAt: oldMsg.createdAt,
        metadata: newMetadata,
      );

      await _controller.updateMessage(oldMsg, newMsg);
    }

    // Clear tracking state
    _currentAiMessageId = null;
    _pendingUserQuery = null;
    _pendingUserMessageId = null;
  }

  /// Handles error state: removes user/AI messages and inserts system error.
  Future<void> _handleError(ChatStreamState streamState) async {
    // Remove the AI placeholder message
    if (_currentAiMessageId != null) {
      final aiMsg = _findMessageById(_currentAiMessageId!);
      if (aiMsg != null) {
        await _controller.removeMessage(aiMsg);
      }
    }

    // Remove the user message
    if (_pendingUserMessageId != null) {
      final userMsg = _findMessageById(_pendingUserMessageId!);
      if (userMsg != null) {
        await _controller.removeMessage(userMsg);
      }
    }

    // Insert system error message
    await _controller.insertMessage(
      Message.system(
        id: _uuid.v4(),
        authorId: kSystemUserId,
        text: streamState.errorMessage ?? 'Something went wrong. Please try again.',
        createdAt: DateTime.now(),
      ),
    );

    // Store query for input restoration
    _lastErrorQuery = _pendingUserQuery;

    // Clear tracking state
    _currentAiMessageId = null;
    _pendingUserQuery = null;
    _pendingUserMessageId = null;
  }

  /// Builds the metadata map for a streaming TextStreamMessage.
  Map<String, dynamic> _buildStreamMetadata(ChatStreamState streamState) {
    return {
      'steps': streamState.completedSteps.map((s) => s.name).toList(),
      'currentStepName': streamState.currentStepName,
      'currentStepStatus': streamState.currentStepStatus,
      'displayText': streamState.displayText,
      'streamStatus': streamState.status.name,
      'stepsCollapsed': _stepsCollapsed,
      if (_stepStartTime != null)
        'stepDurationMs': DateTime.now().difference(_stepStartTime!).inMilliseconds,
    };
  }

  /// Finds a message in the controller by ID, or null if not found.
  Message? _findMessageById(String id) {
    final messages = _controller.messages;
    for (final msg in messages) {
      if (msg.id == id) return msg;
    }
    return null;
  }
}
