// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteActivity _$FavoriteActivityFromJson(Map<String, dynamic> json) =>
    _FavoriteActivity(
      userId: json['user_id'] as String,
      activityId: json['activity_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      activity: json['activity'] == null
          ? null
          : ActivitySummary.fromJson(json['activity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteActivityToJson(_FavoriteActivity instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'activity_id': instance.activityId,
      'created_at': instance.createdAt.toIso8601String(),
      'activity': instance.activity?.toJson(),
    };
