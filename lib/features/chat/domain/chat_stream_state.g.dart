// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_stream_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatCompletedStep _$ChatCompletedStepFromJson(Map<String, dynamic> json) =>
    _ChatCompletedStep(name: json['name'] as String);

Map<String, dynamic> _$ChatCompletedStepToJson(_ChatCompletedStep instance) =>
    <String, dynamic>{'name': instance.name};

_ChatStreamState _$ChatStreamStateFromJson(Map<String, dynamic> json) =>
    _ChatStreamState(
      status:
          $enumDecodeNullable(_$ChatConnectionStatusEnumMap, json['status']) ??
          ChatConnectionStatus.idle,
      displayText: json['display_text'] as String? ?? '',
      fullText: json['full_text'] as String? ?? '',
      currentStepName: json['current_step_name'] as String?,
      currentStepStatus: json['current_step_status'] as String?,
      completedSteps:
          (json['completed_steps'] as List<dynamic>?)
              ?.map(
                (e) => ChatCompletedStep.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      responseId: json['response_id'] as String?,
      conversionId: json['conversion_id'] as String?,
      conversationId: json['conversation_id'] as String?,
      followUpSuggestions:
          (json['follow_up_suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      errorMessage: json['error_message'] as String?,
      isRetrying: json['is_retrying'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatStreamStateToJson(
  _ChatStreamState instance,
) => <String, dynamic>{
  'status': _$ChatConnectionStatusEnumMap[instance.status]!,
  'display_text': instance.displayText,
  'full_text': instance.fullText,
  'current_step_name': instance.currentStepName,
  'current_step_status': instance.currentStepStatus,
  'completed_steps': instance.completedSteps.map((e) => e.toJson()).toList(),
  'response_id': instance.responseId,
  'conversion_id': instance.conversionId,
  'conversation_id': instance.conversationId,
  'follow_up_suggestions': instance.followUpSuggestions,
  'error_message': instance.errorMessage,
  'is_retrying': instance.isRetrying,
};

const _$ChatConnectionStatusEnumMap = {
  ChatConnectionStatus.idle: 'idle',
  ChatConnectionStatus.connecting: 'connecting',
  ChatConnectionStatus.streaming: 'streaming',
  ChatConnectionStatus.completing: 'completing',
  ChatConnectionStatus.completed: 'completed',
  ChatConnectionStatus.error: 'error',
};
