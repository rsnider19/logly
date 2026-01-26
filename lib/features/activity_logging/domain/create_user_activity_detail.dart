import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';

part 'create_user_activity_detail.freezed.dart';
part 'create_user_activity_detail.g.dart';

/// Input model for creating a user activity detail value.
@freezed
abstract class CreateUserActivityDetail with _$CreateUserActivityDetail {
  const factory CreateUserActivityDetail({
    required String activityDetailId,
    required ActivityDetailType activityDetailType,
    String? textValue,
    EnvironmentType? environmentValue,
    double? numericValue,
    int? durationInSec,
    double? distanceInMeters,
    double? liquidVolumeInLiters,
    double? weightInKilograms,
    String? latLng,
  }) = _CreateUserActivityDetail;

  const CreateUserActivityDetail._();

  factory CreateUserActivityDetail.fromJson(Map<String, dynamic> json) => _$CreateUserActivityDetailFromJson(json);

  /// Returns true if this detail has any value set.
  bool get hasValue =>
      textValue != null ||
      environmentValue != null ||
      numericValue != null ||
      durationInSec != null ||
      distanceInMeters != null ||
      liquidVolumeInLiters != null ||
      weightInKilograms != null ||
      latLng != null;
}
