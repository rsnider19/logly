import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consistency_provider.g.dart';

/// Provides consistency score (% of days active in last 30 days).
///
/// Derives from [activityCountsByDateProvider] single source of truth.
@riverpod
Future<int> consistencyScore(Ref ref) async {
  final data = await ref.watch(activityCountsByDateProvider.future);

  final now = DateTime.now();
  final thirtyDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 30));

  final activeDays = data
      .where((e) => !e.activityDate.isBefore(thirtyDaysAgo))
      .map((e) => DateTime(e.activityDate.year, e.activityDate.month, e.activityDate.day))
      .toSet()
      .length;

  return (activeDays / 30 * 100).round();
}
