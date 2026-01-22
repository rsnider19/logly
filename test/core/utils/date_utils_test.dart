import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/utils/date_utils.dart';

void main() {
  group('DateUtils', () {
    group('startOfDay', () {
      test('returns midnight for the given date', () {
        final date = DateTime(2024, 3, 15, 14, 30, 45, 123);
        final result = DateUtils.startOfDay(date);

        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 15);
        expect(result.hour, 0);
        expect(result.minute, 0);
        expect(result.second, 0);
        expect(result.millisecond, 0);
      });

      test('preserves date when already at midnight', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.startOfDay(date);

        expect(result, date);
      });
    });

    group('endOfDay', () {
      test('returns 23:59:59.999 for the given date', () {
        final date = DateTime(2024, 3, 15, 14, 30, 45);
        final result = DateUtils.endOfDay(date);

        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 15);
        expect(result.hour, 23);
        expect(result.minute, 59);
        expect(result.second, 59);
        expect(result.millisecond, 999);
      });
    });

    group('startOfWeek', () {
      test('returns Monday for a Wednesday', () {
        // Wednesday, March 20, 2024
        final date = DateTime(2024, 3, 20, 14, 30);
        final result = DateUtils.startOfWeek(date);

        expect(result.weekday, DateTime.monday);
        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 18); // Monday
        expect(result.hour, 0);
        expect(result.minute, 0);
      });

      test('returns same day at midnight when date is Monday', () {
        // Monday, March 18, 2024
        final date = DateTime(2024, 3, 18, 14, 30);
        final result = DateUtils.startOfWeek(date);

        expect(result.weekday, DateTime.monday);
        expect(result.day, 18);
        expect(result.hour, 0);
      });

      test('returns previous Monday for a Sunday', () {
        // Sunday, March 24, 2024
        final date = DateTime(2024, 3, 24, 14, 30);
        final result = DateUtils.startOfWeek(date);

        expect(result.weekday, DateTime.monday);
        expect(result.day, 18); // Previous Monday
      });
    });

    group('endOfWeek', () {
      test('returns Sunday for a Wednesday', () {
        // Wednesday, March 20, 2024
        final date = DateTime(2024, 3, 20, 14, 30);
        final result = DateUtils.endOfWeek(date);

        expect(result.weekday, DateTime.sunday);
        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 24); // Sunday
        expect(result.hour, 23);
        expect(result.minute, 59);
        expect(result.second, 59);
      });

      test('returns same day at end of day when date is Sunday', () {
        // Sunday, March 24, 2024
        final date = DateTime(2024, 3, 24, 14, 30);
        final result = DateUtils.endOfWeek(date);

        expect(result.weekday, DateTime.sunday);
        expect(result.day, 24);
        expect(result.hour, 23);
        expect(result.minute, 59);
      });
    });

    group('startOfMonth', () {
      test('returns first day of month', () {
        final date = DateTime(2024, 3, 15, 14, 30);
        final result = DateUtils.startOfMonth(date);

        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 1);
        expect(result.hour, 0);
        expect(result.minute, 0);
      });

      test('handles month boundaries correctly', () {
        final date = DateTime(2024, 1, 1);
        final result = DateUtils.startOfMonth(date);

        expect(result.month, 1);
        expect(result.day, 1);
      });
    });

    group('endOfMonth', () {
      test('returns last day of 31-day month', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.endOfMonth(date);

        expect(result.year, 2024);
        expect(result.month, 3);
        expect(result.day, 31);
        expect(result.hour, 23);
        expect(result.minute, 59);
        expect(result.second, 59);
      });

      test('returns last day of 30-day month', () {
        final date = DateTime(2024, 4, 15);
        final result = DateUtils.endOfMonth(date);

        expect(result.day, 30);
      });

      test('returns 29 for February in leap year', () {
        final date = DateTime(2024, 2, 15); // 2024 is a leap year
        final result = DateUtils.endOfMonth(date);

        expect(result.day, 29);
      });

      test('returns 28 for February in non-leap year', () {
        final date = DateTime(2023, 2, 15); // 2023 is not a leap year
        final result = DateUtils.endOfMonth(date);

        expect(result.day, 28);
      });
    });

    group('toIso8601', () {
      test('converts to UTC ISO 8601 string', () {
        final date = DateTime(2024, 3, 15, 14, 30, 45);
        final result = DateUtils.toIso8601(date);

        expect(result, contains('2024-03-15'));
        expect(result, endsWith('Z'));
      });

      test('returns UTC time', () {
        final localDate = DateTime(2024, 3, 15, 14, 30, 45);
        final result = DateUtils.toIso8601(localDate);
        final parsed = DateTime.parse(result);

        expect(parsed.isUtc, isTrue);
      });
    });

    group('formatDisplay', () {
      test('formats date as "MMM d, yyyy"', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.formatDisplay(date);

        expect(result, 'Mar 15, 2024');
      });

      test('formats single digit day correctly', () {
        final date = DateTime(2024, 3, 5);
        final result = DateUtils.formatDisplay(date);

        expect(result, 'Mar 5, 2024');
      });
    });

    group('formatShort', () {
      test('formats date as "MMM d"', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.formatShort(date);

        expect(result, 'Mar 15');
      });
    });

    group('formatTime', () {
      test('formats time in 12-hour format', () {
        final date = DateTime(2024, 3, 15, 15, 30);
        final result = DateUtils.formatTime(date);

        // Handles potential narrow non-breaking space (U+202F) from intl
        expect(result, matches(RegExp(r'^3:30[\s\u202f]PM$')));
      });

      test('formats midnight correctly', () {
        final date = DateTime(2024, 3, 15);
        final result = DateUtils.formatTime(date);

        expect(result, matches(RegExp(r'^12:00[\s\u202f]AM$')));
      });

      test('formats noon correctly', () {
        final date = DateTime(2024, 3, 15, 12);
        final result = DateUtils.formatTime(date);

        expect(result, matches(RegExp(r'^12:00[\s\u202f]PM$')));
      });
    });

    group('formatDateTime', () {
      test('combines date and time format', () {
        final date = DateTime(2024, 3, 15, 15, 30);
        final result = DateUtils.formatDateTime(date);

        // Handles potential narrow non-breaking space (U+202F) from intl
        expect(result, matches(RegExp(r'^Mar 15, 2024 at 3:30[\s\u202f]PM$')));
      });
    });

    group('isSameDay', () {
      test('returns true for same day different times', () {
        final a = DateTime(2024, 3, 15, 8, 0);
        final b = DateTime(2024, 3, 15, 20, 30);

        expect(DateUtils.isSameDay(a, b), isTrue);
      });

      test('returns false for different days', () {
        final a = DateTime(2024, 3, 15);
        final b = DateTime(2024, 3, 16);

        expect(DateUtils.isSameDay(a, b), isFalse);
      });

      test('returns false for different months', () {
        final a = DateTime(2024, 3, 15);
        final b = DateTime(2024, 4, 15);

        expect(DateUtils.isSameDay(a, b), isFalse);
      });

      test('returns false for different years', () {
        final a = DateTime(2024, 3, 15);
        final b = DateTime(2023, 3, 15);

        expect(DateUtils.isSameDay(a, b), isFalse);
      });

      test('handles boundary at midnight', () {
        final a = DateTime(2024, 3, 15, 23, 59, 59);
        final b = DateTime(2024, 3, 15);

        expect(DateUtils.isSameDay(a, b), isTrue);
      });
    });

    group('isToday', () {
      test('returns true for today', () {
        final now = DateTime.now();
        expect(DateUtils.isToday(now), isTrue);
      });

      test('returns true for today at different time', () {
        final today = DateTime.now();
        final todayMorning = DateTime(today.year, today.month, today.day, 6, 0);

        expect(DateUtils.isToday(todayMorning), isTrue);
      });

      test('returns false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isToday(yesterday), isFalse);
      });

      test('returns false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(DateUtils.isToday(tomorrow), isFalse);
      });
    });

    group('isYesterday', () {
      test('returns true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(DateUtils.isYesterday(yesterday), isTrue);
      });

      test('returns false for today', () {
        final today = DateTime.now();
        expect(DateUtils.isYesterday(today), isFalse);
      });

      test('returns false for two days ago', () {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        expect(DateUtils.isYesterday(twoDaysAgo), isFalse);
      });
    });
  });
}
