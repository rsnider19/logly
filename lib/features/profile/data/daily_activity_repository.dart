import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
import 'package:logly/features/profile/domain/day_activity_count.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'daily_activity_repository.g.dart';

/// Repository for fetching activity data from the daily_activity_counts_by_category view.
///
/// Uses PostgREST aggregate functions for server-side computation.
class DailyActivityRepository {
  DailyActivityRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches category summary using PostgREST aggregate (server-side grouping).
  ///
  /// If no dates are provided, returns all-time summary.
  Future<List<CategorySummary>> getCategorySummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase.from('daily_activity_counts_by_category').select('activity_category_id, count.sum()');

      if (startDate != null) {
        query = query.gte('activity_date', startDate.toIso8601String().split('T')[0]);
      }
      if (endDate != null) {
        query = query.lte('activity_date', endDate.toIso8601String().split('T')[0]);
      }

      final response = await query;

      return (response as List).map((e) {
        return CategorySummary(
          activityCategoryId: e['activity_category_id'] as String,
          activityCount: (e['sum'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch category summary', e, st);
      throw FetchSummaryException(e.toString());
    }
  }

  /// Fetches daily totals for contribution graph (server-side grouping by date).
  Future<List<DayActivityCount>> getDailyTotals({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('daily_activity_counts_by_category')
          .select('activity_date, count.sum()')
          .gte('activity_date', startDate.toIso8601String().split('T')[0])
          .lte('activity_date', endDate.toIso8601String().split('T')[0]);

      return (response as List).map((e) {
        return DayActivityCount(
          date: DateTime.parse(e['activity_date'] as String),
          count: (e['sum'] as num?)?.toInt() ?? 0,
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
