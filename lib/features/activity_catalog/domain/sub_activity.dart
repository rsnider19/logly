import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/env_service.dart';

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
  }) = _SubActivity;

  const SubActivity._();

  factory SubActivity.fromJson(Map<String, dynamic> json) => _$SubActivityFromJson(json);

  /// The Supabase storage URL for this subactivity's icon.
  String get icon => '${EnvService.supabaseUrl}/storage/v1/object/public/sub_activity_icons/$subActivityId.png';
}
