import 'package:logly/core/services/logger_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_provider.g.dart';

/// Provides a logger instance for the app.
@Riverpod(keepAlive: true)
LoggerService logger(Ref ref) {
  return LoggerService();
}
