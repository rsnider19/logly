import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/database/database_provider.dart';
import 'package:logly/app/database/drift_database.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/data/auth_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Mock for [AuthRepository].
class MockAuthRepository extends Mock implements AuthRepository {}

/// Mock for [LoggerService].
class MockLoggerService extends Mock implements LoggerService {}

/// Mock for [AppDatabase].
class MockAppDatabase extends Mock implements AppDatabase {}

/// Mock for [SupabaseClient].
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock for [GoTrueClient].
class MockGoTrueClient extends Mock implements GoTrueClient {}

/// Mock for [User].
class MockUser extends Mock implements User {}

/// Fake implementation of [AuthResponse] for testing.
class FakeAuthResponse extends Fake implements AuthResponse {
  FakeAuthResponse({this.mockUser});

  final User? mockUser;

  @override
  User? get user => mockUser;
}

/// Fake implementation of [User] for testing.
class FakeUser extends Fake implements User {
  FakeUser({
    this.mockId = 'test-user-id',
    this.mockEmail = 'test@example.com',
  });

  final String mockId;
  final String? mockEmail;

  @override
  String get id => mockId;

  @override
  String? get email => mockEmail;
}

/// Creates a [ProviderContainer] with auth service-related provider overrides.
///
/// This is used for unit testing the AuthService without widget tests.
ProviderContainer createAuthServiceTestContainer({
  required MockAuthRepository mockRepository,
  required MockLoggerService mockLogger,
  required MockAppDatabase mockDatabase,
}) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(mockRepository),
      loggerProvider.overrideWithValue(mockLogger),
      appDatabaseProvider.overrideWithValue(mockDatabase),
    ],
  );
}

/// Sets up default mock behavior for [MockLoggerService].
void setupMockLogger(MockLoggerService mockLogger) {
  when(() => mockLogger.i(any())).thenReturn(null);
  when(() => mockLogger.d(any())).thenReturn(null);
  when(() => mockLogger.e(any(), any(), any())).thenReturn(null);
}

/// Sets up authenticated state for [MockGoTrueClient].
void setupAuthenticatedState(MockGoTrueClient mockAuth, User mockUser) {
  when(() => mockAuth.currentUser).thenReturn(mockUser);
  when(() => mockAuth.onAuthStateChange).thenAnswer(
    (_) => Stream.value(
      AuthState(AuthChangeEvent.signedIn, Session(accessToken: '', tokenType: '', user: mockUser)),
    ),
  );
}

/// Sets up unauthenticated state for [MockGoTrueClient].
void setupUnauthenticatedState(MockGoTrueClient mockAuth) {
  when(() => mockAuth.currentUser).thenReturn(null);
  when(() => mockAuth.onAuthStateChange).thenAnswer(
    (_) => Stream.value(const AuthState(AuthChangeEvent.signedOut, null)),
  );
}
