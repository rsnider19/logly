// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivity _$UserActivityFromJson(Map<String, dynamic> json) =>
    _UserActivity(
      userActivityId: json['user_activity_id'] as String,
      userId: json['user_id'] as String,
      activityId: json['activity_id'] as String,
      activityTimestamp: DateTime.parse(json['activity_timestamp'] as String),
      activityDate: json['activity_date'] == null
          ? null
          : DateTime.parse(json['activity_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      comments: json['comments'] as String?,
      activityNameOverride: json['activity_name_override'] as String?,
      activity: json['activity'] == null
          ? null
          : Activity.fromJson(json['activity'] as Map<String, dynamic>),
      userActivityDetail:
          (json['user_activity_detail'] as List<dynamic>?)
              ?.map(
                (e) => UserActivityDetail.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      subActivity:
          (json['sub_activity'] as List<dynamic>?)
              ?.map((e) => SubActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UserActivityToJson(_UserActivity instance) =>
    <String, dynamic>{
      'user_activity_id': instance.userActivityId,
      'user_id': instance.userId,
      'activity_id': instance.activityId,
      'activity_timestamp': instance.activityTimestamp.toIso8601String(),
      'activity_date': instance.activityDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'comments': instance.comments,
      'activity_name_override': instance.activityNameOverride,
      'activity': instance.activity?.toJson(),
      'user_activity_detail': instance.userActivityDetail
          .map((e) => e.toJson())
          .toList(),
      'sub_activity': instance.subActivity.map((e) => e.toJson()).toList(),
    };
