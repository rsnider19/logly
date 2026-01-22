import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity_detail.dart';

part 'user_activity.freezed.dart';
part 'user_activity.g.dart';

/// A logged activity instance created by a user.
@freezed
abstract class UserActivity with _$UserActivity {
  const factory UserActivity({
    required String userActivityId,
    required String userId,
    required String activityId,
    required DateTime activityTimestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? comments,
    String? activityNameOverride,

    /// The activity definition (populated via join).
    Activity? activity,

    /// The detail values for this log (populated via join).
    @Default([]) List<UserActivityDetail> userActivityDetail,

    /// The selected subactivities (populated via join).
    @Default([]) List<SubActivity> subActivity,
  }) = _UserActivity;

  const UserActivity._();

  factory UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

  /// Returns an empty UserActivity.
  factory UserActivity.empty({String? name}) => UserActivity(
    userActivityId: '',
    userId: '',
    activityId: '',
    activityTimestamp: DateTime.now(),
    activityNameOverride: name,
  );

  /// Returns the effective display name, using override if set.
  String get displayName => activityNameOverride ?? activity?.name ?? 'Unknown Activity';

  /// Returns the effective icon from the activity or its category.
  String? get effectiveIcon => activity?.effectiveIcon;

  /// Returns the effective color from the activity or its category.
  String get effectiveColor => activity?.effectiveColor ?? '#808080';

  /// Returns the effective icon URL from Supabase storage.
  ///
  /// Priority:
  /// 1. If only one subactivity was selected, use subactivity's icon
  /// 2. If multiple or no subactivities, use activity's icon
  /// 3. If activity has no icon, use category's icon
  String? get effectiveIconUrl {
    final baseUrl = EnvService.supabaseUrl;

    // Priority 1: Single subactivity icon
    if (subActivity.length == 1 && subActivity.first.icon != null) {
      return '$baseUrl/storage/v1/object/public/sub_activity_icons/${subActivity.first.subActivityId}.png';
    }

    // Priority 2: Activity icon
    if (activity?.icon != null) {
      return '$baseUrl/storage/v1/object/public/activity_icons/${activity!.activityId}.png';
    }

    // Priority 3: Category icon
    if (activity?.activityCategory?.icon != null) {
      return '$baseUrl/storage/v1/object/public/activity_category_icons/${activity!.activityCategory!.activityCategoryId}.png';
    }

    return null;
  }
}
