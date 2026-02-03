import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_conversation.freezed.dart';
part 'chat_conversation.g.dart';

/// Domain model for a chat conversation.
///
/// Maps to Supabase `chat_conversations` table.
/// Stores follow-up IDs for multi-turn conversation context.
@freezed
abstract class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    String? title,
    @JsonKey(name: 'last_response_id') String? lastResponseId,
    @JsonKey(name: 'last_conversion_id') String? lastConversionId,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);
}
