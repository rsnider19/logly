// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_parse_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoiceParseResponse _$VoiceParseResponseFromJson(Map<String, dynamic> json) =>
    _VoiceParseResponse(
      parsed: VoiceParsedData.fromJson(json['parsed'] as Map<String, dynamic>),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VoiceParseResponseToJson(_VoiceParseResponse instance) =>
    <String, dynamic>{
      'parsed': instance.parsed.toJson(),
      'activities': instance.activities.map((e) => e.toJson()).toList(),
    };

_VoiceParsedData _$VoiceParsedDataFromJson(Map<String, dynamic> json) =>
    _VoiceParsedData(
      activityQuery: json['activity_query'] as String,
      duration: json['duration'] == null
          ? null
          : VoiceDuration.fromJson(json['duration'] as Map<String, dynamic>),
      distance: json['distance'] == null
          ? null
          : VoiceDistance.fromJson(json['distance'] as Map<String, dynamic>),
      date: json['date'] == null
          ? null
          : VoiceDate.fromJson(json['date'] as Map<String, dynamic>),
      comments: json['comments'] as String?,
    );

Map<String, dynamic> _$VoiceParsedDataToJson(_VoiceParsedData instance) =>
    <String, dynamic>{
      'activity_query': instance.activityQuery,
      'duration': instance.duration?.toJson(),
      'distance': instance.distance?.toJson(),
      'date': instance.date?.toJson(),
      'comments': instance.comments,
    };

_VoiceDuration _$VoiceDurationFromJson(Map<String, dynamic> json) =>
    _VoiceDuration(seconds: (json['seconds'] as num).toInt());

Map<String, dynamic> _$VoiceDurationToJson(_VoiceDuration instance) =>
    <String, dynamic>{'seconds': instance.seconds};

_VoiceDistance _$VoiceDistanceFromJson(Map<String, dynamic> json) =>
    _VoiceDistance(
      meters: (json['meters'] as num).toDouble(),
      originalValue: (json['original_value'] as num).toDouble(),
      originalUnit: json['original_unit'] as String,
    );

Map<String, dynamic> _$VoiceDistanceToJson(_VoiceDistance instance) =>
    <String, dynamic>{
      'meters': instance.meters,
      'original_value': instance.originalValue,
      'original_unit': instance.originalUnit,
    };

_VoiceDate _$VoiceDateFromJson(Map<String, dynamic> json) => _VoiceDate(
  iso: json['iso'] as String,
  relative: json['relative'] as String?,
);

Map<String, dynamic> _$VoiceDateToJson(_VoiceDate instance) =>
    <String, dynamic>{'iso': instance.iso, 'relative': instance.relative};
