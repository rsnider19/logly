import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:logly/features/home/domain/home_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'daily_activities_repository.g.dart';

/// Repository for fetching daily activity summaries via Supabase.
class DailyActivitiesRepository {
  DailyActivitiesRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// The select statement for fetching user activities with related data.
  ///
  /// Excludes activity_detail and user_activity_detail since the home screen
  /// only needs activity name, category, and selected subactivities for display.
  static const String _selectWithRelations = '''
    *,
    activity:activity(*,
      activity_category:activity_category(*)
    ),
    sub_activity:user_activity_sub_activity(
      ...sub_activity(*)
    )
  ''';

  /// Fetches daily activity summaries for a date range using PostgREST.
  ///
  /// Queries the user_activity table and groups results by date.
  Future<List<DailyActivitySummary>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day).add(const Duration(days: 1));

      // TODO(dev): Remove this delay - for testing loading states only
      await Future<void>.delayed(const Duration(seconds: 2));

      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .gte('activity_timestamp', start.toIso8601String())
          .lt('activity_timestamp', end.toIso8601String())
          .order('activity_timestamp', ascending: false);

      final activities = (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();

      return _groupActivitiesByDate(activities);
    } catch (e, st) {
      _logger.e('Failed to fetch daily activities for range $startDate - $endDate', e, st);
      throw FetchDailyActivitiesException(e.toString());
    }
  }

  /// Groups a list of user activities by date into DailyActivitySummary objects.
  List<DailyActivitySummary> _groupActivitiesByDate(List<UserActivity> activities) {
    final groupedByDate = <DateTime, List<UserActivity>>{};

    for (final activity in activities) {
      final date = DateTime(
        activity.activityTimestamp.year,
        activity.activityTimestamp.month,
        activity.activityTimestamp.day,
      );

      groupedByDate.putIfAbsent(date, () => []).add(activity);
    }

    return groupedByDate.entries
        .map(
          (entry) => DailyActivitySummary(
            activityDate: entry.key,
            activityCount: entry.value.length,
            userActivities: entry.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.activityDate.compareTo(a.activityDate));
  }
}

/// Provides the daily activities repository instance.
@Riverpod(keepAlive: true)
DailyActivitiesRepository dailyActivitiesRepository(Ref ref) {
  return DailyActivitiesRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
