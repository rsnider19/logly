import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'summary_repository.g.dart';

/// Repository for fetching activity category summary data.
class SummaryRepository {
  SummaryRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches category summary with optional date range filtering.
  ///
  /// If no dates are provided, returns all-time summary.
  Future<List<CategorySummary>> getCategorySummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Only include params that have values - null params can cause issues with some RPCs
      final params = <String, dynamic>{};
      if (startDate != null) {
        params['_start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        params['_end_date'] = endDate.toIso8601String();
      }

      final response = await _supabase.rpc<List<dynamic>>(
        'user_activity_category_summary',
        params: params.isEmpty ? null : params,
      );

      return response
          .map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _logger.e('Failed to fetch category summary', e, st);
      throw FetchSummaryException(e.toString());
    }
  }
}

/// Provides the summary repository instance.
@Riverpod(keepAlive: true)
SummaryRepository summaryRepository(Ref ref) {
  return SummaryRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
