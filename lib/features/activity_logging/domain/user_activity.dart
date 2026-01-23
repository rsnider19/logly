import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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

  /// Returns the effective color from the activity or its category.
  Color getColor(BuildContext context) => activity?.getColor(context) ?? Theme.of(context).colorScheme.onSurface;
}
