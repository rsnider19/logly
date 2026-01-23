// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubActivity _$SubActivityFromJson(Map<String, dynamic> json) => _SubActivity(
  subActivityId: json['sub_activity_id'] as String,
  activityId: json['activity_id'] as String,
  name: json['name'] as String,
  subActivityCode: json['sub_activity_code'] as String,
);

Map<String, dynamic> _$SubActivityToJson(_SubActivity instance) =>
    <String, dynamic>{
      'sub_activity_id': instance.subActivityId,
      'activity_id': instance.activityId,
      'name': instance.name,
      'sub_activity_code': instance.subActivityCode,
    };
