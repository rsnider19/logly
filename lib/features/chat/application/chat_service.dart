import 'dart:async';

import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/chat/application/typewriter_buffer.dart';
import 'package:logly/features/chat/data/chat_repository.dart';
import 'package:logly/features/chat/domain/chat_event.dart';
import 'package:logly/features/chat/domain/chat_exception.dart';
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_service.g.dart';

/// Business logic layer orchestrating the chat stream lifecycle.
///
/// Transforms raw [ChatEvent] streams from [ChatRepository] into
/// [ChatStreamState] updates via callbacks. Handles stall detection
/// (30s timeout), one silent auto-retry, and event routing.
///
/// The service is stateless for stream management -- it returns results
/// via the `onStateUpdate` callback. The Riverpod notifier manages the
/// stateful lifecycle.
class ChatService {
  ChatService(this._repository, this._logger);

  final ChatRepository _repository;
  final LoggerService _logger;

  /// Whether the current stream has been cancelled by the user.
  bool _cancelled = false;

  /// Signals cancellation of the current stream.
  ///
  /// The running `_executeStream` will detect this flag on the next
  /// iteration and emit a `completed` state with partial text preserved.
  void cancel() {
    _cancelled = true;
  }

  /// Sends a question through the chat pipeline with stall detection
  /// and auto-retry.
  ///
  /// [onStateUpdate] is called for each state change, allowing the
  /// caller (typically a Riverpod notifier) to control state emission.
  ///
  /// [conversationId] is passed for multi-turn conversations (backend uses
  /// to continue existing conversation rather than create new one).
  ///
  /// Retries once silently on failure. If retry also fails, emits
  /// an error state with a user-friendly message.
  Future<void> sendQuestion({
    required String query,
    required void Function(ChatStreamState) onStateUpdate,
    String? previousResponseId,
    String? previousConversionId,
    String? conversationId,
  }) async {
    _cancelled = false;
    onStateUpdate(
      const ChatStreamState(status: ChatConnectionStatus.connecting),
    );

    try {
      await _executeStream(
        query,
        previousResponseId,
        previousConversionId,
        conversationId,
        onStateUpdate,
        isRetry: false,
      );
    } on ChatException catch (e) {
      _logger.w('Chat stream failed, attempting retry', e);
      try {
        onStateUpdate(
          const ChatStreamState(
            status: ChatConnectionStatus.connecting,
            isRetrying: true,
          ),
        );
        await _executeStream(
          query,
          previousResponseId,
          previousConversionId,
          conversationId,
          onStateUpdate,
          isRetry: true,
        );
      } on ChatException catch (retryError) {
        _logger.e('Chat stream retry also failed', retryError);
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.error,
            errorMessage: retryError.message,
          ),
        );
      } catch (retryError, st) {
        _logger.e('Chat stream retry failed with unexpected error', retryError, st);
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.error,
            errorMessage: const ChatConnectionException().message,
          ),
        );
      }
    } catch (e, st) {
      _logger.w('Chat stream failed with unexpected error, attempting retry', e, st);
      try {
        onStateUpdate(
          const ChatStreamState(
            status: ChatConnectionStatus.connecting,
            isRetrying: true,
          ),
        );
        await _executeStream(
          query,
          previousResponseId,
          previousConversionId,
          conversationId,
          onStateUpdate,
          isRetry: true,
        );
      } on ChatException catch (retryError) {
        _logger.e('Chat stream retry also failed', retryError);
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.error,
            errorMessage: retryError.message,
          ),
        );
      } catch (retryError, st) {
        _logger.e('Chat stream retry failed with unexpected error', retryError, st);
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.error,
            errorMessage: const ChatConnectionException().message,
          ),
        );
      }
    }
  }

  Future<void> _executeStream(
    String query,
    String? previousResponseId,
    String? previousConversionId,
    String? inputConversationId,
    void Function(ChatStreamState) onStateUpdate, {
    required bool isRetry,
  }) async {
    var fullText = '';
    String? responseId;
    String? conversionId;
    String? conversationId = inputConversationId;
    var followUpSuggestions = <String>[];
    String? currentStepName;
    String? currentStepStatus;
    final completedSteps = <ChatCompletedStep>[];

    // Typewriter buffer: drips characters at 5ms/char during streaming,
    // then 1ms/char once done. displayText trails fullText until drained.
    final buffer = TypewriterBuffer();
    final bufferDone = Completer<void>();

    // Buffer drip listener — emits display-text updates at typewriter pace.
    final bufferSub = buffer.stream.listen(
      (displayText) {
        if (_cancelled) return;
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.streaming,
            displayText: displayText,
            fullText: fullText,
            currentStepName: currentStepName,
            currentStepStatus: currentStepStatus,
            completedSteps: List.unmodifiable(completedSteps),
            responseId: responseId,
            conversionId: conversionId,
          ),
        );
      },
      onDone: () {
        if (!bufferDone.isCompleted) bufferDone.complete();
      },
    );

    try {
      final eventStream = _repository
          .sendQuestion(
            query: query,
            previousResponseId: previousResponseId,
            previousConversionId: previousConversionId,
            conversationId: inputConversationId,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: (sink) {
              sink
                ..addError(const ChatStallException())
                ..close();
            },
          );

      await for (final event in eventStream) {
        // Check for user-initiated cancellation
        if (_cancelled) return;

        switch (event) {
          case ChatStepEvent():
            if (event.status == 'complete') {
              completedSteps.add(ChatCompletedStep(name: event.name));
              currentStepName = null;
              currentStepStatus = null;
            } else {
              currentStepName = event.name;
              currentStepStatus = event.status;
            }
            // Emit step update with current dripped text (not full text).
            onStateUpdate(
              ChatStreamState(
                status: ChatConnectionStatus.streaming,
                displayText: buffer.currentText,
                fullText: fullText,
                currentStepName: currentStepName,
                currentStepStatus: currentStepStatus,
                completedSteps: List.unmodifiable(completedSteps),
                responseId: responseId,
                conversionId: conversionId,
              ),
            );

          case ChatTextDeltaEvent(:final delta):
            if (delta.isNotEmpty) {
              fullText += delta;
              buffer.addDelta(delta);
              // Display updates come from the buffer.stream listener above.
            }

          case ChatResponseIdEvent():
            responseId = event.responseId;

          case ChatConversionIdEvent():
            conversionId = event.conversionId;

          case ChatErrorEvent(:final message):
            throw ChatConnectionException(message);

          case ChatDoneEvent(conversationId: final doneConversationId):
            conversationId = doneConversationId;
            // No more text deltas — switch buffer to fast drain (1ms/char).
            // Don't emit completing yet; wait for buffer to fully drain.
            buffer.markDone();

          case ChatFollowUpSuggestionsEvent(:final suggestions):
            followUpSuggestions = suggestions;
        }
      }

      // All SSE events processed. Ensure buffer is marked done (idempotent)
      // and wait for it to finish draining remaining characters.
      buffer.markDone();
      if (!buffer.isComplete) {
        await bufferDone.future;
      }
    } finally {
      await bufferSub.cancel();
      buffer.dispose();
    }

    // If cancelled during drain, exit without overwriting state.
    if (_cancelled) return;

    // Buffer fully drained + all events received → emit completed.
    // Suggestions are included so the UI can show them immediately
    // without a separate completing → completed transition.
    onStateUpdate(
      ChatStreamState(
        status: ChatConnectionStatus.completed,
        displayText: fullText,
        fullText: fullText,
        completedSteps: List.unmodifiable(completedSteps),
        responseId: responseId,
        conversionId: conversionId,
        conversationId: conversationId,
        followUpSuggestions: followUpSuggestions,
      ),
    );
  }
}

/// Provides the [ChatService] instance.
@Riverpod(keepAlive: true)
ChatService chatService(Ref ref) {
  return ChatService(
    ref.watch(chatRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
