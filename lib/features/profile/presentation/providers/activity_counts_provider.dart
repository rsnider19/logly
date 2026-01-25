import 'package:logly/features/profile/data/daily_activity_repository.dart';
import 'package:logly/features/profile/domain/activity_count_by_date.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_counts_provider.g.dart';

/// Raw activity counts by date - single source of truth.
///
/// All derived providers (monthly chart, weekly radar, contribution graph)
/// watch this provider. Invalidating this provider refreshes all dependents.
@Riverpod(keepAlive: true)
Future<List<ActivityCountByDate>> activityCountsByDate(Ref ref) async {
  final repository = ref.watch(dailyActivityRepositoryProvider);
  return repository.getAllActivityCounts();
}
