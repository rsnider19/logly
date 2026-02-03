// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConversation _$ChatConversationFromJson(Map<String, dynamic> json) =>
    _ChatConversation(
      conversationId: json['conversation_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      title: json['title'] as String?,
      lastResponseId: json['last_response_id'] as String?,
      lastConversionId: json['last_conversion_id'] as String?,
    );

Map<String, dynamic> _$ChatConversationToJson(_ChatConversation instance) =>
    <String, dynamic>{
      'conversation_id': instance.conversationId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'title': instance.title,
      'last_response_id': instance.lastResponseId,
      'last_conversion_id': instance.lastConversionId,
    };
