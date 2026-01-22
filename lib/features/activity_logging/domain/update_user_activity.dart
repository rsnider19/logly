import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';

part 'update_user_activity.freezed.dart';
part 'update_user_activity.g.dart';

/// Input model for updating an existing user activity log.
@freezed
abstract class UpdateUserActivity with _$UpdateUserActivity {
  const factory UpdateUserActivity({
    required String userActivityId,
    required DateTime activityTimestamp,
    String? comments,
    String? activityNameOverride,
    @Default([]) List<String> subActivityIds,
    @Default([]) List<CreateUserActivityDetail> details,
  }) = _UpdateUserActivity;

  factory UpdateUserActivity.fromJson(Map<String, dynamic> json) => _$UpdateUserActivityFromJson(json);
}
