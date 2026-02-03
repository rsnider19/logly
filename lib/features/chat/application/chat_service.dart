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

/// Marker used by the backend to embed follow-up suggestions in response text.
/// Format: <!-- FOLLOW_UPS: ["...", "..."] -->
const _followUpMarkerStart = '<!-- FOLLOW_UPS:';
const _followUpMarkerEnd = '-->';

/// Strips the follow-up suggestions marker from response text.
///
/// The marker may span multiple lines and look like:
/// <!-- FOLLOW_UPS: ["Question 1?", "Question 2?"] -->
String _stripFollowUpMarker(String text) {
  final startIdx = text.indexOf(_followUpMarkerStart);
  if (startIdx == -1) return text;

  final endIdx = text.indexOf(_followUpMarkerEnd, startIdx);
  if (endIdx == -1) {
    // Marker started but not closed -- strip from start to end
    return text.substring(0, startIdx).trim();
  }

  // Remove the entire marker including closing -->
  return (text.substring(0, startIdx) + text.substring(endIdx + _followUpMarkerEnd.length)).trim();
}

/// Business logic layer orchestrating the chat stream lifecycle.
///
/// Transforms raw [ChatEvent] streams from [ChatRepository] into smooth,
/// typewriter-animated [ChatStreamState] updates via callbacks. Handles
/// stall detection (30s timeout), one silent auto-retry, and event routing.
///
/// The service is stateless for stream management -- it creates a new
/// [TypewriterBuffer] per request and returns results via the
/// `onStateUpdate` callback. The Riverpod notifier manages the
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

  /// Sends a question through the chat pipeline with stall detection,
  /// auto-retry, and typewriter buffering.
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
    final typewriter = TypewriterBuffer();

    try {
      var fullText = '';
      String? responseId;
      String? conversionId;
      String? conversationId = inputConversationId;
      var followUpSuggestions = <String>[];
      String? currentStepName;
      String? currentStepStatus;
      final completedSteps = <ChatCompletedStep>[];

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
        if (_cancelled) {
          _logger.i('Chat stream cancelled by user');
          onStateUpdate(
            ChatStreamState(
              status: ChatConnectionStatus.completed,
              displayText: typewriter.currentText,
              fullText: fullText,
              completedSteps: List.unmodifiable(completedSteps),
              responseId: responseId,
              conversionId: conversionId,
            ),
          );
          return;
        }

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
            // Step events are emitted instantly (no typewriter delay)
            onStateUpdate(
              ChatStreamState(
                status: ChatConnectionStatus.streaming,
                displayText: typewriter.currentText,
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
              typewriter.addDelta(delta);
              onStateUpdate(
                ChatStreamState(
                  status: ChatConnectionStatus.streaming,
                  displayText: typewriter.currentText,
                  fullText: fullText,
                  currentStepName: currentStepName,
                  currentStepStatus: currentStepStatus,
                  completedSteps: List.unmodifiable(completedSteps),
                  responseId: responseId,
                  conversionId: conversionId,
                ),
              );
            }

          case ChatResponseIdEvent():
            responseId = event.responseId;
            onStateUpdate(
              ChatStreamState(
                status: ChatConnectionStatus.streaming,
                displayText: typewriter.currentText,
                fullText: fullText,
                currentStepName: currentStepName,
                currentStepStatus: currentStepStatus,
                completedSteps: List.unmodifiable(completedSteps),
                responseId: responseId,
                conversionId: conversionId,
              ),
            );

          case ChatConversionIdEvent():
            conversionId = event.conversionId;
            onStateUpdate(
              ChatStreamState(
                status: ChatConnectionStatus.streaming,
                displayText: typewriter.currentText,
                fullText: fullText,
                currentStepName: currentStepName,
                currentStepStatus: currentStepStatus,
                completedSteps: List.unmodifiable(completedSteps),
                responseId: responseId,
                conversionId: conversionId,
              ),
            );

          case ChatErrorEvent(:final message):
            throw ChatConnectionException(message);

          case ChatDoneEvent(
              conversationId: final doneConversationId,
              followUpSuggestions: final doneSuggestions,
            ):
            conversationId = doneConversationId;
            followUpSuggestions = doneSuggestions;
            typewriter.markDone();
            onStateUpdate(
              ChatStreamState(
                status: ChatConnectionStatus.completing,
                displayText: typewriter.currentText,
                fullText: fullText,
                currentStepName: currentStepName,
                currentStepStatus: currentStepStatus,
                completedSteps: List.unmodifiable(completedSteps),
                responseId: responseId,
                conversionId: conversionId,
                conversationId: conversationId,
                followUpSuggestions: followUpSuggestions,
              ),
            );
        }
      }

      // After the SSE stream closes, listen to typewriter draining
      // and emit display text updates as characters drip out.
      await for (final displayText in typewriter.stream) {
        if (_cancelled) {
          onStateUpdate(
            ChatStreamState(
              status: ChatConnectionStatus.completed,
              displayText: typewriter.currentText,
              fullText: fullText,
              completedSteps: List.unmodifiable(completedSteps),
              responseId: responseId,
              conversionId: conversionId,
              conversationId: conversationId,
              followUpSuggestions: followUpSuggestions,
            ),
          );
          return;
        }
        onStateUpdate(
          ChatStreamState(
            status: ChatConnectionStatus.completing,
            displayText: displayText,
            fullText: fullText,
            completedSteps: List.unmodifiable(completedSteps),
            responseId: responseId,
            conversionId: conversionId,
            conversationId: conversationId,
            followUpSuggestions: followUpSuggestions,
          ),
        );
      }

      // Typewriter stream closed -- all characters drained
      // Strip follow-up marker from final text (may have accumulated if streamed in one delta)
      final cleanFullText = _stripFollowUpMarker(fullText);
      onStateUpdate(
        ChatStreamState(
          status: ChatConnectionStatus.completed,
          displayText: cleanFullText,
          fullText: cleanFullText,
          completedSteps: List.unmodifiable(completedSteps),
          responseId: responseId,
          conversionId: conversionId,
          conversationId: conversationId,
          followUpSuggestions: followUpSuggestions,
        ),
      );
    } finally {
      typewriter.dispose();
    }
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
