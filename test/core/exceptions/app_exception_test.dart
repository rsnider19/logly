import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/exceptions/app_exception.dart';

/// Concrete implementation for testing abstract AppException.
class TestException extends AppException {
  const TestException(super.message, [super.technicalDetails]);
}

void main() {
  group('AppException', () {
    test('stores message', () {
      const exception = TestException('User-facing message');

      expect(exception.message, 'User-facing message');
    });

    test('stores technicalDetails when provided', () {
      const exception = TestException('User-facing message', 'Technical details');

      expect(exception.technicalDetails, 'Technical details');
    });

    test('technicalDetails is null when not provided', () {
      const exception = TestException('User-facing message');

      expect(exception.technicalDetails, isNull);
    });

    test('toString includes message without technical details', () {
      const exception = TestException('User-facing message');

      expect(exception.toString(), 'AppException: User-facing message');
    });

    test('toString includes message and technical details when provided', () {
      const exception = TestException('User-facing message', 'Technical details');

      expect(
        exception.toString(),
        'AppException: User-facing message (Technical details)',
      );
    });

    test('implements Exception interface', () {
      const exception = TestException('message');

      expect(exception, isA<Exception>());
    });
  });

  group('EnvironmentException', () {
    test('stores message', () {
      const exception = EnvironmentException('Config error');

      expect(exception.message, 'Config error');
    });

    test('stores technicalDetails', () {
      const exception = EnvironmentException('Config error', 'Missing key');

      expect(exception.technicalDetails, 'Missing key');
    });

    test('extends AppException', () {
      const exception = EnvironmentException('Config error');

      expect(exception, isA<AppException>());
    });

    test('toString format matches AppException', () {
      const exception = EnvironmentException('Config error', 'ENV_KEY missing');

      expect(
        exception.toString(),
        'AppException: Config error (ENV_KEY missing)',
      );
    });
  });
}
