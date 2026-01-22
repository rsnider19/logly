import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';

part 'create_user_activity.freezed.dart';
part 'create_user_activity.g.dart';

/// Input model for creating a new user activity log.
@freezed
abstract class CreateUserActivity with _$CreateUserActivity {
  const factory CreateUserActivity({
    required String activityId,
    required DateTime activityStartDate,
    required DateTime activityEndDate,
    String? comments,
    String? activityNameOverride,
    @Default([]) List<String> subActivityIds,
    @Default([]) List<CreateUserActivityDetail> details,
  }) = _CreateUserActivity;

  factory CreateUserActivity.fromJson(Map<String, dynamic> json) => _$CreateUserActivityFromJson(json);
}
