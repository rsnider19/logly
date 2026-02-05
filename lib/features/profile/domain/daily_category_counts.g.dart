// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_category_counts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryCount _$CategoryCountFromJson(Map<String, dynamic> json) =>
    _CategoryCount(
      activityCategoryId: json['activity_category_id'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryCountToJson(_CategoryCount instance) =>
    <String, dynamic>{
      'activity_category_id': instance.activityCategoryId,
      'count': instance.count,
    };

_DailyCategoryCounts _$DailyCategoryCountsFromJson(Map<String, dynamic> json) =>
    _DailyCategoryCounts(
      activityDate: DateTime.parse(json['activity_date'] as String),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyCategoryCountsToJson(
  _DailyCategoryCounts instance,
) => <String, dynamic>{
  'activity_date': instance.activityDate.toIso8601String(),
  'categories': instance.categories.map((e) => e.toJson()).toList(),
};
