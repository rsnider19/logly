import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Logger wrapper for consistent logging across the app.
///
/// Provides convenience methods for different log levels.
/// When Sentry is enabled and initialized (non-debug builds),
/// error-level logs are captured as Sentry events and
/// lower-level logs are added as breadcrumbs.
class LoggerService {
  LoggerService({Logger? logger, bool enableSentry = true})
      : _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                colors: false,
                printEmojis: true,
              ),
              level: kReleaseMode ? Level.warning : Level.debug,
            ),
        _enableSentry = enableSentry;

  final Logger _logger;
  final bool _enableSentry;

  bool get _sentryActive => _enableSentry && !kDebugMode && Sentry.isEnabled;

  /// Log a debug message.
  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
    if (_sentryActive) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message.toString(),
        level: SentryLevel.debug,
        category: 'log',
      ));
    }
  }

  /// Log an info message.
  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
    if (_sentryActive) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message.toString(),
        level: SentryLevel.info,
        category: 'log',
      ));
    }
  }

  /// Log a warning message.
  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
    if (_sentryActive) {
      Sentry.addBreadcrumb(Breadcrumb(
        message: message.toString(),
        level: SentryLevel.warning,
        category: 'log',
      ));
    }
  }

  /// Log an error message.
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    if (_sentryActive) {
      if (error != null) {
        Sentry.captureException(
          error,
          stackTrace: stackTrace,
          hint: Hint.withMap({'message': message.toString()}),
        );
      } else {
        Sentry.captureMessage(
          message.toString(),
          level: SentryLevel.error,
        );
      }
    }
  }
}
