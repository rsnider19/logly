import 'package:logly/features/profile/application/profile_service.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'summary_provider.g.dart';

/// Cached summary data for all time periods.
typedef AllPeriodSummaries = Map<TimePeriod, List<CategorySummary>>;

/// Notifier for the selected time period filter.
@riverpod
class SelectedTimePeriodStateNotifier extends _$SelectedTimePeriodStateNotifier {
  @override
  TimePeriod build() => TimePeriod.all;

  /// Updates the selected time period.
  void select(TimePeriod period) {
    state = period;
  }
}

/// Fetches and caches category summary data for all time periods.
@Riverpod(keepAlive: true)
Future<AllPeriodSummaries> allPeriodSummaries(Ref ref) async {
  final service = ref.watch(profileServiceProvider);

  // Fetch all time periods in parallel
  final results = await Future.wait([
    service.getCategorySummary(TimePeriod.oneWeek),
    service.getCategorySummary(TimePeriod.oneMonth),
    service.getCategorySummary(TimePeriod.oneYear),
    service.getCategorySummary(TimePeriod.all),
  ]);

  return {
    TimePeriod.oneWeek: results[0],
    TimePeriod.oneMonth: results[1],
    TimePeriod.oneYear: results[2],
    TimePeriod.all: results[3],
  };
}

/// Provides category summary data for the selected time period.
/// Uses cached data from allPeriodSummaries.
@riverpod
Future<List<CategorySummary>> categorySummary(Ref ref) async {
  final period = ref.watch(selectedTimePeriodStateProvider);
  final allSummaries = await ref.watch(allPeriodSummariesProvider.future);
  return allSummaries[period] ?? [];
}
