import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';

part 'user_activity_detail.freezed.dart';
part 'user_activity_detail.g.dart';

/// A detail value recorded for a logged activity.
@freezed
abstract class UserActivityDetail with _$UserActivityDetail {
  const factory UserActivityDetail({
    required String userActivityId,
    required String activityDetailId,
    required ActivityDetailType activityDetailType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? textValue,
    EnvironmentType? environmentValue,
    double? numericValue,
    int? durationInSec,
    double? distanceInMeters,
    double? liquidVolumeInLiters,
    double? weightInKilograms,
    String? latLng,

    /// The activity detail configuration (populated via join).
    ActivityDetail? activityDetail,
  }) = _UserActivityDetail;

  const UserActivityDetail._();

  factory UserActivityDetail.fromJson(Map<String, dynamic> json) => _$UserActivityDetailFromJson(json);

  /// Returns true if this detail has a value set.
  bool get hasValue =>
      textValue != null ||
      environmentValue != null ||
      numericValue != null ||
      durationInSec != null ||
      distanceInMeters != null ||
      liquidVolumeInLiters != null ||
      weightInKilograms != null ||
      latLng != null;

  /// Gets the appropriate value based on the detail type.
  Object? get value {
    switch (activityDetailType) {
      case ActivityDetailType.string:
        return textValue;
      case ActivityDetailType.environment:
        return environmentValue;
      case ActivityDetailType.integer:
      case ActivityDetailType.double_:
        return numericValue;
      case ActivityDetailType.duration:
        return durationInSec;
      case ActivityDetailType.distance:
        return distanceInMeters;
      case ActivityDetailType.liquidVolume:
        return liquidVolumeInLiters;
      case ActivityDetailType.weight:
        return weightInKilograms;
      case ActivityDetailType.location:
        return latLng;
    }
  }
}
