import 'package:logly/features/profile/domain/activity_count_by_date.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contribution_provider.g.dart';

/// Provides contribution data (activity counts by day) for the last year.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by date for the contribution graph.
@riverpod
Future<Map<DateTime, int>> contributionData(Ref ref) async {
  final rawData = await ref.watch(activityCountsByDateProvider.future);
  return _aggregateByDate(rawData);
}

/// Aggregates raw activity counts by date for the last year.
Map<DateTime, int> _aggregateByDate(List<ActivityCountByDate> rawData) {
  final now = DateTime.now();
  final startDate = DateTime(now.year - 1, now.month, now.day);

  final dailyTotals = <DateTime, int>{};
  for (final item in rawData) {
    if (item.activityDate.isBefore(startDate)) continue;

    final dateKey = DateTime(
      item.activityDate.year,
      item.activityDate.month,
      item.activityDate.day,
    );
    dailyTotals.update(dateKey, (v) => v + item.count, ifAbsent: () => item.count);
  }

  return dailyTotals;
}
