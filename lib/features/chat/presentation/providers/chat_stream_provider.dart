import 'package:logly/features/chat/application/chat_service.dart';
import 'package:logly/features/chat/domain/chat_exception.dart';
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_stream_provider.g.dart';

/// Riverpod notifier exposing [ChatStreamState] to the UI layer.
///
/// Holds the current chat stream state and exposes [sendQuestion] to
/// initiate a new chat request. Blocks concurrent requests while a
/// response is still streaming.
///
/// Preserves `responseId` and `conversionId` across requests for
/// follow-up question chaining. Call [resetConversation] to start
/// a fresh conversation.
@Riverpod(keepAlive: true)
class ChatStreamStateNotifier extends _$ChatStreamStateNotifier {
  late ChatService _service;

  /// Last response ID for follow-up chaining (persists across requests).
  String? _lastResponseId;

  /// Last conversion ID for follow-up chaining (persists across requests).
  String? _lastConversionId;

  @override
  ChatStreamState build() {
    _service = ref.watch(chatServiceProvider);
    ref.onDispose(() {
      _service.cancel();
    });
    return const ChatStreamState();
  }

  /// Sends a question through the chat pipeline.
  ///
  /// Blocks if a request is already in progress (status is connecting,
  /// streaming, or completing). Preserves conversation IDs for follow-up
  /// chaining after completion.
  Future<void> sendQuestion(String query) async {
    // Guard: block concurrent requests while streaming
    if (state.status != ChatConnectionStatus.idle &&
        state.status != ChatConnectionStatus.completed &&
        state.status != ChatConnectionStatus.error) {
      return;
    }

    // Reset display state for new request
    state = const ChatStreamState(status: ChatConnectionStatus.connecting);

    try {
      await _service.sendQuestion(
        query: query,
        onStateUpdate: (newState) {
          state = newState;
        },
        previousResponseId: _lastResponseId,
        previousConversionId: _lastConversionId,
      );

      // Capture IDs for next follow-up
      _lastResponseId = state.responseId;
      _lastConversionId = state.conversionId;
    } on Exception catch (e) {
      final errorMessage = e is ChatException ? e.message : 'An unexpected error occurred. Please try again.';
      state = ChatStreamState(
        status: ChatConnectionStatus.error,
        errorMessage: errorMessage,
        responseId: _lastResponseId,
        conversionId: _lastConversionId,
      );
    }
  }

  /// Cancels the in-progress stream and preserves partial text.
  ///
  /// Signals the service to stop processing events and emits a
  /// `completed` state with whatever text has been received so far.
  void cancelStream() {
    if (state.status != ChatConnectionStatus.streaming &&
        state.status != ChatConnectionStatus.connecting &&
        state.status != ChatConnectionStatus.completing) {
      return;
    }

    _service.cancel();
    state = ChatStreamState(
      status: ChatConnectionStatus.completed,
      displayText: state.displayText,
      fullText: state.fullText,
      completedSteps: state.completedSteps,
      responseId: state.responseId,
      conversionId: state.conversionId,
    );

    // Capture IDs for next follow-up
    _lastResponseId = state.responseId;
    _lastConversionId = state.conversionId;
  }

  /// Resets the conversation, clearing follow-up IDs and returning to idle.
  ///
  /// Use this when starting a fresh conversation (Phase 4).
  void resetConversation() {
    _lastResponseId = null;
    _lastConversionId = null;
    state = const ChatStreamState();
  }
}
