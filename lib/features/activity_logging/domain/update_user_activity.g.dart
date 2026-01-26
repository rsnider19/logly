// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateUserActivity _$UpdateUserActivityFromJson(Map<String, dynamic> json) =>
    _UpdateUserActivity(
      userActivityId: json['user_activity_id'] as String,
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

Map<String, dynamic> _$UpdateUserActivityToJson(_UpdateUserActivity instance) =>
    <String, dynamic>{
      'user_activity_id': instance.userActivityId,
      'activity_timestamp': instance.activityTimestamp.toIso8601String(),
      'activity_date': instance.activityDate.toIso8601String(),
      'comments': instance.comments,
      'activity_name_override': instance.activityNameOverride,
      'sub_activity_ids': instance.subActivityIds,
      'details': instance.details.map((e) => e.toJson()).toList(),
    };
