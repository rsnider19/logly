// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageMetadata _$ChatMessageMetadataFromJson(Map<String, dynamic> json) =>
    _ChatMessageMetadata(
      followUpSuggestions: (json['follow_up_suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ChatMessageMetadataToJson(
  _ChatMessageMetadata instance,
) => <String, dynamic>{
  'follow_up_suggestions': instance.followUpSuggestions,
  'steps': instance.steps,
};

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  messageId: json['message_id'] as String,
  conversationId: json['conversation_id'] as String,
  role: $enumDecode(_$ChatMessageRoleEnumMap, json['role']),
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  metadata: json['metadata'] == null
      ? null
      : ChatMessageMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'conversation_id': instance.conversationId,
      'role': _$ChatMessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'metadata': instance.metadata?.toJson(),
    };

const _$ChatMessageRoleEnumMap = {
  ChatMessageRole.user: 'user',
  ChatMessageRole.assistant: 'assistant',
  ChatMessageRole.system: 'system',
};
