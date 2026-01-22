import 'package:logly/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock AuthRepository for testing services and widgets that depend on auth.
class MockAuthRepository extends Mock implements AuthRepository {}
