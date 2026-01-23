import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/application/profile_service.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
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
@riverpod
Future<List<MonthlyCategoryData>> monthlyChartData(Ref ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getMonthlyData();
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
