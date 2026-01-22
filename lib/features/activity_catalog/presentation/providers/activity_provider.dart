import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_provider.g.dart';

/// Provides activities for a specific category.
@riverpod
Future<List<Activity>> activitiesByCategory(Ref ref, String categoryId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getActivitiesByCategory(categoryId);
}

/// Provides a single activity by ID with full details.
@riverpod
Future<Activity> activityById(Ref ref, String activityId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getActivityById(activityId);
}

/// Provides popular activities for onboarding.
@riverpod
Future<List<Activity>> popularActivities(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getPopularActivities();
}

/// Provides suggested favorite activities.
@riverpod
Future<List<Activity>> suggestedFavorites(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getSuggestedFavorites();
}
