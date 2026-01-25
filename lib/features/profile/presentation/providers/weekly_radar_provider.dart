import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/activity_count_by_date.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/domain/weekly_category_data.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weekly_radar_provider.g.dart';

/// Independent time period selector for radar chart (separate from SummaryCard).
@riverpod
class SelectedRadarTimePeriodStateNotifier extends _$SelectedRadarTimePeriodStateNotifier {
  @override
  TimePeriod build() => TimePeriod.all;

  /// Updates the selected time period for the radar chart.
  void select(TimePeriod period) => state = period;
}

/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// filters by the radar's selected time period.
@riverpod
Future<List<WeeklyCategoryData>> weeklyRadarData(Ref ref) async {
  final period = ref.watch(selectedRadarTimePeriodStateProvider);
  final rawData = await ref.watch(activityCountsByDateProvider.future);
  return _aggregateByDayOfWeek(rawData, period);
}

/// Provides filtered weekly radar data based on selected category filters.
///
/// Reuses the same category filter state as the monthly chart.
@riverpod
Future<List<WeeklyCategoryData>> filteredWeeklyRadarData(Ref ref) async {
  final effectiveFilters = await ref.watch(effectiveSelectedFiltersProvider.future);
  final allData = await ref.watch(weeklyRadarDataProvider.future);
  final categories = await ref.watch(categoriesProvider.future);

  // If all categories are selected, return all data
  if (effectiveFilters.length == categories.length) {
    return allData;
  }

  return allData.where((d) => d.activityCategoryId != null && effectiveFilters.contains(d.activityCategoryId)).toList();
}

/// Provides normalized radar data (0-100%) per category.
///
/// Returns a map: categoryId -> [7 values for Mon-Sun normalized to 0-100].
/// Normalization is based on the day with highest total activity across all categories.
@riverpod
Future<Map<String, List<double>>> normalizedRadarData(Ref ref) async {
  final filteredData = await ref.watch(filteredWeeklyRadarDataProvider.future);

  if (filteredData.isEmpty) {
    return {};
  }

  // Find max count per day across all categories (for normalization)
  final dayTotals = <int, int>{};
  for (final item in filteredData) {
    dayTotals.update(
      item.dayOfWeek,
      (v) => v + item.activityCount,
      ifAbsent: () => item.activityCount,
    );
  }
  final maxDayTotal = dayTotals.values.fold(0, (a, b) => a > b ? a : b);

  if (maxDayTotal == 0) {
    return {};
  }

  // Group by category
  final categoryDayData = <String, Map<int, int>>{};
  for (final item in filteredData) {
    if (item.activityCategoryId == null) continue;
    categoryDayData.putIfAbsent(item.activityCategoryId!, () => {});
    categoryDayData[item.activityCategoryId!]![item.dayOfWeek] = item.activityCount;
  }

  // Normalize each category's values (0-100% based on max day total)
  final result = <String, List<double>>{};
  for (final entry in categoryDayData.entries) {
    final values = List.generate(7, (i) {
      final dayOfWeek = i + 1; // 1=Mon, 7=Sun
      final count = entry.value[dayOfWeek] ?? 0;
      return (count / maxDayTotal) * 100;
    });
    result[entry.key] = values;
  }

  return result;
}

/// Aggregates raw activity counts by day of week and category.
List<WeeklyCategoryData> _aggregateByDayOfWeek(List<ActivityCountByDate> rawData, TimePeriod period) {
  final now = DateTime.now();
  final startDate = switch (period) {
    TimePeriod.oneWeek => now.subtract(const Duration(days: 6)),
    TimePeriod.oneMonth => now.subtract(const Duration(days: 29)),
    TimePeriod.oneYear => now.subtract(const Duration(days: 364)),
    TimePeriod.all => DateTime(2000), // Far past date for "all time"
  };

  // Filter by period and aggregate by (dayOfWeek, categoryId)
  final weeklyTotals = <(int, String), int>{};
  for (final item in rawData) {
    if (item.activityDate.isBefore(startDate)) continue;

    // DateTime.weekday is already ISO 8601 (1=Monday, 7=Sunday)
    final dayOfWeek = item.activityDate.weekday;
    final key = (dayOfWeek, item.activityCategoryId);
    weeklyTotals.update(key, (v) => v + item.count, ifAbsent: () => item.count);
  }

  return weeklyTotals.entries.map((e) {
    final (dayOfWeek, categoryId) = e.key;
    return WeeklyCategoryData(
      dayOfWeek: dayOfWeek,
      activityCount: e.value,
      activityCategoryId: categoryId,
    );
  }).toList();
}
