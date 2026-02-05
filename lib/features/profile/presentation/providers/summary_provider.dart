import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'summary_provider.g.dart';

/// Provides (categoryId, count) pairs for the selected time period.
///
/// Derives from [periodCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Simply extracts the appropriate column.
@Riverpod(keepAlive: true)
Future<Map<String, int>> categorySummary(Ref ref) async {
  final period = ref.watch(globalTimePeriodProvider);
  final data = await ref.watch(periodCategoryCountsProvider.future);

  return Map.fromEntries(data.map((e) {
    final count = switch (period) {
      TimePeriod.oneWeek => e.pastWeek,
      TimePeriod.oneMonth => e.pastMonth,
      TimePeriod.oneYear => e.pastYear,
      TimePeriod.all => e.allTime,
    };
    return MapEntry(e.activityCategoryId, count);
  }));
}
