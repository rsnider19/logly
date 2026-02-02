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
  // Watch all futures before any async gap to avoid disposal between awaits
  final dataFuture = ref.watch(activityCountsByDateProvider.future);
  final profileFuture = ref.watch(profileDataProvider.future);
  final (data, profile) = await (dataFuture, profileFuture).wait;

  final thirtyDaysAgo = DateTime.now().date.subtract(const Duration(days: 30));
  final activeDays = data
      .where((e) => !e.activityDate.isBefore(thirtyDaysAgo))
      .map((e) => e.activityDate.date)
      .toSet()
      .length;

  return (activeDays / 30 * 100).round();
}
