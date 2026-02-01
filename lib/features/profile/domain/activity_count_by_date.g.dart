// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_count_by_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityCountByDate _$ActivityCountByDateFromJson(Map<String, dynamic> json) => _ActivityCountByDate(
  activityDate: DateTime.parse(json['activity_date'] as String),
  activityCategoryId: json['activity_category_id'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$ActivityCountByDateToJson(
  _ActivityCountByDate instance,
) => <String, dynamic>{
  'activity_date': instance.activityDate.toIso8601String(),
  'activity_category_id': instance.activityCategoryId,
  'count': instance.count,
};
