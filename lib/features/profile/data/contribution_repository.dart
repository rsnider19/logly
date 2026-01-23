import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/day_activity_count.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'contribution_repository.g.dart';

/// Repository for fetching contribution and monthly chart data.
class ContributionRepository {
  ContributionRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches daily activity counts for the contribution graph.
  Future<List<DayActivityCount>> getDayActivityCounts({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_activity_day_count',
        params: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      _logger.d('day_count response type: ${response.runtimeType}, value: $response');

      // Handle both List and Map responses
      final List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map<String, dynamic>) {
        // If it's a map, check for common wrapper keys or return empty
        data = (response['data'] as List<dynamic>?) ?? [];
      } else {
        data = [];
      }

      return data
          .map((e) => DayActivityCount.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _logger.e('Failed to fetch day activity counts', e, st);
      throw FetchContributionException(e.toString());
    }
  }

  /// Fetches monthly category data for the stacked bar chart.
  ///
  /// If no categoryId is provided, returns data for all categories.
  Future<List<MonthlyCategoryData>> getMonthlyCategoryData({
    String? categoryId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_activity_category_monthly',
        params: categoryId != null ? {'_activity_category_id': categoryId} : null,
      );

      _logger.d('monthly_category response type: ${response.runtimeType}');

      // Handle both List and Map responses
      final List<dynamic> data;
      if (response is List) {
        data = response;
      } else if (response is Map<String, dynamic>) {
        data = (response['data'] as List<dynamic>?) ?? [];
      } else {
        data = [];
      }

      return data
          .map((e) => MonthlyCategoryData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _logger.e('Failed to fetch monthly category data', e, st);
      throw FetchMonthlyDataException(e.toString());
    }
  }
}

/// Provides the contribution repository instance.
@Riverpod(keepAlive: true)
ContributionRepository contributionRepository(Ref ref) {
  return ContributionRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
