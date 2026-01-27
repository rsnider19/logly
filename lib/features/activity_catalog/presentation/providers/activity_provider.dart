import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_provider.g.dart';

/// Provides activity summaries for a specific category (lightweight, for chips/lists).
@riverpod
Future<List<ActivitySummary>> activitiesByCategorySummary(Ref ref, String categoryId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getActivitiesByCategorySummary(categoryId);
}

/// Provides a single activity by ID with full details (for log/edit screens).
@riverpod
Future<Activity> activityById(Ref ref, String activityId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getActivityById(activityId);
}

/// Provides popular activity summaries for onboarding.
@riverpod
Future<List<ActivitySummary>> popularActivitiesSummary(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getPopularActivitiesSummary();
}

/// Provides suggested favorite activity summaries.
@riverpod
Future<List<ActivitySummary>> suggestedFavoritesSummary(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getSuggestedFavoritesSummary();
}

/// Provides suggested favorite activity summaries for a specific category.
@riverpod
Future<List<ActivitySummary>> suggestedFavoritesByCategorySummary(Ref ref, String categoryId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getSuggestedFavoritesByCategorySummary(categoryId);
}
