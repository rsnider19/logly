import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/auth/domain/auth_exception.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/auth_test_helpers.dart';

/// Mock categories for testing navigation.
final _mockCategories = [
  const ActivityCategory(
    activityCategoryId: '1',
    name: 'Fitness',
    activityCategoryCode: 'fitness',
    hexColor: '#FF6B6B',
    icon: '🏋️',
    sortOrder: 1,
  ),
];

void main() {
  group('Auth Integration Tests', () {
    group('Full Sign-In Flow with Mock Providers', () {
      late MockAuthRepository mockRepository;
      late MockLoggerService mockLogger;
      late MockAppDatabase mockDatabase;
      late ProviderContainer container;

      setUp(() {
        mockRepository = MockAuthRepository();
        mockLogger = MockLoggerService();
        mockDatabase = MockAppDatabase();
        setupMockLogger(mockLogger);
      });

      tearDown(() {
        container.dispose();
      });

      test('Google sign-in completes flow and updates auth state', () async {
        // Setup
        final mockUser = FakeUser(mockId: 'google-user-123');
        final mockResponse = FakeAuthResponse(mockUser: mockUser);
        when(() => mockRepository.signInWithGoogle()).thenAnswer((_) async => mockResponse);

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action
        final authService = container.read(authServiceProvider);
        final result = await authService.signInWithGoogle();

        // Verify
        expect(result, equals(mockResponse));
        expect(result.user?.id, equals('google-user-123'));
        verify(() => mockRepository.signInWithGoogle()).called(1);
        verify(() => mockLogger.i('Initiating Google sign-in')).called(1);
        verify(() => mockLogger.i('Google sign-in successful for user: google-user-123')).called(1);
      });

      test('Apple sign-in completes flow and updates auth state', () async {
        // Setup
        final mockUser = FakeUser(mockId: 'apple-user-456');
        final mockResponse = FakeAuthResponse(mockUser: mockUser);
        when(() => mockRepository.signInWithApple()).thenAnswer((_) async => mockResponse);

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action
        final authService = container.read(authServiceProvider);
        final result = await authService.signInWithApple();

        // Verify
        expect(result, equals(mockResponse));
        expect(result.user?.id, equals('apple-user-456'));
        verify(() => mockRepository.signInWithApple()).called(1);
        verify(() => mockLogger.i('Initiating Apple sign-in')).called(1);
        verify(() => mockLogger.i('Apple sign-in successful for user: apple-user-456')).called(1);
      });

      test('Cancelled sign-in throws AuthSignInCancelledException', () async {
        // Setup
        when(() => mockRepository.signInWithGoogle()).thenThrow(const AuthSignInCancelledException());

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action & Verify
        final authService = container.read(authServiceProvider);
        expect(
          () => authService.signInWithGoogle(),
          throwsA(isA<AuthSignInCancelledException>()),
        );
      });

      test('Sign-in error throws AuthProviderException', () async {
        // Setup
        when(() => mockRepository.signInWithApple())
            .thenThrow(const AuthProviderException('Apple sign-in failed', 'Network error'));

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action & Verify
        final authService = container.read(authServiceProvider);
        expect(
          () => authService.signInWithApple(),
          throwsA(
            isA<AuthProviderException>().having((e) => e.message, 'message', 'Apple sign-in failed'),
          ),
        );
      });
    });

    group('Sign-Out Clears All Local Data', () {
      late MockAuthRepository mockRepository;
      late MockLoggerService mockLogger;
      late MockAppDatabase mockDatabase;
      late ProviderContainer container;

      setUp(() {
        mockRepository = MockAuthRepository();
        mockLogger = MockLoggerService();
        mockDatabase = MockAppDatabase();
        setupMockLogger(mockLogger);
      });

      tearDown(() {
        container.dispose();
      });

      test('signOut clears database and calls repository', () async {
        // Setup
        when(() => mockRepository.signOut()).thenAnswer((_) async {});
        when(() => mockDatabase.clearAllCache()).thenAnswer((_) async => 5);

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action
        final authService = container.read(authServiceProvider);
        await authService.signOut();

        // Verify
        verify(() => mockRepository.signOut()).called(1);
        verify(() => mockDatabase.clearAllCache()).called(1);
        verify(() => mockLogger.i('Signing out user')).called(1);
        verify(() => mockLogger.i('Sign out complete, local data cleared')).called(1);
      });

      test('Account deletion triggers signOut flow', () async {
        // Setup
        when(() => mockRepository.requestAccountDeletion()).thenAnswer((_) async {});
        when(() => mockRepository.signOut()).thenAnswer((_) async {});
        when(() => mockDatabase.clearAllCache()).thenAnswer((_) async => 3);

        container = createAuthServiceTestContainer(
          mockRepository: mockRepository,
          mockLogger: mockLogger,
          mockDatabase: mockDatabase,
        );

        // Action
        final authService = container.read(authServiceProvider);
        await authService.requestAccountDeletion();

        // Verify - edge function called, then signOut chain
        verify(() => mockRepository.requestAccountDeletion()).called(1);
        verify(() => mockRepository.signOut()).called(1);
        verify(() => mockDatabase.clearAllCache()).called(1);
        verify(() => mockLogger.i('Requesting account deletion')).called(1);
        verify(() => mockLogger.i('Account deletion requested, user signed out')).called(1);
      });
    });

    group('Route Guards Redirect Correctly', () {
      late MockSupabaseClient mockSupabase;
      late MockGoTrueClient mockAuth;

      setUp(() {
        mockSupabase = MockSupabaseClient();
        mockAuth = MockGoTrueClient();

        dotenv.loadFromString(
          envString: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
GOOGLE_WEB_CLIENT_ID=test-web-client-id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=test-ios-client-id.apps.googleusercontent.com
''',
        );

        when(() => mockSupabase.auth).thenReturn(mockAuth);
      });

      tearDown(() {
        dotenv.clean();
      });

      testWidgets('Unauthenticated user redirected to /auth', (tester) async {
        // Setup - user is NOT authenticated
        setupUnauthenticatedState(mockAuth);

        final container = ProviderContainer(
          overrides: [
            supabaseProvider.overrideWithValue(mockSupabase),
            categoriesProvider.overrideWith((ref) async => _mockCategories),
          ],
        );
        final router = container.read(appRouterProvider);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify - should be redirected to auth screen
        expect(find.text('Logly'), findsOneWidget);
        expect(find.text('Sign in with Google'), findsOneWidget);

        container.dispose();
      });

      testWidgets('Authenticated user on /auth redirected to home', (tester) async {
        // Setup - user IS authenticated
        final mockUser = MockUser();
        setupAuthenticatedState(mockAuth, mockUser);

        final container = ProviderContainer(
          overrides: [
            supabaseProvider.overrideWithValue(mockSupabase),
            categoriesProvider.overrideWith((ref) async => _mockCategories),
          ],
        );
        final router = container.read(appRouterProvider);

        // Try to go to /auth
        router.go('/auth');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify - should be redirected to home screen
        expect(find.text('Connection Test'), findsOneWidget);

        container.dispose();
      });

      testWidgets('No redirect when unauthenticated on /auth', (tester) async {
        // Setup - user is NOT authenticated
        setupUnauthenticatedState(mockAuth);

        final container = ProviderContainer(
          overrides: [
            supabaseProvider.overrideWithValue(mockSupabase),
            categoriesProvider.overrideWith((ref) async => _mockCategories),
          ],
        );
        final router = container.read(appRouterProvider);

        // Navigate explicitly to /auth
        router.go('/auth');

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify - should stay on /auth
        expect(find.text('Logly'), findsOneWidget);
        expect(find.text('Sign in with Google'), findsOneWidget);

        container.dispose();
      });

      testWidgets('No redirect when authenticated on home', (tester) async {
        // Setup - user IS authenticated
        final mockUser = MockUser();
        setupAuthenticatedState(mockAuth, mockUser);

        final container = ProviderContainer(
          overrides: [
            supabaseProvider.overrideWithValue(mockSupabase),
            categoriesProvider.overrideWith((ref) async => _mockCategories),
          ],
        );
        final router = container.read(appRouterProvider);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify - should stay on home (Connection Test screen)
        expect(find.text('Connection Test'), findsOneWidget);

        container.dispose();
      });
    });
  });
}
