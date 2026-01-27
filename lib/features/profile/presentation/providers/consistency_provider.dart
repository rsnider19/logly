import 'package:dartx/dartx.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consistency_provider.g.dart';

/// Provides consistency score (% of days active in last 30 days).
///
/// Derives from [activityCountsByDateProvider] single source of truth.
@riverpod
Future<int> consistencyScore(Ref ref) async {
  final data = await ref.watch(activityCountsByDateProvider.future);
  final profile = await ref.watch(profileDataProvider.future);

  final thirtyDaysAgo = DateTime.now().date.subtract(const Duration(days: 30));
  final userJoinedDate = profile.createdAt.date;

  final startDate = userJoinedDate.isBefore(thirtyDaysAgo) ? thirtyDaysAgo : userJoinedDate;
  final daysInPeriod = DateTime.now().date.difference(startDate).inDays.coerceAtLeast(1) + 1;

  final activeDays = data
      .where((e) => !e.activityDate.isBefore(startDate))
      .map((e) => e.activityDate.date)
      .toSet()
      .length;

  return (activeDays / daysInPeriod * 100).round();
}
