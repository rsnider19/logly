import 'dart:convert';

import 'package:logly/app/database/database_provider.dart';
import 'package:logly/app/database/drift_database.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_catalog/domain/catalog_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'activity_repository.g.dart';

/// Cache type for activities.
const String _cacheType = 'activity';

/// Cache type for activity summaries.
const String _summaryCacheType = 'activity_summary';

/// Select statement for summary-only queries (no detail/subactivity joins).
const String _summarySelect = '*, activity_category:activity_category(*)';

/// Repository for fetching activities.
class ActivityRepository {
  ActivityRepository(this._supabase, this._database, this._logger);

  final SupabaseClient _supabase;
  final AppDatabase _database;
  final LoggerService _logger;

  /// Fetches activities by category, with caching.
  ///
  /// Returns cached data if available and not expired.
  /// Falls back to cache on network errors.
  Future<List<Activity>> getByCategory(String categoryId) async {
    final cacheKey = 'category::$categoryId';

    try {
      final response = await _supabase
          .from('activity')
          .select('*, activity_category(*), activity_detail(*), sub_activity(*)')
          .eq('activity_category_id', categoryId)
          .order('name', ascending: true);

      final activities = (response as List).map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

      // Cache the result
      await _cacheActivities(cacheKey, activities);

      return activities;
    } catch (e, st) {
      _logger.e('Failed to fetch activities for category $categoryId', e, st);

      // Try to return cached data
      final cached = await _getCachedActivities(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached activities for category $categoryId');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Fetches a single activity by ID with full nested data.
  Future<Activity> getById(String activityId) async {
    try {
      final response = await _supabase
          .from('activity')
          .select('*, activity_category(*), activity_detail(*), sub_activity(*)')
          .eq('activity_id', activityId)
          .single();

      return Activity.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch activity $activityId', e, st);
      throw ActivityNotFoundException(e.toString());
    }
  }

  /// Searches activities using the semantic + FTS hybrid search edge function.
  ///
  /// Results include nested activityCategory data.
  Future<List<Activity>> search(String query) async {
    try {
      final response = await _supabase.functions.invoke(
        'activity/search',
        body: {'query': query},
      );

      if (response.status != 200) {
        throw ActivitySearchException('Search returned status ${response.status}');
      }

      final data = response.data;
      if (data is List) {
        return data.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();
      }

      return [];
    } catch (e, st) {
      _logger.e('Failed to search activities for "$query"', e, st);
      if (e is CatalogException) rethrow;
      throw ActivitySearchException(e.toString());
    }
  }

  /// Fetches popular/trending activities for onboarding.
  Future<List<Activity>> getPopular() async {
    const cacheKey = 'popular';

    try {
      final response = await _supabase.rpc<List<dynamic>>('popular_activities').select('*, activity_category(*)');

      final activities = (response as List).map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

      // Cache the result
      await _cacheActivities(cacheKey, activities);

      return activities;
    } catch (e, st) {
      _logger.e('Failed to fetch popular activities', e, st);

      // Try to return cached data
      final cached = await _getCachedActivities(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached popular activities');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Fetches suggested favorite activities.
  Future<List<Activity>> getSuggestedFavorites() async {
    const cacheKey = 'suggested_favorites';

    try {
      final response = await _supabase
          .from('activity')
          .select('*, activity_category(*)')
          .eq('is_suggested_favorite', true)
          .order('name', ascending: true);

      final activities = (response as List).map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

      // Cache the result
      await _cacheActivities(cacheKey, activities);

      return activities;
    } catch (e, st) {
      _logger.e('Failed to fetch suggested favorites', e, st);

      // Try to return cached data
      final cached = await _getCachedActivities(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached suggested favorites');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Fetches suggested favorite activities for a specific category.
  Future<List<Activity>> getSuggestedFavoritesByCategory(String categoryId) async {
    final cacheKey = 'suggested_favorites::$categoryId';

    try {
      final response = await _supabase
          .from('activity')
          .select('*, activity_category(*)')
          .eq('is_suggested_favorite', true)
          .eq('activity_category_id', categoryId)
          .order('name', ascending: true);

      final activities = (response as List).map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

      // Cache the result
      await _cacheActivities(cacheKey, activities);

      return activities;
    } catch (e, st) {
      _logger.e('Failed to fetch suggested favorites for category $categoryId', e, st);

      // Try to return cached data
      final cached = await _getCachedActivities(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached suggested favorites for category $categoryId');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  // ==================== Summary Methods ====================

  /// Fetches activity summaries by category (no detail/subactivity data).
  Future<List<ActivitySummary>> getByCategorySummary(String categoryId) async {
    final cacheKey = 'summary::category::$categoryId';

    try {
      final response = await _supabase
          .from('activity')
          .select(_summarySelect)
          .eq('activity_category_id', categoryId)
          .order('name', ascending: true);

      final summaries = (response as List).map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();

      await _cacheSummaries(cacheKey, summaries);

      return summaries;
    } catch (e, st) {
      _logger.e('Failed to fetch activity summaries for category $categoryId', e, st);

      final cached = await _getCachedSummaries(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached activity summaries for category $categoryId');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Searches activities using the edge function and returns summaries.
  Future<List<ActivitySummary>> searchSummary(String query) async {
    try {
      final response = await _supabase.functions.invoke(
        'activity/search',
        body: {'query': query},
      );

      if (response.status != 200) {
        throw ActivitySearchException('Search returned status ${response.status}');
      }

      final data = response.data;
      if (data is List) {
        return data.map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();
      }

      return [];
    } catch (e, st) {
      _logger.e('Failed to search activity summaries for "$query"', e, st);
      if (e is CatalogException) rethrow;
      throw ActivitySearchException(e.toString());
    }
  }

  /// Fetches suggested favorite activity summaries.
  Future<List<ActivitySummary>> getSuggestedFavoritesSummary() async {
    const cacheKey = 'summary::suggested_favorites';

    try {
      final response = await _supabase
          .from('activity')
          .select(_summarySelect)
          .eq('is_suggested_favorite', true)
          .order('name', ascending: true);

      final summaries = (response as List).map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();

      await _cacheSummaries(cacheKey, summaries);

      return summaries;
    } catch (e, st) {
      _logger.e('Failed to fetch suggested favorite summaries', e, st);

      final cached = await _getCachedSummaries(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached suggested favorite summaries');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Fetches suggested favorite activity summaries for a specific category.
  Future<List<ActivitySummary>> getSuggestedFavoritesByCategorySummary(String categoryId) async {
    final cacheKey = 'summary::suggested_favorites::$categoryId';

    try {
      final response = await _supabase
          .from('activity')
          .select(_summarySelect)
          .eq('is_suggested_favorite', true)
          .eq('activity_category_id', categoryId)
          .order('name', ascending: true);

      final summaries = (response as List).map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();

      await _cacheSummaries(cacheKey, summaries);

      return summaries;
    } catch (e, st) {
      _logger.e('Failed to fetch suggested favorite summaries for category $categoryId', e, st);

      final cached = await _getCachedSummaries(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached suggested favorite summaries for category $categoryId');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  /// Fetches popular activity summaries.
  Future<List<ActivitySummary>> getPopularSummary() async {
    const cacheKey = 'summary::popular';

    try {
      final response = await _supabase.rpc<List<dynamic>>('popular_activities').select(_summarySelect);

      final summaries = (response as List).map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();

      await _cacheSummaries(cacheKey, summaries);

      return summaries;
    } catch (e, st) {
      _logger.e('Failed to fetch popular activity summaries', e, st);

      final cached = await _getCachedSummaries(cacheKey);
      if (cached != null) {
        _logger.d('Returning cached popular activity summaries');
        return cached;
      }

      throw ActivityFetchException(e.toString());
    }
  }

  // ==================== Cache Helpers ====================

  Future<void> _cacheSummaries(String cacheKey, List<ActivitySummary> summaries) async {
    try {
      final jsonList = summaries.map((s) => s.toJson()).toList();
      await _database.upsertCachedData(
        id: cacheKey,
        type: _summaryCacheType,
        data: jsonEncode(jsonList),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    } catch (e, st) {
      _logger.e('Failed to cache activity summaries', e, st);
    }
  }

  Future<List<ActivitySummary>?> _getCachedSummaries(String cacheKey) async {
    try {
      final cached = await _database.getCachedData(cacheKey, _summaryCacheType);
      if (cached == null) return null;

      if (cached.expiresAt != null && cached.expiresAt!.isBefore(DateTime.now())) {
        return null;
      }

      final jsonList = jsonDecode(cached.data) as List;
      return jsonList.map((e) => ActivitySummary.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to read cached activity summaries', e, st);
      return null;
    }
  }

  Future<void> _cacheActivities(String cacheKey, List<Activity> activities) async {
    try {
      final jsonList = activities.map((a) => a.toJson()).toList();
      await _database.upsertCachedData(
        id: cacheKey,
        type: _cacheType,
        data: jsonEncode(jsonList),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    } catch (e, st) {
      _logger.e('Failed to cache activities', e, st);
    }
  }

  Future<List<Activity>?> _getCachedActivities(String cacheKey) async {
    try {
      final cached = await _database.getCachedData(cacheKey, _cacheType);
      if (cached == null) return null;

      // Check expiration
      if (cached.expiresAt != null && cached.expiresAt!.isBefore(DateTime.now())) {
        return null;
      }

      final jsonList = jsonDecode(cached.data) as List;
      return jsonList.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to read cached activities', e, st);
      return null;
    }
  }
}

/// Provides the activity repository instance.
@Riverpod(keepAlive: true)
ActivityRepository activityRepository(Ref ref) {
  return ActivityRepository(
    ref.watch(supabaseProvider),
    ref.watch(appDatabaseProvider),
    ref.watch(loggerProvider),
  );
}
