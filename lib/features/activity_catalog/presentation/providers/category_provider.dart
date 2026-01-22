import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

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
