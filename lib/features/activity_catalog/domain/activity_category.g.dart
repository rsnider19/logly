// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityCategory _$ActivityCategoryFromJson(Map<String, dynamic> json) =>
    _ActivityCategory(
      activityCategoryId: json['activity_category_id'] as String,
      name: json['name'] as String,
      activityCategoryCode: json['activity_category_code'] as String,
      hexColor: json['hex_color'] as String,
      sortOrder: (json['sort_order'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ActivityCategoryToJson(_ActivityCategory instance) =>
    <String, dynamic>{
      'activity_category_id': instance.activityCategoryId,
      'name': instance.name,
      'activity_category_code': instance.activityCategoryCode,
      'hex_color': instance.hexColor,
      'sort_order': instance.sortOrder,
      'description': instance.description,
    };
