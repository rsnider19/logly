// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserActivityDetail _$UserActivityDetailFromJson(Map<String, dynamic> json) =>
    _UserActivityDetail(
      userActivityId: json['user_activity_id'] as String,
      activityDetailId: json['activity_detail_id'] as String,
      activityDetailType: $enumDecode(
        _$ActivityDetailTypeEnumMap,
        json['activity_detail_type'],
      ),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      textValue: json['text_value'] as String?,
      environmentValue: $enumDecodeNullable(
        _$EnvironmentTypeEnumMap,
        json['environment_value'],
      ),
      numericValue: (json['numeric_value'] as num?)?.toDouble(),
      durationInSec: (json['duration_in_sec'] as num?)?.toInt(),
      distanceInMeters: (json['distance_in_meters'] as num?)?.toDouble(),
      liquidVolumeInLiters: (json['liquid_volume_in_liters'] as num?)
          ?.toDouble(),
      weightInKilograms: (json['weight_in_kilograms'] as num?)?.toDouble(),
      latLng: json['lat_lng'] as String?,
      activityDetail: json['activity_detail'] == null
          ? null
          : ActivityDetail.fromJson(
              json['activity_detail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$UserActivityDetailToJson(_UserActivityDetail instance) =>
    <String, dynamic>{
      'user_activity_id': instance.userActivityId,
      'activity_detail_id': instance.activityDetailId,
      'activity_detail_type':
          _$ActivityDetailTypeEnumMap[instance.activityDetailType]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'text_value': instance.textValue,
      'environment_value': _$EnvironmentTypeEnumMap[instance.environmentValue],
      'numeric_value': instance.numericValue,
      'duration_in_sec': instance.durationInSec,
      'distance_in_meters': instance.distanceInMeters,
      'liquid_volume_in_liters': instance.liquidVolumeInLiters,
      'weight_in_kilograms': instance.weightInKilograms,
      'lat_lng': instance.latLng,
      'activity_detail': instance.activityDetail?.toJson(),
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
