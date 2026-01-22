import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/app/router/routes.dart';

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
    late GoRouter router;

    setUp(() {
      // Set up environment for _ConnectionTestScreen which uses EnvService
      dotenv.loadFromString(
        envString: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
''',
      );
      router = createRouter();
    });

    tearDown(() {
      dotenv.clean();
    });

    testWidgets('navigates to home screen at /', (tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Home route shows ConnectionTestScreen with title "Connection Test"
      expect(find.text('Connection Test'), findsOneWidget);
    });

    testWidgets('navigates to auth screen at /auth', (tester) async {
      router.go('/auth');

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Auth route shows placeholder with "Auth" title
      expect(find.text('Auth'), findsOneWidget);
      expect(find.text('Auth Screen'), findsOneWidget);
    });

    testWidgets('shows error page for unknown route', (tester) async {
      router.go('/unknown-route-that-does-not-exist');

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Page not found'), findsOneWidget);
      expect(find.text('Route: /unknown-route-that-does-not-exist'), findsOneWidget);
    });

    testWidgets('error page has Go Home button', (tester) async {
      router.go('/invalid');

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Go Home'), findsOneWidget);
    });

    testWidgets('Go Home button navigates to home', (tester) async {
      router.go('/invalid');

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Go Home'));
      await tester.pumpAndSettle();

      // Should now be at home screen
      expect(find.text('Connection Test'), findsOneWidget);
    });
  });

  group('createRouter', () {
    test('returns GoRouter instance', () {
      dotenv.loadFromString(
        envString: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
''',
      );

      final router = createRouter();

      expect(router, isA<GoRouter>());

      dotenv.clean();
    });

    testWidgets('starts at initial location /', (tester) async {
      dotenv.loadFromString(
        envString: '''
SUPABASE_URL=https://test.supabase.co
SUPABASE_ANON_KEY=test-anon-key
''',
      );

      final router = createRouter();

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      // Router should start at '/' showing the home screen
      expect(find.text('Connection Test'), findsOneWidget);

      dotenv.clean();
    });
  });
}
