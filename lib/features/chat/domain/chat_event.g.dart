// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatStepEvent _$ChatStepEventFromJson(Map<String, dynamic> json) =>
    ChatStepEvent(
      name: json['name'] as String,
      status: json['status'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ChatStepEventToJson(ChatStepEvent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'type': instance.$type,
    };

ChatTextDeltaEvent _$ChatTextDeltaEventFromJson(Map<String, dynamic> json) =>
    ChatTextDeltaEvent(
      delta: json['delta'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ChatTextDeltaEventToJson(ChatTextDeltaEvent instance) =>
    <String, dynamic>{'delta': instance.delta, 'type': instance.$type};

ChatResponseIdEvent _$ChatResponseIdEventFromJson(Map<String, dynamic> json) =>
    ChatResponseIdEvent(
      responseId: json['responseId'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ChatResponseIdEventToJson(
  ChatResponseIdEvent instance,
) => <String, dynamic>{
  'responseId': instance.responseId,
  'type': instance.$type,
};

ChatConversionIdEvent _$ChatConversionIdEventFromJson(
  Map<String, dynamic> json,
) => ChatConversionIdEvent(
  conversionId: json['conversionId'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ChatConversionIdEventToJson(
  ChatConversionIdEvent instance,
) => <String, dynamic>{
  'conversionId': instance.conversionId,
  'type': instance.$type,
};

ChatErrorEvent _$ChatErrorEventFromJson(Map<String, dynamic> json) =>
    ChatErrorEvent(
      message: json['message'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ChatErrorEventToJson(ChatErrorEvent instance) =>
    <String, dynamic>{'message': instance.message, 'type': instance.$type};

ChatDoneEvent _$ChatDoneEventFromJson(Map<String, dynamic> json) =>
    ChatDoneEvent($type: json['type'] as String?);

Map<String, dynamic> _$ChatDoneEventToJson(ChatDoneEvent instance) =>
    <String, dynamic>{'type': instance.$type};
