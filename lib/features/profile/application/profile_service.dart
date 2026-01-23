import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/data/daily_activity_repository.dart';
import 'package:logly/features/profile/data/streak_repository.dart';
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
    this._dailyActivityRepository,
    this._logger,
  );

  final StreakRepository _streakRepository;
  final DailyActivityRepository _dailyActivityRepository;
  final LoggerService _logger;

  /// Fetches the user's streak data.
  Future<StreakData> getStreak() async {
    _logger.d('Fetching streak data');
    return _streakRepository.getStreak();
  }

  /// Fetches category summary for a given time period.
  Future<List<CategorySummary>> getCategorySummary(TimePeriod period) async {
    _logger.d('Fetching category summary for period: $period');
    return _dailyActivityRepository.getCategorySummary(period);
  }

  /// Fetches contribution data for the last 365 days.
  ///
  /// Returns a map of date to activity count.
  Future<Map<DateTime, int>> getContributionData() async {
    final endDate = DateTime.now();
    final startDate = DateTime(endDate.year - 1, endDate.month, endDate.day);

    _logger.d('Fetching contribution data from $startDate to $endDate');

    final data = await _dailyActivityRepository.getDailyTotals(
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
    return _dailyActivityRepository.getMonthlyData();
  }
}

/// Provides the profile service instance.
@Riverpod(keepAlive: true)
ProfileService profileService(Ref ref) {
  return ProfileService(
    ref.watch(streakRepositoryProvider),
    ref.watch(dailyActivityRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
