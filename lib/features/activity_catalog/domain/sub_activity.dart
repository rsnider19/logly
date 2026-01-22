import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_activity.freezed.dart';
part 'sub_activity.g.dart';

/// A more specific option within an activity (e.g., "Interval Running" under "Running").
@freezed
abstract class SubActivity with _$SubActivity {
  const factory SubActivity({
    required String subActivityId,
    required String activityId,
    required String name,
    required String subActivityCode,
    String? icon,
  }) = _SubActivity;

  factory SubActivity.fromJson(Map<String, dynamic> json) => _$SubActivityFromJson(json);
}
