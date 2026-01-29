// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_detail_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumberDetailConfig _$NumberDetailConfigFromJson(Map<String, dynamic> json) =>
    NumberDetailConfig(
      id: json['id'] as String,
      label: json['label'] as String? ?? '',
      isInteger: json['is_integer'] as bool? ?? true,
      maxValue: (json['max_value'] as num?)?.toDouble() ?? 100.0,
      $type: json['detailType'] as String?,
    );

Map<String, dynamic> _$NumberDetailConfigToJson(NumberDetailConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'is_integer': instance.isInteger,
      'max_value': instance.maxValue,
      'detailType': instance.$type,
    };

DurationDetailConfig _$DurationDetailConfigFromJson(
  Map<String, dynamic> json,
) => DurationDetailConfig(
  id: json['id'] as String,
  label: json['label'] as String? ?? '',
  maxSeconds: (json['max_seconds'] as num?)?.toInt() ?? 7200,
  useForPace: json['use_for_pace'] as bool? ?? false,
  $type: json['detailType'] as String?,
);

Map<String, dynamic> _$DurationDetailConfigToJson(
  DurationDetailConfig instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'max_seconds': instance.maxSeconds,
  'use_for_pace': instance.useForPace,
  'detailType': instance.$type,
};

DistanceDetailConfig _$DistanceDetailConfigFromJson(
  Map<String, dynamic> json,
) => DistanceDetailConfig(
  id: json['id'] as String,
  label: json['label'] as String? ?? '',
  isShort: json['is_short'] as bool? ?? false,
  maxValue: (json['max_value'] as num?)?.toDouble() ?? 50.0,
  useForPace: json['use_for_pace'] as bool? ?? false,
  $type: json['detailType'] as String?,
);

Map<String, dynamic> _$DistanceDetailConfigToJson(
  DistanceDetailConfig instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'is_short': instance.isShort,
  'max_value': instance.maxValue,
  'use_for_pace': instance.useForPace,
  'detailType': instance.$type,
};

EnvironmentDetailConfig _$EnvironmentDetailConfigFromJson(
  Map<String, dynamic> json,
) => EnvironmentDetailConfig(
  id: json['id'] as String,
  label: json['label'] as String? ?? 'Environment',
  $type: json['detailType'] as String?,
);

Map<String, dynamic> _$EnvironmentDetailConfigToJson(
  EnvironmentDetailConfig instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'detailType': instance.$type,
};

PaceDetailConfig _$PaceDetailConfigFromJson(Map<String, dynamic> json) =>
    PaceDetailConfig(
      id: json['id'] as String,
      paceType:
          $enumDecodeNullable(_$PaceTypeEnumMap, json['pace_type']) ??
          PaceType.minutesPerUom,
      $type: json['detailType'] as String?,
    );

Map<String, dynamic> _$PaceDetailConfigToJson(PaceDetailConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pace_type': _$PaceTypeEnumMap[instance.paceType]!,
      'detailType': instance.$type,
    };

const _$PaceTypeEnumMap = {
  PaceType.minutesPerUom: 'minutesPerUom',
  PaceType.minutesPer100Uom: 'minutesPer100Uom',
  PaceType.minutesPer500m: 'minutesPer500m',
  PaceType.floorsPerMinute: 'floorsPerMinute',
};
