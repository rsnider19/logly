import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_stream_state.freezed.dart';
part 'chat_stream_state.g.dart';

/// Connection status for the chat stream lifecycle.
enum ChatConnectionStatus {
  /// No active stream.
  idle,

  /// Request sent, waiting for first event.
  connecting,

  /// Receiving events from the server.
  streaming,

  /// Done event received, typewriter buffer draining remaining text.
  completing,

  /// All text emitted, stream finished successfully.
  completed,

  /// Error state.
  error,
}

/// A completed pipeline step for display in step history.
@freezed
abstract class ChatCompletedStep with _$ChatCompletedStep {
  const factory ChatCompletedStep({
    required String name,
  }) = _ChatCompletedStep;

  factory ChatCompletedStep.fromJson(Map<String, dynamic> json) => _$ChatCompletedStepFromJson(json);
}

/// State model for the chat stream lifecycle.
///
/// Tracks connection status, typewriter text, pipeline steps,
/// follow-up IDs, and error information.
@freezed
abstract class ChatStreamState with _$ChatStreamState {
  const factory ChatStreamState({
    /// Current connection/stream status.
    @Default(ChatConnectionStatus.idle) ChatConnectionStatus status,

    /// Typewriter-dripped text for UI display (characters appear progressively).
    @Default('') String displayText,

    /// Complete accumulated text for copy/accessibility (all deltas concatenated).
    @Default('') String fullText,

    /// Active step label (null when no step is in progress).
    String? currentStepName,

    /// Active step status ("start" or "complete").
    String? currentStepStatus,

    /// History of completed pipeline steps.
    @Default([]) List<ChatCompletedStep> completedSteps,

    /// Response ID for follow-up question chaining.
    String? responseId,

    /// Conversion ID for SQL context chaining.
    String? conversionId,

    /// The conversation ID (set by backend on first message, persists across requests).
    String? conversationId,

    /// Follow-up question suggestions (populated from done event).
    @Default([]) List<String> followUpSuggestions,

    /// User-friendly error message.
    String? errorMessage,

    /// Whether a silent auto-retry is in progress.
    @Default(false) bool isRetrying,
  }) = _ChatStreamState;

  factory ChatStreamState.fromJson(Map<String, dynamic> json) => _$ChatStreamStateFromJson(json);
}
