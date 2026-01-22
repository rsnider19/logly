import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';

part 'activity_detail.freezed.dart';
part 'activity_detail.g.dart';

/// Configuration for an activity detail field (e.g., duration, distance).
@freezed
abstract class ActivityDetail with _$ActivityDetail {
  const factory ActivityDetail({
    required String activityDetailId,
    required String activityId,
    required String label,
    required ActivityDetailType activityDetailType,
    required int sortOrder,
    double? minNumeric,
    double? maxNumeric,
    int? minDurationInSec,
    int? maxDurationInSec,
    double? minDistanceInMeters,
    double? maxDistanceInMeters,
    double? minLiquidVolumeInLiters,
    double? maxLiquidVolumeInLiters,
    double? minWeightInKilograms,
    double? maxWeightInKilograms,
    double? sliderInterval,
    MetricUom? metricUom,
    ImperialUom? imperialUom,
    @Default(false) bool useForPaceCalculation,
  }) = _ActivityDetail;

  factory ActivityDetail.fromJson(Map<String, dynamic> json) => _$ActivityDetailFromJson(json);
}
