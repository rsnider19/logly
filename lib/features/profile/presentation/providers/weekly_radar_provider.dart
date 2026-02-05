import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/domain/weekly_category_data.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weekly_radar_provider.g.dart';

/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from [dowCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Extracts the appropriate column and converts
/// Postgres dow (0=Sun) to ISO 8601 (1=Mon, 7=Sun).
@riverpod
Future<List<WeeklyCategoryData>> weeklyRadarData(Ref ref) async {
  final period = ref.watch(globalTimePeriodProvider);
  final data = await ref.watch(dowCategoryCountsProvider.future);

  return data.map((e) {
    final count = switch (period) {
      TimePeriod.oneWeek => e.pastWeek,
      TimePeriod.oneMonth => e.pastMonth,
      TimePeriod.oneYear => e.pastYear,
      TimePeriod.all => e.allTime,
    };
    // Convert Postgres dow (0=Sun) to ISO 8601 (1=Mon, 7=Sun)
    final isoDow = e.dayOfWeek == 0 ? 7 : e.dayOfWeek;
    return WeeklyCategoryData(
      dayOfWeek: isoDow,
      activityCount: count,
      activityCategoryId: e.activityCategoryId,
    );
  }).toList();
}

/// Provides filtered weekly radar data based on global category filters.
@riverpod
Future<List<WeeklyCategoryData>> filteredWeeklyRadarData(Ref ref) async {
  // Watch all futures before any async gap to avoid disposal between awaits
  final effectiveFiltersFuture = ref.watch(effectiveGlobalCategoryFiltersProvider.future);
  final allDataFuture = ref.watch(weeklyRadarDataProvider.future);
  final categoriesFuture = ref.watch(activityCategoriesProvider.future);

  final (effectiveFilters, allData, categories) = await (effectiveFiltersFuture, allDataFuture, categoriesFuture).wait;

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
