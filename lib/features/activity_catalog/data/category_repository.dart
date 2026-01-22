import 'dart:convert';

import 'package:logly/app/database/database_provider.dart';
import 'package:logly/app/database/drift_database.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/catalog_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'category_repository.g.dart';

/// Cache type for categories.
const String _cacheType = 'activity_category';

/// Cache key for all categories.
const String _allCategoriesCacheKey = 'all';

/// Repository for fetching activity categories.
class CategoryRepository {
  CategoryRepository(this._supabase, this._database, this._logger);

  final SupabaseClient _supabase;
  final AppDatabase _database;
  final LoggerService _logger;

  /// Fetches all activity categories, with caching.
  ///
  /// Returns cached data if available and not expired.
  /// Falls back to cache on network errors.
  Future<List<ActivityCategory>> getAll() async {
    try {
      // Try network first
      final response = await _supabase.from('activity_category').select().order('sort_order');

      final categories =
          (response as List).map((e) => ActivityCategory.fromJson(e as Map<String, dynamic>)).toList();

      // Cache the result
      await _cacheCategories(categories);

      return categories;
    } catch (e, st) {
      _logger.e('Failed to fetch categories from network', e, st);

      // Try to return cached data
      final cached = await _getCachedCategories();
      if (cached != null) {
        _logger.d('Returning cached categories');
        return cached;
      }

      throw CategoryFetchException(e.toString());
    }
  }

  /// Fetches a single category by ID.
  Future<ActivityCategory> getById(String categoryId) async {
    try {
      final response =
          await _supabase.from('activity_category').select().eq('activity_category_id', categoryId).single();

      return ActivityCategory.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch category $categoryId', e, st);
      throw CategoryNotFoundException(e.toString());
    }
  }

  Future<void> _cacheCategories(List<ActivityCategory> categories) async {
    try {
      final jsonList = categories.map((c) => c.toJson()).toList();
      await _database.upsertCachedData(
        id: _allCategoriesCacheKey,
        type: _cacheType,
        data: jsonEncode(jsonList),
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
      );
    } catch (e, st) {
      _logger.e('Failed to cache categories', e, st);
    }
  }

  Future<List<ActivityCategory>?> _getCachedCategories() async {
    try {
      final cached = await _database.getCachedData(_allCategoriesCacheKey, _cacheType);
      if (cached == null) return null;

      // Check expiration
      if (cached.expiresAt != null && cached.expiresAt!.isBefore(DateTime.now())) {
        return null;
      }

      final jsonList = jsonDecode(cached.data) as List;
      return jsonList.map((e) => ActivityCategory.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to read cached categories', e, st);
      return null;
    }
  }
}

/// Provides the category repository instance.
@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepository(
    ref.watch(supabaseProvider),
    ref.watch(appDatabaseProvider),
    ref.watch(loggerProvider),
  );
}
