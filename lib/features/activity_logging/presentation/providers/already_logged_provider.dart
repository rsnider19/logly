import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'already_logged_provider.g.dart';

/// Provides activities already logged for a specific date, sorted by creation time.
@riverpod
Future<List<UserActivity>> alreadyLoggedActivities(Ref ref, DateTime date) async {
  final service = ref.watch(activityLoggingServiceProvider);
  final activities = await service.getUserActivitiesByDate(date);
  activities.sort((a, b) {
    final aTime = a.createdAt ?? a.activityTimestamp;
    final bTime = b.createdAt ?? b.activityTimestamp;
    return aTime.compareTo(bTime);
  });
  return activities;
}
