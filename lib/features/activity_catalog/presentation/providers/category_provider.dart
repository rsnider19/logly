import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

/// Provides all activity categories sorted by sort_order.
///
/// This is a keepAlive provider for reuse across the app.
/// Categories are fetched once and cached for the lifetime of the app.
@Riverpod(keepAlive: true)
Future<List<ActivityCategory>> activityCategories(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getCategories();
}

/// Provides all activity categories.
@riverpod
Future<List<ActivityCategory>> categories(Ref ref) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getCategories();
}

/// Provides a single category by ID.
@riverpod
Future<ActivityCategory> categoryById(Ref ref, String categoryId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getCategoryById(categoryId);
}
