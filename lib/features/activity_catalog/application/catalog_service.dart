import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/data/activity_repository.dart';
import 'package:logly/features/activity_catalog/data/category_repository.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/catalog_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_service.g.dart';

/// Service for coordinating activity catalog operations.
///
/// Orchestrates category and activity repositories, manages cache refresh.
class CatalogService {
  CatalogService(this._categoryRepository, this._activityRepository, this._logger);

  final CategoryRepository _categoryRepository;
  final ActivityRepository _activityRepository;
  final LoggerService _logger;

  /// Fetches all activity categories.
  Future<List<ActivityCategory>> getCategories() async {
    return _categoryRepository.getAll();
  }

  /// Fetches a single category by ID.
  Future<ActivityCategory> getCategoryById(String categoryId) async {
    if (categoryId.isEmpty) {
      throw const CategoryNotFoundException('Category ID cannot be empty');
    }
    return _categoryRepository.getById(categoryId);
  }

  /// Fetches activities for a specific category.
  Future<List<Activity>> getActivitiesByCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      throw const ActivityFetchException('Category ID cannot be empty');
    }
    return _activityRepository.getByCategory(categoryId);
  }

  /// Fetches a single activity by ID with full details.
  Future<Activity> getActivityById(String activityId) async {
    if (activityId.isEmpty) {
      throw const ActivityNotFoundException('Activity ID cannot be empty');
    }
    return _activityRepository.getById(activityId);
  }

  /// Searches activities using semantic + FTS hybrid search.
  ///
  /// Returns empty list if query is less than 2 characters.
  Future<List<Activity>> searchActivities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return [];
    }
    return _activityRepository.search(trimmed);
  }

  /// Fetches popular activities for onboarding/favorites.
  Future<List<Activity>> getPopularActivities() async {
    return _activityRepository.getPopular();
  }

  /// Fetches suggested favorite activities.
  Future<List<Activity>> getSuggestedFavorites() async {
    return _activityRepository.getSuggestedFavorites();
  }

  /// Prefetches catalog data for faster subsequent access.
  ///
  /// Loads categories and popular activities in parallel.
  Future<void> prefetchCatalog() async {
    try {
      await Future.wait([
        _categoryRepository.getAll(),
        _activityRepository.getPopular(),
      ]);
      _logger.d('Catalog prefetch complete');
    } catch (e, st) {
      _logger.e('Catalog prefetch failed', e, st);
      // Don't rethrow - prefetch failures are non-critical
    }
  }
}

/// Provides the catalog service instance.
@Riverpod(keepAlive: true)
CatalogService catalogService(Ref ref) {
  return CatalogService(
    ref.watch(categoryRepositoryProvider),
    ref.watch(activityRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
