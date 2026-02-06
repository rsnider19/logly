// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_parse_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoiceParseResult _$VoiceParseResultFromJson(Map<String, dynamic> json) =>
    _VoiceParseResult(
      rawTranscript: json['raw_transcript'] as String,
      activityQuery: json['activity_query'] as String,
      durationSeconds: (json['duration_seconds'] as num?)?.toInt(),
      distanceMeters: (json['distance_meters'] as num?)?.toDouble(),
      activityDate: json['activity_date'] == null
          ? null
          : DateTime.parse(json['activity_date'] as String),
      comments: json['comments'] as String?,
    );

Map<String, dynamic> _$VoiceParseResultToJson(_VoiceParseResult instance) =>
    <String, dynamic>{
      'raw_transcript': instance.rawTranscript,
      'activity_query': instance.activityQuery,
      'duration_seconds': instance.durationSeconds,
      'distance_meters': instance.distanceMeters,
      'activity_date': instance.activityDate?.toIso8601String(),
      'comments': instance.comments,
    };
