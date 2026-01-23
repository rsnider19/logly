import 'package:logly/features/profile/application/profile_service.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_chart_provider.g.dart';

/// Notifier for selected category filters on the monthly chart.
@riverpod
class SelectedCategoryFiltersStateNotifier extends _$SelectedCategoryFiltersStateNotifier {
  @override
  Set<String> build() => {};

  /// Toggles a category filter on/off.
  void toggle(String categoryId) {
    if (state.contains(categoryId)) {
      state = {...state}..remove(categoryId);
    } else {
      state = {...state, categoryId};
    }
  }

  /// Clears all filters.
  void clear() {
    state = {};
  }
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
  final filters = ref.watch(selectedCategoryFiltersStateProvider);
  final allData = await ref.watch(monthlyChartDataProvider.future);

  if (filters.isEmpty) {
    return allData;
  }

  return allData.where((d) => d.activityCategoryId != null && filters.contains(d.activityCategoryId)).toList();
}
