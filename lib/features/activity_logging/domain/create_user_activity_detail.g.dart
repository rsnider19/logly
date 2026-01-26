// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_activity_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateUserActivityDetail _$CreateUserActivityDetailFromJson(
  Map<String, dynamic> json,
) => _CreateUserActivityDetail(
  activityDetailId: json['activity_detail_id'] as String,
  activityDetailType: $enumDecode(
    _$ActivityDetailTypeEnumMap,
    json['activity_detail_type'],
  ),
  textValue: json['text_value'] as String?,
  environmentValue: $enumDecodeNullable(
    _$EnvironmentTypeEnumMap,
    json['environment_value'],
  ),
  numericValue: (json['numeric_value'] as num?)?.toDouble(),
  durationInSec: (json['duration_in_sec'] as num?)?.toInt(),
  distanceInMeters: (json['distance_in_meters'] as num?)?.toDouble(),
  liquidVolumeInLiters: (json['liquid_volume_in_liters'] as num?)?.toDouble(),
  weightInKilograms: (json['weight_in_kilograms'] as num?)?.toDouble(),
  latLng: json['lat_lng'] as String?,
);

Map<String, dynamic> _$CreateUserActivityDetailToJson(
  _CreateUserActivityDetail instance,
) => <String, dynamic>{
  'activity_detail_id': instance.activityDetailId,
  'activity_detail_type':
      _$ActivityDetailTypeEnumMap[instance.activityDetailType]!,
  'text_value': instance.textValue,
  'environment_value': _$EnvironmentTypeEnumMap[instance.environmentValue],
  'numeric_value': instance.numericValue,
  'duration_in_sec': instance.durationInSec,
  'distance_in_meters': instance.distanceInMeters,
  'liquid_volume_in_liters': instance.liquidVolumeInLiters,
  'weight_in_kilograms': instance.weightInKilograms,
  'lat_lng': instance.latLng,
};

const _$ActivityDetailTypeEnumMap = {
  ActivityDetailType.string: 'string',
  ActivityDetailType.integer: 'integer',
  ActivityDetailType.double_: 'double',
  ActivityDetailType.duration: 'duration',
  ActivityDetailType.distance: 'distance',
  ActivityDetailType.location: 'location',
  ActivityDetailType.environment: 'environment',
  ActivityDetailType.liquidVolume: 'liquidVolume',
  ActivityDetailType.weight: 'weight',
};

const _$EnvironmentTypeEnumMap = {
  EnvironmentType.indoor: 'indoor',
  EnvironmentType.outdoor: 'outdoor',
};
