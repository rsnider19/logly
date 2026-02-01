import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logly/app/database/database_provider.dart';
import 'package:logly/app/database/drift_database.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/data/auth_repository.dart';
import 'package:logly/features/auth/domain/auth_exception.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoggerService extends Mock implements LoggerService {}

class MockAppDatabase extends Mock implements AppDatabase {}

class FakeAuthResponse extends Fake implements AuthResponse {
  @override
  User? get user => null;
}

void main() {
  group('AuthService', () {
    late MockAuthRepository mockRepository;
    late MockLoggerService mockLogger;
    late MockAppDatabase mockDatabase;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockLogger = MockLoggerService();
      mockDatabase = MockAppDatabase();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
          loggerProvider.overrideWithValue(mockLogger),
          appDatabaseProvider.overrideWithValue(mockDatabase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('signInWithApple', () {
      test('calls repository signInWithApple and logs success', () async {
        final mockResponse = FakeAuthResponse();
        when(() => mockRepository.signInWithApple()).thenAnswer((_) async => mockResponse);

        final authService = container.read(authServiceProvider);
        final result = await authService.signInWithApple();

        expect(result, mockResponse);
        verify(() => mockRepository.signInWithApple()).called(1);
        verify(() => mockLogger.i(any())).called(2); // Start and success logs
      });

      test('rethrows AuthSignInCancelledException', () async {
        when(() => mockRepository.signInWithApple()).thenThrow(const AuthSignInCancelledException());

        final authService = container.read(authServiceProvider);

        expect(
          authService.signInWithApple,
          throwsA(isA<AuthSignInCancelledException>()),
        );
      });

      test('rethrows AuthProviderException', () async {
        when(() => mockRepository.signInWithApple()).thenThrow(const AuthProviderException('Apple sign-in failed'));

        final authService = container.read(authServiceProvider);

        expect(
          authService.signInWithApple,
          throwsA(isA<AuthProviderException>()),
        );
      });
    });

    group('signInWithGoogle', () {
      test('calls repository signInWithGoogle and logs success', () async {
        final mockResponse = FakeAuthResponse();
        when(() => mockRepository.signInWithGoogle()).thenAnswer((_) async => mockResponse);

        final authService = container.read(authServiceProvider);
        final result = await authService.signInWithGoogle();

        expect(result, mockResponse);
        verify(() => mockRepository.signInWithGoogle()).called(1);
        verify(() => mockLogger.i(any())).called(2);
      });

      test('rethrows AuthSignInCancelledException', () async {
        when(() => mockRepository.signInWithGoogle()).thenThrow(const AuthSignInCancelledException());

        final authService = container.read(authServiceProvider);

        expect(
          authService.signInWithGoogle,
          throwsA(isA<AuthSignInCancelledException>()),
        );
      });
    });

    group('signOut', () {
      test('calls repository signOut and clears local database', () async {
        when(() => mockRepository.signOut()).thenAnswer((_) async {});
        when(() => mockDatabase.clearAllCache()).thenAnswer((_) async => 0);

        final authService = container.read(authServiceProvider);
        await authService.signOut();

        verify(() => mockRepository.signOut()).called(1);
        verify(() => mockDatabase.clearAllCache()).called(1);
        verify(() => mockLogger.i(any())).called(2);
      });
    });

    group('requestAccountDeletion', () {
      test('calls repository requestAccountDeletion and signs out', () async {
        when(() => mockRepository.requestAccountDeletion()).thenAnswer((_) async {});
        when(() => mockRepository.signOut()).thenAnswer((_) async {});
        when(() => mockDatabase.clearAllCache()).thenAnswer((_) async => 0);

        final authService = container.read(authServiceProvider);
        await authService.requestAccountDeletion();

        verify(() => mockRepository.requestAccountDeletion()).called(1);
        verify(() => mockRepository.signOut()).called(1);
        verify(() => mockLogger.i(any())).called(4);
      });
    });
  });
}
