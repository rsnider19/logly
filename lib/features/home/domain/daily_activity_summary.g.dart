// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyActivitySummary _$DailyActivitySummaryFromJson(
  Map<String, dynamic> json,
) => _DailyActivitySummary(
  activityDate: DateTime.parse(json['activity_date'] as String),
  activityCount: (json['activity_count'] as num).toInt(),
  userActivities:
      (json['user_activities'] as List<dynamic>?)
          ?.map((e) => UserActivity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DailyActivitySummaryToJson(
  _DailyActivitySummary instance,
) => <String, dynamic>{
  'activity_date': instance.activityDate.toIso8601String(),
  'activity_count': instance.activityCount,
  'user_activities': instance.userActivities.map((e) => e.toJson()).toList(),
};
