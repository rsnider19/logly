import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

/// Mock Logger for testing services that depend on logging.
class MockLogger extends Mock implements Logger {}
