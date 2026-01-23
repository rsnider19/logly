// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategorySummary _$CategorySummaryFromJson(Map<String, dynamic> json) =>
    _CategorySummary(
      activityCategoryId: json['activity_category_id'] as String,
      activityCount: (json['activity_count'] as num).toInt(),
    );

Map<String, dynamic> _$CategorySummaryToJson(_CategorySummary instance) =>
    <String, dynamic>{
      'activity_category_id': instance.activityCategoryId,
      'activity_count': instance.activityCount,
    };
