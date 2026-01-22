import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/domain/activity_logging_exception.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'favorite_repository.g.dart';

/// Repository for managing user favorite activities via Supabase.
class FavoriteRepository {
  FavoriteRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches all favorite activities for the current user.
  Future<List<FavoriteActivity>> getAll() async {
    try {
      final response = await _supabase
          .from('favorite_user_activity')
          .select('*, activity:activity(*, activity_category:activity_category(*))')
          .order('created_at', ascending: false);

      return (response as List).map((e) => FavoriteActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch favorite activities', e, st);
      throw FetchFavoritesException(e.toString());
    }
  }

  /// Checks if an activity is favorited by the current user.
  Future<bool> isFavorite(String activityId) async {
    try {
      final response = await _supabase
          .from('favorite_user_activity')
          .select('activity_id')
          .eq('activity_id', activityId)
          .maybeSingle();

      return response != null;
    } catch (e, st) {
      _logger.e('Failed to check favorite status for $activityId', e, st);
      throw FetchFavoritesException(e.toString());
    }
  }

  /// Adds an activity to favorites.
  Future<void> add(String activityId) async {
    try {
      await _supabase.from('favorite_user_activity').insert({
        'activity_id': activityId,
      });
    } catch (e, st) {
      _logger.e('Failed to add favorite $activityId', e, st);
      throw FavoriteToggleException(e.toString());
    }
  }

  /// Removes an activity from favorites.
  Future<void> remove(String activityId) async {
    try {
      await _supabase.from('favorite_user_activity').delete().eq('activity_id', activityId);
    } catch (e, st) {
      _logger.e('Failed to remove favorite $activityId', e, st);
      throw FavoriteToggleException(e.toString());
    }
  }

  /// Toggles the favorite status of an activity.
  /// Returns the new favorite status.
  Future<bool> toggle(String activityId) async {
    final isFav = await isFavorite(activityId);
    if (isFav) {
      await remove(activityId);
      return false;
    } else {
      await add(activityId);
      return true;
    }
  }

  /// Fetches the set of favorited activity IDs for efficient lookup.
  Future<Set<String>> getFavoriteIds() async {
    try {
      final response = await _supabase.from('favorite_user_activity').select('activity_id');

      return (response as List).map((e) => e['activity_id'] as String).toSet();
    } catch (e, st) {
      _logger.e('Failed to fetch favorite IDs', e, st);
      throw FetchFavoritesException(e.toString());
    }
  }
}

/// Provides the favorite repository instance.
@Riverpod(keepAlive: true)
FavoriteRepository favoriteRepository(Ref ref) {
  return FavoriteRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
