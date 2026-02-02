import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';
part 'chat_event.g.dart';

/// Domain events parsed from the chat SSE stream.
///
/// Maps 1:1 to the server's SSE event protocol defined in streamHandler.ts.
/// Uses `unionKey` so Freezed deserializes based on the JSON `type` field.
@Freezed(unionKey: 'type')
sealed class ChatEvent with _$ChatEvent {
  const ChatEvent._();

  /// Pipeline step progress (start/complete pairs).
  @FreezedUnionValue('step')
  const factory ChatEvent.step({
    required String name,
    required String status,
  }) = ChatStepEvent;

  /// Streaming text delta (token-by-token from the response).
  @FreezedUnionValue('text_delta')
  const factory ChatEvent.textDelta({
    required String delta,
  }) = ChatTextDeltaEvent;

  /// Response ID for follow-up chaining.
  @FreezedUnionValue('response_id')
  const factory ChatEvent.responseId({
    @JsonKey(name: 'responseId') required String responseId,
  }) = ChatResponseIdEvent;

  /// Conversion ID for SQL agent follow-up context.
  @FreezedUnionValue('conversion_id')
  const factory ChatEvent.conversionId({
    @JsonKey(name: 'conversionId') required String conversionId,
  }) = ChatConversionIdEvent;

  /// Error (user-friendly message).
  @FreezedUnionValue('error')
  const factory ChatEvent.error({
    required String message,
  }) = ChatErrorEvent;

  /// Stream completion signal.
  @FreezedUnionValue('done')
  const factory ChatEvent.done() = ChatDoneEvent;

  factory ChatEvent.fromJson(Map<String, dynamic> json) => _$ChatEventFromJson(json);
}
