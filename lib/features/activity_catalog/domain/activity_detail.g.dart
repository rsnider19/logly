// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityDetail _$ActivityDetailFromJson(
  Map<String, dynamic> json,
) => _ActivityDetail(
  activityDetailId: json['activity_detail_id'] as String,
  activityId: json['activity_id'] as String,
  label: json['label'] as String,
  activityDetailType: $enumDecode(
    _$ActivityDetailTypeEnumMap,
    json['activity_detail_type'],
  ),
  sortOrder: (json['sort_order'] as num).toInt(),
  minNumeric: (json['min_numeric'] as num?)?.toDouble(),
  maxNumeric: (json['max_numeric'] as num?)?.toDouble(),
  minDurationInSec: (json['min_duration_in_sec'] as num?)?.toInt(),
  maxDurationInSec: (json['max_duration_in_sec'] as num?)?.toInt(),
  minDistanceInMeters: (json['min_distance_in_meters'] as num?)?.toDouble(),
  maxDistanceInMeters: (json['max_distance_in_meters'] as num?)?.toDouble(),
  minLiquidVolumeInLiters: (json['min_liquid_volume_in_liters'] as num?)
      ?.toDouble(),
  maxLiquidVolumeInLiters: (json['max_liquid_volume_in_liters'] as num?)
      ?.toDouble(),
  minWeightInKilograms: (json['min_weight_in_kilograms'] as num?)?.toDouble(),
  maxWeightInKilograms: (json['max_weight_in_kilograms'] as num?)?.toDouble(),
  sliderInterval: (json['slider_interval'] as num?)?.toDouble(),
  metricUom: $enumDecodeNullable(_$MetricUomEnumMap, json['metric_uom']),
  imperialUom: $enumDecodeNullable(_$ImperialUomEnumMap, json['imperial_uom']),
  useForPaceCalculation: json['use_for_pace_calculation'] as bool? ?? false,
);

Map<String, dynamic> _$ActivityDetailToJson(_ActivityDetail instance) =>
    <String, dynamic>{
      'activity_detail_id': instance.activityDetailId,
      'activity_id': instance.activityId,
      'label': instance.label,
      'activity_detail_type':
          _$ActivityDetailTypeEnumMap[instance.activityDetailType]!,
      'sort_order': instance.sortOrder,
      'min_numeric': instance.minNumeric,
      'max_numeric': instance.maxNumeric,
      'min_duration_in_sec': instance.minDurationInSec,
      'max_duration_in_sec': instance.maxDurationInSec,
      'min_distance_in_meters': instance.minDistanceInMeters,
      'max_distance_in_meters': instance.maxDistanceInMeters,
      'min_liquid_volume_in_liters': instance.minLiquidVolumeInLiters,
      'max_liquid_volume_in_liters': instance.maxLiquidVolumeInLiters,
      'min_weight_in_kilograms': instance.minWeightInKilograms,
      'max_weight_in_kilograms': instance.maxWeightInKilograms,
      'slider_interval': instance.sliderInterval,
      'metric_uom': _$MetricUomEnumMap[instance.metricUom],
      'imperial_uom': _$ImperialUomEnumMap[instance.imperialUom],
      'use_for_pace_calculation': instance.useForPaceCalculation,
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

const _$MetricUomEnumMap = {
  MetricUom.meters: 'meters',
  MetricUom.kilometers: 'kilometers',
  MetricUom.milliliters: 'milliliters',
  MetricUom.liters: 'liters',
  MetricUom.grams: 'grams',
  MetricUom.kilograms: 'kilograms',
};

const _$ImperialUomEnumMap = {
  ImperialUom.yards: 'yards',
  ImperialUom.miles: 'miles',
  ImperialUom.fluidOunces: 'fluidOunces',
  ImperialUom.gallons: 'gallons',
  ImperialUom.ounces: 'ounces',
  ImperialUom.pounds: 'pounds',
};
