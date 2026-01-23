// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyCategoryData _$MonthlyCategoryDataFromJson(Map<String, dynamic> json) =>
    _MonthlyCategoryData(
      activityMonth: DateTime.parse(json['activity_month'] as String),
      activityCount: (json['activity_count'] as num).toInt(),
      activityCategoryId: json['activity_category_id'] as String?,
    );

Map<String, dynamic> _$MonthlyCategoryDataToJson(
  _MonthlyCategoryData instance,
) => <String, dynamic>{
  'activity_month': instance.activityMonth.toIso8601String(),
  'activity_count': instance.activityCount,
  'activity_category_id': instance.activityCategoryId,
};
