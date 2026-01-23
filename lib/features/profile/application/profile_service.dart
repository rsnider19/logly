import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/data/contribution_repository.dart';
import 'package:logly/features/profile/data/streak_repository.dart';
import 'package:logly/features/profile/data/summary_repository.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/streak_data.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_service.g.dart';

/// Service for coordinating profile screen operations.
///
/// Handles business logic for streak data, category summaries,
/// contribution graphs, and monthly charts.
class ProfileService {
  ProfileService(
    this._streakRepository,
    this._summaryRepository,
    this._contributionRepository,
    this._logger,
  );

  final StreakRepository _streakRepository;
  final SummaryRepository _summaryRepository;
  final ContributionRepository _contributionRepository;
  final LoggerService _logger;

  /// Fetches the user's streak data.
  Future<StreakData> getStreak() async {
    _logger.d('Fetching streak data');
    return _streakRepository.getStreak();
  }

  /// Fetches category summary for a given time period.
  Future<List<CategorySummary>> getCategorySummary(TimePeriod period) async {
    final dateRange = _getDateRangeForPeriod(period);
    _logger.d('Fetching category summary for period: $period');
    return _summaryRepository.getCategorySummary(
      startDate: dateRange.$1,
      endDate: dateRange.$2,
    );
  }

  /// Fetches contribution data for the last 365 days.
  ///
  /// Returns a map of date to activity count.
  Future<Map<DateTime, int>> getContributionData() async {
    final endDate = DateTime.now();
    final startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);

    _logger.d('Fetching contribution data from $startDate to $endDate');

    final data = await _contributionRepository.getDayActivityCounts(
      startDate: startDate,
      endDate: endDate,
    );

    return Map.fromEntries(
      data.map(
        (e) => MapEntry(
          DateTime(e.date.year, e.date.month, e.date.day),
          e.count,
        ),
      ),
    );
  }

  /// Fetches monthly category data for the stacked bar chart.
  ///
  /// If categoryFilters is provided, filters to those categories.
  Future<List<MonthlyCategoryData>> getMonthlyData({
    Set<String>? categoryFilters,
  }) async {
    _logger.d('Fetching monthly category data');
    // The RPC returns all data; filtering happens in the provider/UI
    return _contributionRepository.getMonthlyCategoryData();
  }

  /// Converts a TimePeriod to a start/end date tuple.
  ///
  /// Returns (startDate, endDate) where null means no filter.
  (DateTime?, DateTime?) _getDateRangeForPeriod(TimePeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case TimePeriod.oneWeek:
        return (today.subtract(const Duration(days: 7)), today);
      case TimePeriod.oneMonth:
        return (DateTime(today.year, today.month - 1, today.day), today);
      case TimePeriod.oneYear:
        return (DateTime(today.year - 1, today.month, today.day), today);
      case TimePeriod.all:
        return (null, null);
    }
  }
}

/// Provides the profile service instance.
@Riverpod(keepAlive: true)
ProfileService profileService(Ref ref) {
  return ProfileService(
    ref.watch(streakRepositoryProvider),
    ref.watch(summaryRepositoryProvider),
    ref.watch(contributionRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
