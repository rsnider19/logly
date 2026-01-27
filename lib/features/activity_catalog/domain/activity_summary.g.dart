// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivitySummary _$ActivitySummaryFromJson(Map<String, dynamic> json) =>
    _ActivitySummary(
      activityId: json['activity_id'] as String,
      activityCategoryId: json['activity_category_id'] as String,
      name: json['name'] as String,
      activityCode: json['activity_code'] as String,
      description: json['description'] as String?,
      activityDateType: $enumDecode(
        _$ActivityDateTypeEnumMap,
        json['activity_date_type'],
      ),
      isSuggestedFavorite: json['is_suggested_favorite'] as bool? ?? false,
      activityCategory: json['activity_category'] == null
          ? null
          : ActivityCategory.fromJson(
              json['activity_category'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ActivitySummaryToJson(
  _ActivitySummary instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'activity_category_id': instance.activityCategoryId,
  'name': instance.name,
  'activity_code': instance.activityCode,
  'description': instance.description,
  'activity_date_type': _$ActivityDateTypeEnumMap[instance.activityDateType]!,
  'is_suggested_favorite': instance.isSuggestedFavorite,
  'activity_category': instance.activityCategory?.toJson(),
};

const _$ActivityDateTypeEnumMap = {
  ActivityDateType.single: 'single',
  ActivityDateType.range: 'range',
};
