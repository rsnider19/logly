import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/daily_category_counts.dart';
import 'package:logly/features/profile/domain/dow_category_counts.dart';
import 'package:logly/features/profile/domain/period_category_counts.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'daily_activity_repository.g.dart';

/// Repository for fetching activity data from profile views.
class DailyActivityRepository {
  DailyActivityRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches period counts per category from period_category_counts view.
  Future<List<PeriodCategoryCounts>> getPeriodCategoryCounts() async {
    try {
      final response = await _supabase
          .from('period_category_counts')
          .select('activity_category_id, past_week, past_month, past_year, all_time');

      return (response as List).map((e) => PeriodCategoryCounts.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch period category counts', e, st);
      throw FetchSummaryException(e.toString());
    }
  }

  /// Fetches daily counts with category breakdown from daily_category_counts view.
  /// Filters to last [daysAgo] days (default 365 for contribution chart).
  Future<List<DailyCategoryCounts>> getDailyCategoryCounts({int daysAgo = 365}) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: daysAgo));
      final response = await _supabase
          .from('daily_category_counts')
          .select('activity_date, categories')
          .gte('activity_date', startDate.toIso8601String().split('T')[0]);

      return (response as List).map((e) => DailyCategoryCounts.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch daily category counts', e, st);
      throw FetchDailyCountsException(e.toString());
    }
  }

  /// Fetches day-of-week counts per category from dow_category_counts view.
  Future<List<DowCategoryCounts>> getDowCategoryCounts() async {
    try {
      final response = await _supabase
          .from('dow_category_counts')
          .select('day_of_week, activity_category_id, past_week, past_month, past_year, all_time');

      return (response as List).map((e) => DowCategoryCounts.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch dow category counts', e, st);
      throw FetchWeeklyDataException(e.toString());
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
