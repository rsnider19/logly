// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: json['activity_id'] as String,
  activityCategoryId: json['activity_category_id'] as String,
  name: json['name'] as String,
  activityCode: json['activity_code'] as String,
  description: json['description'] as String?,
  hexColor: json['hex_color'] as String?,
  icon: json['icon'] as String?,
  activityDateType: $enumDecode(
    _$ActivityDateTypeEnumMap,
    json['activity_date_type'],
  ),
  paceType: $enumDecodeNullable(_$PaceTypeEnumMap, json['pace_type']),
  isSuggestedFavorite: json['is_suggested_favorite'] as bool? ?? false,
  activityCategory: json['activity_category'] == null
      ? null
      : ActivityCategory.fromJson(
          json['activity_category'] as Map<String, dynamic>,
        ),
  activityDetail:
      (json['activity_detail'] as List<dynamic>?)
          ?.map((e) => ActivityDetail.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  subActivity:
      (json['sub_activity'] as List<dynamic>?)
          ?.map((e) => SubActivity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'activity_category_id': instance.activityCategoryId,
  'name': instance.name,
  'activity_code': instance.activityCode,
  'description': instance.description,
  'hex_color': instance.hexColor,
  'icon': instance.icon,
  'activity_date_type': _$ActivityDateTypeEnumMap[instance.activityDateType]!,
  'pace_type': _$PaceTypeEnumMap[instance.paceType],
  'is_suggested_favorite': instance.isSuggestedFavorite,
  'activity_category': instance.activityCategory?.toJson(),
  'activity_detail': instance.activityDetail.map((e) => e.toJson()).toList(),
  'sub_activity': instance.subActivity.map((e) => e.toJson()).toList(),
};

const _$ActivityDateTypeEnumMap = {
  ActivityDateType.single: 'single',
  ActivityDateType.range: 'range',
};

const _$PaceTypeEnumMap = {
  PaceType.minutesPerUom: 'minutesPerUom',
  PaceType.minutesPer100Uom: 'minutesPer100Uom',
  PaceType.minutesPer500m: 'minutesPer500m',
  PaceType.floorsPerMinute: 'floorsPerMinute',
};
