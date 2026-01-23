// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_activity_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayActivityCount _$DayActivityCountFromJson(Map<String, dynamic> json) =>
    _DayActivityCount(
      date: DateTime.parse(json['activity_day'] as String),
      count: (json['activity_count'] as num).toInt(),
    );

Map<String, dynamic> _$DayActivityCountToJson(_DayActivityCount instance) =>
    <String, dynamic>{
      'activity_day': instance.date.toIso8601String(),
      'activity_count': instance.count,
    };
