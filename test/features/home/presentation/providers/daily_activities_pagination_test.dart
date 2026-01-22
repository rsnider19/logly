import 'package:flutter_test/flutter_test.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';

import '../../helpers/home_test_helpers.dart';

void main() {
  // These tests verify the pagination date calculations
  // independently of the provider implementation

  const initialDays = 30;
  const daysToLoad = 30;

  group('Pagination Date Calculations', () {
    group('Initial Load', () {
      test('calculates correct date range for 30 days', () {
        // Arrange
        final today = DateTime(2025, 1, 22);

        // Act
        final range = calculateInitialDateRange(today: today, initialDays: initialDays);

        // Assert
        expect(range.endDate, equals(DateTime(2025, 1, 22)));
        expect(range.startDate, equals(DateTime(2024, 12, 24)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });

      test('initial load oldestLoadedDate should be the startDate', () {
        // Arrange
        final today = DateTime(2025, 1, 22);
        final range = calculateInitialDateRange(today: today, initialDays: initialDays);

        // Assert
        // oldestLoadedDate = startDate = the oldest date in the range
        expect(range.startDate, equals(DateTime(2024, 12, 24)));
      });
    });

    group('LoadMore', () {
      test('first loadMore starts from day before oldest loaded date', () {
        // Arrange
        // After initial load, oldestLoadedDate = 12/24/2024
        final oldestLoadedDate = DateTime(2024, 12, 24);

        // Act
        final range = calculateLoadMoreDateRange(
          oldestLoadedDate: oldestLoadedDate,
          daysToLoad: daysToLoad,
        );

        // Assert
        expect(range.endDate, equals(DateTime(2024, 12, 23)));
        expect(range.startDate, equals(DateTime(2024, 11, 24)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });

      test('second loadMore continues from the new oldest loaded date', () {
        // Arrange
        // After first loadMore, oldestLoadedDate = 11/24/2024
        final oldestLoadedDate = DateTime(2024, 11, 24);

        // Act
        final range = calculateLoadMoreDateRange(
          oldestLoadedDate: oldestLoadedDate,
          daysToLoad: daysToLoad,
        );

        // Assert
        expect(range.endDate, equals(DateTime(2024, 11, 23)));
        expect(range.startDate, equals(DateTime(2024, 10, 25)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });

      test('loadMore ranges are contiguous with no gaps', () {
        // Arrange
        final today = DateTime(2025, 1, 22);

        // Simulate multiple loadMore operations
        final initialRange = calculateInitialDateRange(today: today, initialDays: initialDays);
        final allDates = <DateTime>[];

        // Add initial dates
        var current = initialRange.startDate;
        while (!current.isAfter(initialRange.endDate)) {
          allDates.add(current);
          current = DateTime(current.year, current.month, current.day + 1);
        }

        // First loadMore
        final loadMore1Range = calculateLoadMoreDateRange(
          oldestLoadedDate: initialRange.startDate,
          daysToLoad: daysToLoad,
        );
        current = loadMore1Range.startDate;
        while (!current.isAfter(loadMore1Range.endDate)) {
          allDates.add(current);
          current = DateTime(current.year, current.month, current.day + 1);
        }

        // Second loadMore
        final loadMore2Range = calculateLoadMoreDateRange(
          oldestLoadedDate: loadMore1Range.startDate,
          daysToLoad: daysToLoad,
        );
        current = loadMore2Range.startDate;
        while (!current.isAfter(loadMore2Range.endDate)) {
          allDates.add(current);
          current = DateTime(current.year, current.month, current.day + 1);
        }

        // Assert
        expect(areDatesContiguous(allDates), isTrue);
        final gaps = findGaps(allDates);
        expect(gaps, isEmpty, reason: 'No gaps between ranges: $gaps');
      });

      test('loadMore does not create overlaps with existing dates', () {
        // Arrange
        final today = DateTime(2025, 1, 22);
        final initialRange = calculateInitialDateRange(today: today, initialDays: initialDays);
        final loadMoreRange = calculateLoadMoreDateRange(
          oldestLoadedDate: initialRange.startDate,
          daysToLoad: daysToLoad,
        );

        // Assert
        // The loadMore endDate should be exactly 1 day before the initial startDate
        expect(
          loadMoreRange.endDate,
          equals(
            DateTime(
              initialRange.startDate.year,
              initialRange.startDate.month,
              initialRange.startDate.day - 1,
            ),
          ),
        );

        // There should be no overlap
        expect(loadMoreRange.endDate.isBefore(initialRange.startDate), isTrue);
      });
    });

    group('Date Calculation Edge Cases', () {
      test('handles February correctly', () {
        // Arrange - test around February
        final date = DateTime(2025, 3, 1);
        final range = calculateInitialDateRange(today: date, initialDays: 30);

        // Assert
        expect(range.startDate, equals(DateTime(2025, 1, 31)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });

      test('handles leap year February', () {
        // Arrange - 2024 is a leap year
        final date = DateTime(2024, 3, 1);
        final range = calculateInitialDateRange(today: date, initialDays: 30);

        // Assert - Feb has 29 days in 2024
        expect(range.startDate, equals(DateTime(2024, 2, 1)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });

      test('handles end of year correctly', () {
        // Arrange
        final date = DateTime(2025, 1, 15);
        final range = calculateInitialDateRange(today: date, initialDays: 30);

        // Assert - should span into December 2024
        expect(range.startDate, equals(DateTime(2024, 12, 17)));
        expect(countDaysInRange(range.startDate, range.endDate), equals(30));
      });
    });

    group('Combined Ranges Integration', () {
      test('three loadMore operations produce 120 contiguous days', () {
        // Arrange
        final today = DateTime(2025, 1, 22);
        final summaries = <DailyActivitySummary>[];

        // Initial load
        var initialRange = calculateInitialDateRange(today: today, initialDays: initialDays);
        var current = initialRange.startDate;
        while (!current.isAfter(initialRange.endDate)) {
          summaries.add(DailyActivitySummary(activityDate: current, activityCount: 0));
          current = DateTime(current.year, current.month, current.day + 1);
        }
        var oldestDate = initialRange.startDate;

        // Three loadMore operations
        for (var i = 0; i < 3; i++) {
          final range = calculateLoadMoreDateRange(
            oldestLoadedDate: oldestDate,
            daysToLoad: daysToLoad,
          );
          current = range.startDate;
          while (!current.isAfter(range.endDate)) {
            summaries.add(DailyActivitySummary(activityDate: current, activityCount: 0));
            current = DateTime(current.year, current.month, current.day + 1);
          }
          oldestDate = range.startDate;
        }

        // Assert
        expect(summaries.length, equals(120)); // 30 * 4 = 120

        final dates = extractDates(summaries);
        expect(areDatesContiguous(dates), isTrue);
        expect(findGaps(dates), isEmpty);
      });

      test('dates between loadMore boundaries are present', () {
        // Arrange
        final today = DateTime(2025, 1, 22);

        // Initial: 01/22 to 12/24 (oldest = 12/24)
        final initialRange = calculateInitialDateRange(today: today, initialDays: initialDays);

        // LoadMore 1: 12/23 to 11/24 (oldest = 11/24)
        final loadMore1Range = calculateLoadMoreDateRange(
          oldestLoadedDate: initialRange.startDate,
          daysToLoad: daysToLoad,
        );

        // LoadMore 2: 11/23 to 10/25 (oldest = 10/25)
        final loadMore2Range = calculateLoadMoreDateRange(
          oldestLoadedDate: loadMore1Range.startDate,
          daysToLoad: daysToLoad,
        );

        // Assert - boundary dates should connect properly
        // Initial ends at 12/24, loadMore1 starts at 12/23 (1 day before)
        expect(
          loadMore1Range.endDate,
          equals(DateTime(initialRange.startDate.year, initialRange.startDate.month,
              initialRange.startDate.day - 1)),
        );

        // LoadMore1 ends at 11/24, loadMore2 starts at 11/23 (1 day before)
        expect(
          loadMore2Range.endDate,
          equals(DateTime(loadMore1Range.startDate.year, loadMore1Range.startDate.month,
              loadMore1Range.startDate.day - 1)),
        );

        // Verify 11/23 is included in loadMore2
        expect(loadMore2Range.endDate, equals(DateTime(2024, 11, 23)));

        // Verify 11/24 is included in loadMore1
        expect(loadMore1Range.startDate, equals(DateTime(2024, 11, 24)));
      });
    });
  });
}
