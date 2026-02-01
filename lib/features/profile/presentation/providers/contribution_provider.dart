import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/activity_count_by_date.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contribution_provider.g.dart';

/// Provides contribution data (activity counts by day) for the last year,
/// filtered by the global category selection.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by date for the contribution graph.
@riverpod
Future<Map<DateTime, int>> contributionData(Ref ref) async {
  // Watch all futures before any async gap to avoid disposal between awaits
  final rawDataFuture = ref.watch(activityCountsByDateProvider.future);
  final effectiveFiltersFuture = ref.watch(effectiveGlobalCategoryFiltersProvider.future);
  final categoriesFuture = ref.watch(activityCategoriesProvider.future);

  final (rawData, effectiveFilters, categories) = await (rawDataFuture, effectiveFiltersFuture, categoriesFuture).wait;

  // If all categories are selected, aggregate all data
  final allSelected = effectiveFilters.length == categories.length;
  return _aggregateByDate(rawData, allSelected ? null : effectiveFilters);
}

/// Aggregates raw activity counts by date for the last year.
/// Optionally filters by category IDs.
Map<DateTime, int> _aggregateByDate(List<ActivityCountByDate> rawData, Set<String>? categoryFilter) {
  final now = DateTime.now();
  final startDate = DateTime(now.year - 1, now.month, now.day);

  final dailyTotals = <DateTime, int>{};
  for (final item in rawData) {
    if (item.activityDate.isBefore(startDate)) continue;
    if (categoryFilter != null && !categoryFilter.contains(item.activityCategoryId)) continue;

    final dateKey = DateTime(
      item.activityDate.year,
      item.activityDate.month,
      item.activityDate.day,
    );
    dailyTotals.update(dateKey, (v) => v + item.count, ifAbsent: () => item.count);
  }

  return dailyTotals;
}
