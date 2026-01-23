import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
import 'package:logly/features/profile/domain/day_activity_count.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'daily_activity_repository.g.dart';

/// Repository for fetching activity data from profile views.
class DailyActivityRepository {
  DailyActivityRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches category summary from the time_period_activity_counts_by_category view.
  ///
  /// The view pre-computes counts for all time periods, so we just select the
  /// appropriate column based on the requested period.
  Future<List<CategorySummary>> getCategorySummary(TimePeriod period) async {
    try {
      final response = await _supabase
          .from('time_period_activity_counts_by_category')
          .select('activity_category_id, week, month, year, all_time, activity_category(*)');

      final countField = switch (period) {
        TimePeriod.oneWeek => 'week',
        TimePeriod.oneMonth => 'month',
        TimePeriod.oneYear => 'year',
        TimePeriod.all => 'all_time',
      };

      return (response as List).map((e) {
        return CategorySummary(
          activityCategoryId: e['activity_category_id'] as String,
          activityCount: (e[countField] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch category summary', e, st);
      throw FetchSummaryException(e.toString());
    }
  }

  /// Fetches daily totals for contribution graph.
  ///
  /// Fetches raw data from the view and aggregates by date on client side.
  Future<List<DayActivityCount>> getDailyTotals({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('daily_activity_counts_by_category')
          .select('activity_date, count')
          .gte('activity_date', startDate.toIso8601String().split('T')[0])
          .lte('activity_date', endDate.toIso8601String().split('T')[0]);

      // Aggregate by date on client
      final dailyTotals = <String, int>{};
      for (final row in response as List) {
        final date = row['activity_date'] as String;
        final count = row['count'] as int;
        dailyTotals.update(date, (v) => v + count, ifAbsent: () => count);
      }

      return dailyTotals.entries.map((e) {
        return DayActivityCount(
          date: DateTime.parse(e.key),
          count: e.value,
        );
      }).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch daily totals', e, st);
      throw FetchContributionException(e.toString());
    }
  }

  /// Fetches monthly category data for the stacked bar chart.
  ///
  /// Fetches raw daily data and aggregates by month on client side
  /// since PostgREST cannot group by derived month.
  Future<List<MonthlyCategoryData>> getMonthlyData() async {
    try {
      final endDate = DateTime.now();
      final startDate = DateTime(endDate.year - 1, endDate.month, 1);

      final response = await _supabase
          .from('daily_activity_counts_by_category')
          .select('activity_date, activity_category_id, count')
          .gte('activity_date', startDate.toIso8601String().split('T')[0])
          .lte('activity_date', endDate.toIso8601String().split('T')[0]);

      // Aggregate by month + category on client
      final monthlyTotals = <(int, int, String), int>{};
      for (final row in response as List) {
        final date = DateTime.parse(row['activity_date'] as String);
        final categoryId = row['activity_category_id'] as String;
        final count = row['count'] as int;
        final key = (date.year, date.month, categoryId);
        monthlyTotals.update(key, (v) => v + count, ifAbsent: () => count);
      }

      final result = monthlyTotals.entries.map((e) {
        final (year, month, categoryId) = e.key;
        return MonthlyCategoryData(
          activityMonth: DateTime(year, month),
          activityCount: e.value,
          activityCategoryId: categoryId,
        );
      }).toList()
        ..sort((a, b) => a.activityMonth.compareTo(b.activityMonth));

      return result;
    } catch (e, st) {
      _logger.e('Failed to fetch monthly data', e, st);
      throw FetchMonthlyDataException(e.toString());
    }
  }
}

/// Provides the daily activity repository instance.
@Riverpod(keepAlive: true)
DailyActivityRepository dailyActivityRepository(Ref ref) {
  return DailyActivityRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
