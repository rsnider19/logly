import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';

part 'create_user_activity.freezed.dart';
part 'create_user_activity.g.dart';

/// Input model for creating a new user activity log (single day).
///
/// For multi-day logging, the service layer creates multiple instances
/// of this model, one for each day.
@freezed
abstract class CreateUserActivity with _$CreateUserActivity {
  const factory CreateUserActivity({
    /// The activity type to log.
    required String activityId,

    /// The timestamp of the activity (includes time component).
    required DateTime activityTimestamp,

    /// The date of the activity (date only, calculated client-side).
    required DateTime activityDate,

    /// Optional comments/notes for this activity.
    String? comments,

    /// Optional custom name override for this activity.
    String? activityNameOverride,

    /// Selected sub-activity IDs.
    @Default([]) List<String> subActivityIds,

    /// Detail values for this activity.
    @Default([]) List<CreateUserActivityDetail> details,
  }) = _CreateUserActivity;

  const CreateUserActivity._();

  factory CreateUserActivity.fromJson(Map<String, dynamic> json) => _$CreateUserActivityFromJson(json);

  /// Creates a CreateUserActivity for a specific date.
  ///
  /// Convenience factory that sets both activityTimestamp and activityDate
  /// from a single DateTime, using midnight for the timestamp.
  factory CreateUserActivity.forDate({
    required String activityId,
    required DateTime date,
    String? comments,
    String? activityNameOverride,
    List<String> subActivityIds = const [],
    List<CreateUserActivityDetail> details = const [],
  }) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return CreateUserActivity(
      activityId: activityId,
      activityTimestamp: dateOnly,
      activityDate: dateOnly,
      comments: comments,
      activityNameOverride: activityNameOverride,
      subActivityIds: subActivityIds,
      details: details,
    );
  }

  /// Converts to JSON format expected by the create_user_activity RPC.
  Map<String, dynamic> toUserActivityJson() {
    return {
      'activity_id': activityId,
      'activity_timestamp': activityTimestamp.toIso8601String(),
      'activity_date':
          '${activityDate.year}-${activityDate.month.toString().padLeft(2, '0')}-${activityDate.day.toString().padLeft(2, '0')}',
      'comments': comments,
      'activity_name_override': activityNameOverride,
    };
  }
}
