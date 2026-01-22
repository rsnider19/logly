import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/home/application/home_service.dart';
import 'package:logly/features/home/data/daily_activities_repository.dart';
import 'package:logly/features/home/data/trending_repository.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:mocktail/mocktail.dart';

// MARK: - Mocks

class MockDailyActivitiesRepository extends Mock implements DailyActivitiesRepository {}

class MockTrendingRepository extends Mock implements TrendingRepository {}

class MockLoggerService extends Mock implements LoggerService {}

class MockHomeService extends Mock implements HomeService {}

// MARK: - Test Data Factories

DailyActivitySummary fakeDailyActivitySummary({
  DateTime? activityDate,
  int? activityCount,
}) {
  return DailyActivitySummary(
    activityDate: activityDate ?? DateTime.now(),
    activityCount: activityCount ?? 0,
  );
}

List<DailyActivitySummary> generateSummariesForDateRange({
  required DateTime startDate,
  required DateTime endDate,
  int activityCount = 1,
}) {
  final summaries = <DailyActivitySummary>[];
  var current = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);

  while (!current.isAfter(end)) {
    summaries.add(DailyActivitySummary(
      activityDate: current,
      activityCount: activityCount,
    ));
    current = DateTime(current.year, current.month, current.day + 1);
  }

  return summaries;
}

// MARK: - Mock Setup Helpers

void setupMockLogger(MockLoggerService mockLogger) {
  when(() => mockLogger.i(any())).thenReturn(null);
  when(() => mockLogger.d(any())).thenReturn(null);
  when(() => mockLogger.w(any(), any(), any())).thenReturn(null);
  when(() => mockLogger.e(any(), any(), any())).thenReturn(null);
}

// MARK: - Date Calculation Helpers

/// Calculates the expected date range for the initial load.
({DateTime startDate, DateTime endDate}) calculateInitialDateRange({
  required DateTime today,
  required int initialDays,
}) {
  final endDate = DateTime(today.year, today.month, today.day);
  final startDate = DateTime(endDate.year, endDate.month, endDate.day - (initialDays - 1));
  return (startDate: startDate, endDate: endDate);
}

/// Calculates the expected date range for a loadMore operation.
({DateTime startDate, DateTime endDate}) calculateLoadMoreDateRange({
  required DateTime oldestLoadedDate,
  required int daysToLoad,
}) {
  final newEndDate = DateTime(
    oldestLoadedDate.year,
    oldestLoadedDate.month,
    oldestLoadedDate.day - 1,
  );
  final newStartDate = DateTime(
    newEndDate.year,
    newEndDate.month,
    newEndDate.day - (daysToLoad - 1),
  );
  return (startDate: newStartDate, endDate: newEndDate);
}

/// Counts the number of days in a date range (inclusive).
int countDaysInRange(DateTime startDate, DateTime endDate) {
  final start = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);
  return end.difference(start).inDays + 1;
}

/// Extracts just the dates from a list of summaries for easier comparison.
List<DateTime> extractDates(List<DailyActivitySummary> summaries) {
  return summaries
      .map((s) => DateTime(s.activityDate.year, s.activityDate.month, s.activityDate.day))
      .toList();
}

/// Checks if a list of dates is contiguous (no gaps).
bool areDatesContiguous(List<DateTime> dates) {
  if (dates.length <= 1) return true;

  // Sort descending (most recent first)
  final sorted = List<DateTime>.from(dates)..sort((a, b) => b.compareTo(a));

  for (var i = 0; i < sorted.length - 1; i++) {
    final current = sorted[i];
    final next = sorted[i + 1];
    final diff = current.difference(next).inDays;
    if (diff != 1) {
      return false;
    }
  }
  return true;
}

/// Finds gaps in a list of dates and returns the missing dates.
List<DateTime> findGaps(List<DateTime> dates) {
  if (dates.length <= 1) return [];

  final sorted = List<DateTime>.from(dates)..sort((a, b) => b.compareTo(a));
  final gaps = <DateTime>[];

  for (var i = 0; i < sorted.length - 1; i++) {
    final current = sorted[i];
    final next = sorted[i + 1];
    final diff = current.difference(next).inDays;

    // If there's a gap of more than 1 day, add the missing dates
    if (diff > 1) {
      for (var j = 1; j < diff; j++) {
        gaps.add(DateTime(current.year, current.month, current.day - j));
      }
    }
  }

  return gaps;
}
