// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyCategoryData _$WeeklyCategoryDataFromJson(Map<String, dynamic> json) =>
    _WeeklyCategoryData(
      dayOfWeek: (json['day_of_week'] as num).toInt(),
      activityCount: (json['activity_count'] as num).toInt(),
      activityCategoryId: json['activity_category_id'] as String?,
    );

Map<String, dynamic> _$WeeklyCategoryDataToJson(_WeeklyCategoryData instance) =>
    <String, dynamic>{
      'day_of_week': instance.dayOfWeek,
      'activity_count': instance.activityCount,
      'activity_category_id': instance.activityCategoryId,
    };
