import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/activity_month_statistics.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_statistics_provider.g.dart';

/// Fetches user activities for a specific activity and month.
@riverpod
Future<List<UserActivity>> activityMonthUserActivities(
  Ref ref,
  String activityId,
  int year,
  int month,
) async {
  final service = ref.watch(activityLoggingServiceProvider);
  final startDate = DateTime(year, month);
  final endDate = DateTime(year, month + 1).subtract(const Duration(days: 1));
  return service.getUserActivitiesByActivityIdAndDateRange(activityId, startDate, endDate);
}

/// Derives monthly statistics from the fetched user activities.
@riverpod
Future<ActivityMonthStatistics> activityMonthStatistics(
  Ref ref,
  String activityId,
  int year,
  int month,
) async {
  final activities = await ref.watch(
    activityMonthUserActivitiesProvider(activityId, year, month).future,
  );

  // Build daily count map
  final dailyCounts = <DateTime, int>{};
  for (final ua in activities) {
    final date = DateTime(
      ua.activityTimestamp.year,
      ua.activityTimestamp.month,
      ua.activityTimestamp.day,
    );
    dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
  }

  // Build subactivity count map
  final subActivityMap = <String, _SubActivityAccumulator>{};
  for (final ua in activities) {
    for (final sa in ua.subActivity) {
      final acc = subActivityMap.putIfAbsent(
        sa.subActivityId,
        () => _SubActivityAccumulator(sa),
      );
      acc.count++;
    }
  }

  // Sort by count descending
  final subActivityCounts = subActivityMap.values
      .map((acc) => SubActivityCount(subActivity: acc.subActivity, count: acc.count))
      .toList()
    ..sort((a, b) => b.count.compareTo(a.count));

  return ActivityMonthStatistics(
    dailyActivityCounts: dailyCounts,
    subActivityCounts: subActivityCounts,
    totalCount: activities.length,
  );
}

class _SubActivityAccumulator {
  _SubActivityAccumulator(this.subActivity);
  final SubActivity subActivity;
  int count = 0;
}
