import 'package:flutter_test/flutter_test.dart';
import 'package:logly/features/home/application/home_service.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/home_test_helpers.dart';

void main() {
  late HomeService service;
  late MockDailyActivitiesRepository mockDailyActivitiesRepository;
  late MockTrendingRepository mockTrendingRepository;
  late MockLoggerService mockLogger;

  setUp(() {
    mockDailyActivitiesRepository = MockDailyActivitiesRepository();
    mockTrendingRepository = MockTrendingRepository();
    mockLogger = MockLoggerService();

    setupMockLogger(mockLogger);

    service = HomeService(
      mockDailyActivitiesRepository,
      mockTrendingRepository,
      mockLogger,
    );
  });

  group('HomeService', () {
    group('fillDateRange', () {
      test('generates correct number of days for a 30-day range', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2024, 12, 24);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        expect(result.length, equals(30));
      });

      test('first date in result is the endDate (descending order)', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2024, 12, 24);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        expect(result.first.activityDate, equals(endDate));
      });

      test('last date in result is the startDate (descending order)', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2024, 12, 24);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        expect(result.last.activityDate, equals(startDate));
      });

      test('produces contiguous dates with no gaps', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2024, 12, 24);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        final dates = extractDates(result);
        expect(areDatesContiguous(dates), isTrue, reason: 'Dates should be contiguous');

        final gaps = findGaps(dates);
        expect(gaps, isEmpty, reason: 'There should be no gaps in dates');
      });

      test('preserves existing summaries with their activity counts', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2025, 1, 20);
        final existingSummaries = [
          DailyActivitySummary(activityDate: DateTime(2025, 1, 21), activityCount: 5),
        ];

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: existingSummaries,
        );

        // Assert
        expect(result.length, equals(3));
        final jan21 = result.firstWhere(
          (s) =>
              s.activityDate.year == 2025 && s.activityDate.month == 1 && s.activityDate.day == 21,
        );
        expect(jan21.activityCount, equals(5));
      });

      test('fills empty days with zero activity count', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2025, 1, 20);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        for (final summary in result) {
          expect(summary.activityCount, equals(0));
        }
      });

      test('handles single day range', () {
        // Arrange
        final date = DateTime(2025, 1, 22);

        // Act
        final result = service.fillDateRange(
          startDate: date,
          endDate: date,
          summaries: [],
        );

        // Assert
        expect(result.length, equals(1));
        expect(result.first.activityDate, equals(date));
      });

      test('handles month boundary correctly', () {
        // Arrange - spans December to January
        final endDate = DateTime(2025, 1, 5);
        final startDate = DateTime(2024, 12, 28);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        expect(result.length, equals(9)); // Dec 28-31 (4) + Jan 1-5 (5) = 9
        expect(areDatesContiguous(extractDates(result)), isTrue);
      });

      test('handles year boundary correctly', () {
        // Arrange
        final endDate = DateTime(2025, 1, 1);
        final startDate = DateTime(2024, 12, 31);

        // Act
        final result = service.fillDateRange(
          startDate: startDate,
          endDate: endDate,
          summaries: [],
        );

        // Assert
        expect(result.length, equals(2));
        expect(result.first.activityDate, equals(DateTime(2025, 1, 1)));
        expect(result.last.activityDate, equals(DateTime(2024, 12, 31)));
      });
    });

    group('getDailyActivities', () {
      test('delegates to repository', () async {
        // Arrange
        final startDate = DateTime(2025, 1, 1);
        final endDate = DateTime(2025, 1, 10);
        final summaries = [
          fakeDailyActivitySummary(activityDate: DateTime(2025, 1, 5), activityCount: 3),
        ];
        when(() => mockDailyActivitiesRepository.getByDateRange(any(), any()))
            .thenAnswer((_) async => summaries);

        // Act
        final result = await service.getDailyActivities(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, equals(summaries));
        verify(() => mockDailyActivitiesRepository.getByDateRange(startDate, endDate)).called(1);
      });

      test('swaps dates when endDate is before startDate', () async {
        // Arrange
        final startDate = DateTime(2025, 1, 10);
        final endDate = DateTime(2025, 1, 1);
        when(() => mockDailyActivitiesRepository.getByDateRange(any(), any()))
            .thenAnswer((_) async => []);

        // Act
        await service.getDailyActivities(
          startDate: startDate,
          endDate: endDate,
        );

        // Assert - should call with swapped dates
        verify(() => mockDailyActivitiesRepository.getByDateRange(endDate, startDate)).called(1);
      });
    });
  });
}
