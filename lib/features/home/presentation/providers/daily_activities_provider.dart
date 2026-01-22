import 'package:logly/features/home/application/home_service.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_activities_provider.g.dart';

/// State for the daily activities list with pagination support.
class DailyActivitiesState {
  const DailyActivitiesState({
    required this.summaries,
    required this.oldestLoadedDate,
    required this.newestLoadedDate,
    this.isLoadingMore = false,
    this.hasMoreData = true,
  });

  final List<DailyActivitySummary> summaries;
  final DateTime oldestLoadedDate;
  final DateTime newestLoadedDate;
  final bool isLoadingMore;
  final bool hasMoreData;

  DailyActivitiesState copyWith({
    List<DailyActivitySummary>? summaries,
    DateTime? oldestLoadedDate,
    DateTime? newestLoadedDate,
    bool? isLoadingMore,
    bool? hasMoreData,
  }) {
    return DailyActivitiesState(
      summaries: summaries ?? this.summaries,
      oldestLoadedDate: oldestLoadedDate ?? this.oldestLoadedDate,
      newestLoadedDate: newestLoadedDate ?? this.newestLoadedDate,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

/// Notifier for managing daily activities with infinite scroll pagination.
@riverpod
class DailyActivitiesStateNotifier extends _$DailyActivitiesStateNotifier {
  static const int _daysToLoad = 30;
  static const int _initialDays = 30;

  @override
  Future<DailyActivitiesState> build() async {
    final service = ref.watch(homeServiceProvider);

    final today = DateTime.now();
    final endDate = DateTime(today.year, today.month, today.day);
    // Use DateTime constructor for proper calendar day arithmetic (handles DST correctly)
    final startDate = DateTime(endDate.year, endDate.month, endDate.day - (_initialDays - 1));

    final summaries = await service.getDailyActivities(
      startDate: startDate,
      endDate: endDate,
    );

    final filledSummaries = service.fillDateRange(
      startDate: startDate,
      endDate: endDate,
      summaries: summaries,
    );

    return DailyActivitiesState(
      summaries: filledSummaries,
      oldestLoadedDate: startDate,
      newestLoadedDate: endDate,
    );
  }

  /// Loads more days into the past.
  Future<void> loadMore() async {
    final currentStateValue = state;
    if (currentStateValue is! AsyncData<DailyActivitiesState>) {
      return;
    }

    final currentState = currentStateValue.value;
    if (currentState.isLoadingMore || !currentState.hasMoreData) {
      return;
    }

    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    try {
      final service = ref.read(homeServiceProvider);

      // Normalize oldest date to midnight to avoid DST issues
      final oldest = currentState.oldestLoadedDate;
      final oldestNormalized = DateTime(oldest.year, oldest.month, oldest.day);

      // Use DateTime constructor for proper calendar day arithmetic (handles DST correctly)
      // Start from the day BEFORE the oldest loaded date
      final newEndDate = DateTime(
        oldestNormalized.year,
        oldestNormalized.month,
        oldestNormalized.day - 1,
      );
      // Go back _daysToLoad - 1 more days (for _daysToLoad total days)
      final newStartDate = DateTime(
        newEndDate.year,
        newEndDate.month,
        newEndDate.day - (_daysToLoad - 1),
      );

      final moreSummaries = await service.getDailyActivities(
        startDate: newStartDate,
        endDate: newEndDate,
      );

      final filledSummaries = service.fillDateRange(
        startDate: newStartDate,
        endDate: newEndDate,
        summaries: moreSummaries,
      );

      // Combine with existing summaries (new ones go at the end since they're older)
      final combined = [...currentState.summaries, ...filledSummaries];

      state = AsyncData(currentState.copyWith(
        summaries: combined,
        oldestLoadedDate: newStartDate,
        isLoadingMore: false,
      ));
    } catch (e, st) {
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
      // Re-throw to let error handlers deal with it
      Error.throwWithStackTrace(e, st);
    }
  }

  /// Refreshes the data, reloading from the current date range.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
