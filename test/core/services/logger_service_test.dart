import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mocks/mock_logger.dart';

void main() {
  group('LoggerService', () {
    late MockLogger mockLogger;
    late LoggerService loggerService;

    setUp(() {
      mockLogger = MockLogger();
      loggerService = LoggerService(logger: mockLogger, enableSentry: false);
    });

    group('constructor', () {
      test('creates default logger when none provided', () {
        expect(
          LoggerService.new,
          returnsNormally,
        );
      });

      test('uses provided logger', () {
        final service = LoggerService(logger: mockLogger);
        service.d('test');

        verify(() => mockLogger.d('test')).called(1);
      });
    });

    group('d (debug)', () {
      test('delegates message to logger', () {
        loggerService.d('debug message');

        verify(
          () => mockLogger.d('debug message'),
        ).called(1);
      });

      test('delegates error to logger', () {
        final error = Exception('test error');
        loggerService.d('debug message', error);

        verify(
          () => mockLogger.d('debug message', error: error),
        ).called(1);
      });

      test('delegates stackTrace to logger', () {
        final stackTrace = StackTrace.current;
        loggerService.d('debug message', null, stackTrace);

        verify(
          () => mockLogger.d('debug message', stackTrace: stackTrace),
        ).called(1);
      });

      test('delegates all parameters to logger', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;
        loggerService.d('debug message', error, stackTrace);

        verify(
          () => mockLogger.d('debug message', error: error, stackTrace: stackTrace),
        ).called(1);
      });
    });

    group('i (info)', () {
      test('delegates message to logger', () {
        loggerService.i('info message');

        verify(
          () => mockLogger.i('info message'),
        ).called(1);
      });

      test('delegates error and stackTrace to logger', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;
        loggerService.i('info message', error, stackTrace);

        verify(
          () => mockLogger.i('info message', error: error, stackTrace: stackTrace),
        ).called(1);
      });
    });

    group('w (warning)', () {
      test('delegates message to logger', () {
        loggerService.w('warning message');

        verify(
          () => mockLogger.w('warning message'),
        ).called(1);
      });

      test('delegates error and stackTrace to logger', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;
        loggerService.w('warning message', error, stackTrace);

        verify(
          () => mockLogger.w('warning message', error: error, stackTrace: stackTrace),
        ).called(1);
      });
    });

    group('e (error)', () {
      test('delegates message to logger', () {
        loggerService.e('error message');

        verify(
          () => mockLogger.e('error message'),
        ).called(1);
      });

      test('delegates error and stackTrace to logger', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;
        loggerService.e('error message', error, stackTrace);

        verify(
          () => mockLogger.e('error message', error: error, stackTrace: stackTrace),
        ).called(1);
      });
    });
  });
}
