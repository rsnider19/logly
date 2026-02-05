import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contribution_provider.g.dart';

/// Provides contribution data (activity counts by day) for the last year,
/// filtered by the global category selection.
///
/// Derives from [dailyCategoryCountsProvider] single source of truth.
@riverpod
Future<Map<DateTime, int>> contributionData(Ref ref) async {
  // Watch all futures before any async gap to avoid disposal between awaits
  final rawDataFuture = ref.watch(dailyCategoryCountsProvider.future);
  final effectiveFiltersFuture = ref.watch(effectiveGlobalCategoryFiltersProvider.future);
  final categoriesFuture = ref.watch(activityCategoriesProvider.future);

  final (rawData, effectiveFilters, categories) = await (rawDataFuture, effectiveFiltersFuture, categoriesFuture).wait;

  // If all categories are selected, aggregate all data
  final allSelected = effectiveFilters.length == categories.length;

  final now = DateTime.now();
  final startDate = DateTime(now.year - 1, now.month, now.day);

  final dailyTotals = <DateTime, int>{};
  for (final day in rawData) {
    if (day.activityDate.isBefore(startDate)) continue;

    final dateKey = DateTime(day.activityDate.year, day.activityDate.month, day.activityDate.day);
    var dayTotal = 0;

    for (final cat in day.categories) {
      if (allSelected || effectiveFilters.contains(cat.activityCategoryId)) {
        dayTotal += cat.count;
      }
    }

    if (dayTotal > 0) {
      dailyTotals[dateKey] = dayTotal;
    }
  }

  return dailyTotals;
}
