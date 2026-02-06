import 'package:dartx/dartx.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/daily_category_counts.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_chart_provider.g.dart';

/// Provides chart data aggregated by the global time period.
///
/// - `1W`: 7 day-level entries (last 7 days)
/// - `1M`: 4-5 week-level entries (last 30 days grouped by week-start Monday)
/// - `1Y` / `All`: 12 month-level entries (last 12 months)
///
/// Reuses [MonthlyCategoryData] model — `activityMonth` represents the period start date.
@riverpod
Future<List<MonthlyCategoryData>> monthlyChartData(Ref ref) async {
  final period = ref.watch(globalTimePeriodProvider);
  final rawData = await ref.watch(dailyCategoryCountsProvider.future);

  return switch (period) {
    TimePeriod.oneWeek => _aggregateByDay(rawData, days: 7),
    TimePeriod.oneMonth => _aggregateByDay(rawData, days: 30),
    TimePeriod.oneYear || TimePeriod.all => _aggregateByMonth(rawData),
  };
}

/// Provides filtered chart data based on global category filters.
@riverpod
Future<List<MonthlyCategoryData>> filteredMonthlyChartData(Ref ref) async {
  // Watch all futures before any async gap to avoid disposal between awaits
  final effectiveFiltersFuture = ref.watch(effectiveGlobalCategoryFiltersProvider.future);
  final allDataFuture = ref.watch(monthlyChartDataProvider.future);
  final categoriesFuture = ref.watch(activityCategoriesProvider.future);

  final (effectiveFilters, allData, categories) = await (effectiveFiltersFuture, allDataFuture, categoriesFuture).wait;

  // If all categories are selected, return all data (optimization)
  if (effectiveFilters.length == categories.length) {
    return allData;
  }

  return allData.where((d) => d.activityCategoryId != null && effectiveFilters.contains(d.activityCategoryId)).toList();
}

/// Aggregates daily category counts by day for the specified number of days.
List<MonthlyCategoryData> _aggregateByDay(List<DailyCategoryCounts> rawData, {required int days}) {
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

  final dailyTotals = <(DateTime, String), int>{};
  for (final day in rawData) {
    final dateKey = DateTime(day.activityDate.year, day.activityDate.month, day.activityDate.day);
    if (dateKey.isBefore(startDate)) continue;

    for (final cat in day.categories) {
      final key = (dateKey, cat.activityCategoryId);
      dailyTotals.update(key, (v) => v + cat.count, ifAbsent: () => cat.count);
    }
  }

  return dailyTotals.entries
      .map((e) {
        final (date, categoryId) = e.key;
        return MonthlyCategoryData(
          activityMonth: date,
          activityCount: e.value,
          activityCategoryId: categoryId,
        );
      })
      .sortedByDescending((a) => a.activityMonth);
}

/// Aggregates daily category counts by month for last 12 months.
List<MonthlyCategoryData> _aggregateByMonth(List<DailyCategoryCounts> rawData) {
  final now = DateTime.now();
  final startDate = DateTime(now.year - 1, now.month);

  // Filter to last 12 months and aggregate by month + category
  final monthlyTotals = <(int, int, String), int>{};
  for (final day in rawData) {
    if (day.activityDate.isBefore(startDate)) continue;

    for (final cat in day.categories) {
      final key = (day.activityDate.year, day.activityDate.month, cat.activityCategoryId);
      monthlyTotals.update(key, (v) => v + cat.count, ifAbsent: () => cat.count);
    }
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
