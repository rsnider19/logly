import 'package:dartx/dartx.dart';
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

  /// Formats a DateTime as ISO date string (YYYY-MM-DD) for Supabase date queries.
  String _formatDate(DateTime date) {
    final d = date.date;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

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
      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .gte('activity_date', _formatDate(startDate))
          .lte('activity_date', _formatDate(endDate))
          .order('activity_timestamp', ascending: false);

      final activities = (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();

      return _groupActivitiesByDate(activities);
    } catch (e, st) {
      _logger.e('Failed to fetch daily activities for range $startDate - $endDate', e, st);
      throw FetchDailyActivitiesException(e.toString());
    }
  }

  /// Groups a list of user activities by date into DailyActivitySummary objects.
  ///
  /// Uses [UserActivity.activityDate] (the user's intended date) rather than
  /// [UserActivity.activityTimestamp] to ensure activities appear on the
  /// correct day regardless of timezone.
  List<DailyActivitySummary> _groupActivitiesByDate(List<UserActivity> activities) {
    final groupedByDate = <DateTime, List<UserActivity>>{};

    for (final activity in activities) {
      // Use activityDate (the user's intended date) for grouping.
      // Fall back to activityTimestamp date if activityDate is null.
      final date = (activity.activityDate ?? activity.activityTimestamp).date;
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
