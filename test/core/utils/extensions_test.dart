import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/utils/extensions.dart';

void main() {
  group('StringExtensions', () {
    group('isNullOrEmpty', () {
      test('returns true for empty string', () {
        expect(''.isNullOrEmpty, isTrue);
      });

      test('returns false for non-empty string', () {
        expect('hello'.isNullOrEmpty, isFalse);
      });

      test('returns false for whitespace-only string', () {
        expect('   '.isNullOrEmpty, isFalse);
      });
    });

    group('isNotNullOrEmpty', () {
      test('returns false for empty string', () {
        expect(''.isNotNullOrEmpty, isFalse);
      });

      test('returns true for non-empty string', () {
        expect('hello'.isNotNullOrEmpty, isTrue);
      });
    });

    group('capitalize', () {
      test('capitalizes first letter', () {
        expect('hello'.capitalize(), 'Hello');
      });

      test('returns empty string for empty input', () {
        expect(''.capitalize(), '');
      });

      test('handles single character', () {
        expect('a'.capitalize(), 'A');
      });

      test('preserves rest of string', () {
        expect('hELLO'.capitalize(), 'HELLO');
      });

      test('handles already capitalized string', () {
        expect('Hello'.capitalize(), 'Hello');
      });

      test('handles numbers at start', () {
        expect('123abc'.capitalize(), '123abc');
      });

      test('handles special characters', () {
        expect('!hello'.capitalize(), '!hello');
      });
    });

    group('toTitleCase', () {
      test('capitalizes each word', () {
        expect('hello world'.toTitleCase(), 'Hello World');
      });

      test('returns empty string for empty input', () {
        expect(''.toTitleCase(), '');
      });

      test('handles single word', () {
        expect('hello'.toTitleCase(), 'Hello');
      });

      test('handles multiple spaces', () {
        expect('hello  world'.toTitleCase(), 'Hello  World');
      });

      test('handles mixed case input', () {
        expect('hELLO wORLD'.toTitleCase(), 'HELLO WORLD');
      });
    });

    group('truncate', () {
      test('truncates long string with ellipsis', () {
        expect('hello world'.truncate(8), 'hello...');
      });

      test('returns original string if shorter than max', () {
        expect('hello'.truncate(10), 'hello');
      });

      test('returns original string if equal to max', () {
        expect('hello'.truncate(5), 'hello');
      });

      test('uses custom ellipsis', () {
        expect('hello world'.truncate(8, ellipsis: '…'), 'hello w…');
      });

      test('handles empty ellipsis', () {
        expect('hello world'.truncate(5, ellipsis: ''), 'hello');
      });

      test('handles short maxLength', () {
        expect('hello'.truncate(3), '...');
      });

      test('handles empty string', () {
        expect(''.truncate(10), '');
      });
    });
  });

  group('DateTimeExtensions', () {
    test('startOfDay delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15, 14, 30);
      final result = date.startOfDay;

      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.day, 15);
    });

    test('endOfDay delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15, 14, 30);
      final result = date.endOfDay;

      expect(result.hour, 23);
      expect(result.minute, 59);
      expect(result.second, 59);
    });

    test('startOfWeek delegates to DateUtils', () {
      final date = DateTime(2024, 3, 20); // Wednesday
      final result = date.startOfWeek;

      expect(result.weekday, DateTime.monday);
    });

    test('endOfWeek delegates to DateUtils', () {
      final date = DateTime(2024, 3, 20); // Wednesday
      final result = date.endOfWeek;

      expect(result.weekday, DateTime.sunday);
    });

    test('startOfMonth delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15);
      final result = date.startOfMonth;

      expect(result.day, 1);
    });

    test('endOfMonth delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15);
      final result = date.endOfMonth;

      expect(result.day, 31);
    });

    test('displayFormat delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15);
      expect(date.displayFormat, 'Mar 15, 2024');
    });

    test('shortFormat delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15);
      expect(date.shortFormat, 'Mar 15');
    });

    test('timeFormat delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15, 15, 30);
      // Handles potential narrow non-breaking space (U+202F) from intl
      expect(date.timeFormat, matches(RegExp(r'^3:30[\s\u202f]PM$')));
    });

    test('dateTimeFormat delegates to DateUtils', () {
      final date = DateTime(2024, 3, 15, 15, 30);
      // Handles potential narrow non-breaking space (U+202F) from intl
      expect(date.dateTimeFormat, matches(RegExp(r'^Mar 15, 2024 at 3:30[\s\u202f]PM$')));
    });

    test('isSameDayAs delegates to DateUtils', () {
      final a = DateTime(2024, 3, 15, 8, 0);
      final b = DateTime(2024, 3, 15, 20, 0);

      expect(a.isSameDayAs(b), isTrue);
    });

    test('isToday delegates to DateUtils', () {
      final now = DateTime.now();
      expect(now.isToday, isTrue);
    });

    test('isYesterday delegates to DateUtils', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);
    });
  });

  group('NullableExtensions', () {
    group('orElse', () {
      test('returns value when not null', () {
        const String? value = 'hello';
        expect(value.orElse(() => 'default'), 'hello');
      });

      test('returns orElse result when null', () {
        const String? value = null;
        expect(value.orElse(() => 'default'), 'default');
      });

      test('works with non-string types', () {
        const int? value = null;
        expect(value.orElse(() => 42), 42);
      });

      test('evaluates orElse lazily', () {
        var called = false;
        const String? value = 'hello';
        value.orElse(() {
          called = true;
          return 'default';
        });
        expect(called, isFalse);
      });
    });

    group('mapOrNull', () {
      test('returns mapped value when not null', () {
        const String? value = 'hello';
        expect(value.mapOrNull((v) => v.length), 5);
      });

      test('returns null when value is null', () {
        const String? value = null;
        expect(value.mapOrNull((v) => v.length), isNull);
      });

      test('works with type transformation', () {
        const int? value = 42;
        expect(value.mapOrNull((v) => v.toString()), '42');
      });

      test('does not call mapper when null', () {
        var called = false;
        const String? value = null;
        value.mapOrNull((v) {
          called = true;
          return v.length;
        });
        expect(called, isFalse);
      });
    });
  });
}
