import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';

part 'update_user_activity.freezed.dart';
part 'update_user_activity.g.dart';

/// Input model for updating an existing user activity log.
@freezed
abstract class UpdateUserActivity with _$UpdateUserActivity {
  const factory UpdateUserActivity({
    /// The ID of the user activity to update.
    required String userActivityId,

    /// The updated timestamp of the activity.
    required DateTime activityTimestamp,

    /// The updated date of the activity (date only, calculated client-side).
    required DateTime activityDate,

    /// Updated comments/notes.
    String? comments,

    /// Updated custom name override.
    String? activityNameOverride,

    /// Updated sub-activity IDs.
    @Default([]) List<String> subActivityIds,

    /// Updated detail values.
    @Default([]) List<CreateUserActivityDetail> details,
  }) = _UpdateUserActivity;

  const UpdateUserActivity._();

  factory UpdateUserActivity.fromJson(Map<String, dynamic> json) => _$UpdateUserActivityFromJson(json);

  /// Converts to JSON format expected by the update_user_activity RPC.
  Map<String, dynamic> toUserActivityJson() {
    return {
      'user_activity_id': userActivityId,
      'activity_timestamp': activityTimestamp.toIso8601String(),
      'activity_date': '${activityDate.year}-${activityDate.month.toString().padLeft(2, '0')}-${activityDate.day.toString().padLeft(2, '0')}',
      'comments': comments,
      'activity_name_override': activityNameOverride,
    };
  }
}
