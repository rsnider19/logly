// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_category_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PeriodCategoryCounts _$PeriodCategoryCountsFromJson(
  Map<String, dynamic> json,
) => _PeriodCategoryCounts(
  activityCategoryId: json['activity_category_id'] as String,
  pastWeek: (json['past_week'] as num).toInt(),
  pastMonth: (json['past_month'] as num).toInt(),
  pastYear: (json['past_year'] as num).toInt(),
  allTime: (json['all_time'] as num).toInt(),
);

Map<String, dynamic> _$PeriodCategoryCountsToJson(
  _PeriodCategoryCounts instance,
) => <String, dynamic>{
  'activity_category_id': instance.activityCategoryId,
  'past_week': instance.pastWeek,
  'past_month': instance.pastMonth,
  'past_year': instance.pastYear,
  'all_time': instance.allTime,
};
