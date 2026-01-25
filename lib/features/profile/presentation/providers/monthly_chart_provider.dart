import 'package:dartx/dartx.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/activity_count_by_date.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_chart_provider.g.dart';

/// Notifier for selected category filters on the monthly chart.
///
/// An empty set means "all categories selected" (default state).
/// When user deselects a category, we populate with all except that one.
@riverpod
class SelectedCategoryFiltersStateNotifier extends _$SelectedCategoryFiltersStateNotifier {
  @override
  Set<String> build() => {};

  /// Toggles a category filter on/off.
  ///
  /// If state is empty (all selected), first populates with all category IDs
  /// then removes the toggled one.
  void toggle(String categoryId, List<String> allCategoryIds) {
    if (state.isEmpty) {
      // Empty means all selected, so toggling means deselecting one
      state = allCategoryIds.where((id) => id != categoryId).toSet();
    } else if (state.contains(categoryId)) {
      state = {...state}..remove(categoryId);
    } else {
      state = {...state, categoryId};
    }
  }

  /// Selects all categories (resets to empty set which means all selected).
  void selectAll() {
    state = {};
  }
}

/// Provides the effective set of selected category IDs.
///
/// When raw state is empty, returns all category IDs (all selected by default).
/// Otherwise returns the raw selection.
@riverpod
Future<Set<String>> effectiveSelectedFilters(Ref ref) async {
  final rawFilters = ref.watch(selectedCategoryFiltersStateProvider);
  final categories = await ref.watch(categoriesProvider.future);

  if (rawFilters.isEmpty) {
    return categories.map((c) => c.activityCategoryId).toSet();
  }
  return rawFilters;
}

/// Provides monthly chart data for all categories.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by month + category for the last 12 months.
@riverpod
Future<List<MonthlyCategoryData>> monthlyChartData(Ref ref) async {
  final rawData = await ref.watch(activityCountsByDateProvider.future);
  return _aggregateByMonth(rawData);
}

/// Aggregates raw activity counts by month and category for last 12 months.
List<MonthlyCategoryData> _aggregateByMonth(List<ActivityCountByDate> rawData) {
  final now = DateTime.now();
  final startDate = DateTime(now.year - 1, now.month, 1);

  // Filter to last 12 months and aggregate by month + category
  final monthlyTotals = <(int, int, String), int>{};
  for (final item in rawData) {
    if (item.activityDate.isBefore(startDate)) continue;

    final key = (item.activityDate.year, item.activityDate.month, item.activityCategoryId);
    monthlyTotals.update(key, (v) => v + item.count, ifAbsent: () => item.count);
  }

  return monthlyTotals.entries
      .map((e) {
        final (year, month, categoryId) = e.key;
        return MonthlyCategoryData(
          activityMonth: DateTime(year, month),
          activityCount: e.value,
          activityCategoryId: categoryId,
        );
      })
      .sortedByDescending((a) => a.activityMonth);
}

/// Provides filtered monthly chart data based on selected category filters.
@riverpod
Future<List<MonthlyCategoryData>> filteredMonthlyChartData(Ref ref) async {
  final effectiveFilters = await ref.watch(effectiveSelectedFiltersProvider.future);
  final allData = await ref.watch(monthlyChartDataProvider.future);
  final categories = await ref.watch(categoriesProvider.future);

  // If all categories are selected, return all data (optimization)
  if (effectiveFilters.length == categories.length) {
    return allData;
  }

  return allData
      .where((d) => d.activityCategoryId != null && effectiveFilters.contains(d.activityCategoryId))
      .toList();
}
