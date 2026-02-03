import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

/// Role of a chat message sender.
enum ChatMessageRole {
  user,
  assistant,
  system,
}

/// Metadata for an assistant message.
///
/// Contains follow-up suggestions and step information.
@freezed
abstract class ChatMessageMetadata with _$ChatMessageMetadata {
  const factory ChatMessageMetadata({
    @JsonKey(name: 'follow_up_suggestions') List<String>? followUpSuggestions,
    List<String>? steps,
  }) = _ChatMessageMetadata;

  factory ChatMessageMetadata.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageMetadataFromJson(json);
}

/// Domain model for a persisted chat message.
///
/// Maps to Supabase `chat_messages` table.
/// Metadata stores follow-up suggestions for assistant messages.
@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(name: 'message_id') required String messageId,
    @JsonKey(name: 'conversation_id') required String conversationId,
    required ChatMessageRole role,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    ChatMessageMetadata? metadata,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
