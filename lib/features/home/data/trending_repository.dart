import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/home/domain/home_exception.dart';
import 'package:logly/features/home/domain/trending_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'trending_repository.g.dart';

/// Repository for fetching trending activities via Supabase.
class TrendingRepository {
  TrendingRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Select statement for trending activities with related activity data.
  static const String _selectWithRelations = '''
    *,
    activity:activity_id(
      *,
      activity_category:activity_category_id(*)
    )
  ''';

  /// Fetches the top trending activities globally.
  Future<List<TrendingActivity>> getTrending({int limit = 25}) async {
    try {
      final response = await _supabase
          .from('trending_activity')
          .select(_selectWithRelations)
          .order('current_rank', ascending: true)
          .limit(limit);

      return (response as List).map((e) => TrendingActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch trending activities', e, st);
      throw FetchTrendingActivitiesException(e.toString());
    }
  }
}

/// Provides the trending repository instance.
@Riverpod(keepAlive: true)
TrendingRepository trendingRepository(Ref ref) {
  return TrendingRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
