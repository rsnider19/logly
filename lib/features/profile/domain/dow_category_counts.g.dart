// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dow_category_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DowCategoryCounts _$DowCategoryCountsFromJson(Map<String, dynamic> json) =>
    _DowCategoryCounts(
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      activityCategoryId: json['activity_category_id'] as String,
      pastWeek: (json['past_week'] as num).toInt(),
      pastMonth: (json['past_month'] as num).toInt(),
      pastYear: (json['past_year'] as num).toInt(),
      allTime: (json['all_time'] as num).toInt(),
    );

Map<String, dynamic> _$DowCategoryCountsToJson(_DowCategoryCounts instance) =>
    <String, dynamic>{
      'day_of_week': instance.dayOfWeek,
      'activity_category_id': instance.activityCategoryId,
      'past_week': instance.pastWeek,
      'past_month': instance.pastMonth,
      'past_year': instance.pastYear,
      'all_time': instance.allTime,
    };
