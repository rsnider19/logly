import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

/// Mock categories for testing.
final _mockCategories = [
  const ActivityCategory(
    activityCategoryId: '1',
    name: 'Fitness',
    activityCategoryCode: 'fitness',
    hexColor: '#FF6B6B',
    sortOrder: 1,
  ),
];

void main() {
  group('Route Paths', () {
    test('HomeRoute generates correct path', () {
      const route = HomeRoute();
      expect(route.location, '/');
    });

    test('AuthRoute generates correct path', () {
      const route = AuthRoute();
      expect(route.location, '/auth');
    });
  });

  group('GoRouter Navigation', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late ProviderContainer container;
    late GoRouter router;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();

      // Set up environment for _ConnectionTestScreen which uses EnvService
      dotenv.loadFromString(
        envString: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
GOOGLE_WEB_CLIENT_ID=test-web-client-id.apps.googleusercontent.com
GOOGLE_IOS_CLIENT_ID=test-ios-client-id.apps.googleusercontent.com
''',
      );

      // Mock auth to return a user (authenticated state)
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockAuth.onAuthStateChange).thenAnswer(
        (_) => Stream.value(
          AuthState(AuthChangeEvent.signedIn, Session(accessToken: '', tokenType: '', user: mockUser)),
        ),
      );
      when(() => mockSupabase.auth).thenReturn(mockAuth);

      container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
          activityCategoriesProvider.overrideWith((ref) async => _mockCategories),
        ],
      );
      router = container.read(appRouterProvider);
    });

    tearDown(() {
      container.dispose();
      dotenv.clean();
    });

    testWidgets('navigates to home screen at / when authenticated', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Home route shows ConnectionTestScreen with title "Connection Test"
      expect(find.text('Connection Test'), findsOneWidget);
    });

    testWidgets('shows error page for unknown route', (tester) async {
      router.go('/unknown-route-that-does-not-exist');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Page not found'), findsOneWidget);
      expect(find.text('Route: /unknown-route-that-does-not-exist'), findsOneWidget);
    });

    testWidgets('error page has Go Home button', (tester) async {
      router.go('/invalid');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Go Home'), findsOneWidget);
    });
  });

  group('Auth Redirects', () {
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

    testWidgets('redirects unauthenticated user to /auth', (tester) async {
      // No user - unauthenticated
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.onAuthStateChange).thenAnswer(
        (_) => Stream.value(const AuthState(AuthChangeEvent.signedOut, null)),
      );

      final container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
          activityCategoriesProvider.overrideWith((ref) async => _mockCategories),
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

      // Should be redirected to auth screen
      expect(find.text('Logly'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);

      container.dispose();
    });

    testWidgets('redirects authenticated user from /auth to /', (tester) async {
      // Has user - authenticated
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockAuth.onAuthStateChange).thenAnswer(
        (_) => Stream.value(
          AuthState(AuthChangeEvent.signedIn, Session(accessToken: '', tokenType: '', user: mockUser)),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          supabaseProvider.overrideWithValue(mockSupabase),
          activityCategoriesProvider.overrideWith((ref) async => _mockCategories),
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

      // Should be redirected to home screen
      expect(find.text('Connection Test'), findsOneWidget);

      container.dispose();
    });
  });
}
