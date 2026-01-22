import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_activities_provider.g.dart';

/// Provides user activities for a specific date.
@riverpod
Future<List<UserActivity>> userActivitiesByDate(Ref ref, DateTime date) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getUserActivitiesByDate(date);
}

/// Provides user activities for a date range.
@riverpod
Future<List<UserActivity>> userActivitiesByDateRange(
  Ref ref,
  DateTime startDate,
  DateTime endDate,
) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getUserActivitiesByDateRange(startDate, endDate);
}

/// Provides user activities for a specific activity type.
@riverpod
Future<List<UserActivity>> userActivitiesByActivityId(Ref ref, String activityId) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getUserActivitiesByActivityId(activityId);
}

/// Provides a single user activity by ID.
@riverpod
Future<UserActivity> userActivityById(Ref ref, String userActivityId) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getUserActivityById(userActivityId);
}

/// Provides recent user activities.
@riverpod
Future<List<UserActivity>> recentUserActivities(Ref ref, {int limit = 20}) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getRecentUserActivities(limit: limit);
}

/// Provides user activities for today.
@riverpod
Future<List<UserActivity>> todaysActivities(Ref ref) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getUserActivitiesByDate(DateTime.now());
}
