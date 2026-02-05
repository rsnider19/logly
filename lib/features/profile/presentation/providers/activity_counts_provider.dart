import 'package:logly/features/profile/data/daily_activity_repository.dart';
import 'package:logly/features/profile/domain/daily_category_counts.dart';
import 'package:logly/features/profile/domain/dow_category_counts.dart';
import 'package:logly/features/profile/domain/period_category_counts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_counts_provider.g.dart';

/// Period category counts - single source for summary chart.
///
/// All derived providers for summary chart watch this provider.
/// Invalidating this provider refreshes all dependents.
@Riverpod(keepAlive: true)
Future<List<PeriodCategoryCounts>> periodCategoryCounts(Ref ref) async {
  final repository = ref.watch(dailyActivityRepositoryProvider);
  return repository.getPeriodCategoryCounts();
}

/// Daily category counts - source for contribution graph and monthly chart.
///
/// Fetches last 365 days of data. Invalidating this provider refreshes
/// both contribution graph and monthly chart.
@Riverpod(keepAlive: true)
Future<List<DailyCategoryCounts>> dailyCategoryCounts(Ref ref) async {
  final repository = ref.watch(dailyActivityRepositoryProvider);
  return repository.getDailyCategoryCounts(daysAgo: 365);
}

/// Day-of-week category counts - source for radar chart.
///
/// Pre-aggregated by day-of-week with counts for all time periods.
@Riverpod(keepAlive: true)
Future<List<DowCategoryCounts>> dowCategoryCounts(Ref ref) async {
  final repository = ref.watch(dailyActivityRepositoryProvider);
  return repository.getDowCategoryCounts();
}
