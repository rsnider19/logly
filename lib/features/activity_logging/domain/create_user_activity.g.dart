// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateUserActivity _$CreateUserActivityFromJson(Map<String, dynamic> json) =>
    _CreateUserActivity(
      activityId: json['activity_id'] as String,
      activityTimestamp: DateTime.parse(json['activity_timestamp'] as String),
      activityDate: DateTime.parse(json['activity_date'] as String),
      comments: json['comments'] as String?,
      activityNameOverride: json['activity_name_override'] as String?,
      subActivityIds:
          (json['sub_activity_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      details:
          (json['details'] as List<dynamic>?)
              ?.map(
                (e) => CreateUserActivityDetail.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CreateUserActivityToJson(_CreateUserActivity instance) =>
    <String, dynamic>{
      'activity_id': instance.activityId,
      'activity_timestamp': instance.activityTimestamp.toIso8601String(),
      'activity_date': instance.activityDate.toIso8601String(),
      'comments': instance.comments,
      'activity_name_override': instance.activityNameOverride,
      'sub_activity_ids': instance.subActivityIds,
      'details': instance.details.map((e) => e.toJson()).toList(),
    };
