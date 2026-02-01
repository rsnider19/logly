import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  group('SignInScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    Widget createTestWidget({AuthService? authService}) {
      return ProviderScope(
        overrides: [
          if (authService != null) authServiceProvider.overrideWithValue(authService),
        ],
        child: const MaterialApp(
          home: SignInScreen(),
        ),
      );
    }

    testWidgets('renders app branding', (tester) async {
      await tester.pumpWidget(createTestWidget(authService: mockAuthService));

      expect(find.text('Logly'), findsOneWidget);
      expect(find.text('Track your activities, build habits'), findsOneWidget);
      expect(find.byIcon(Icons.track_changes), findsOneWidget);
    });

    testWidgets('renders Google sign-in button on all platforms', (tester) async {
      await tester.pumpWidget(createTestWidget(authService: mockAuthService));

      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('renders Apple sign-in button only on iOS/macOS', (tester) async {
      await tester.pumpWidget(createTestWidget(authService: mockAuthService));

      // The AppleSignInButton only renders on iOS/macOS
      if (Platform.isIOS || Platform.isMacOS) {
        expect(find.text('Sign in with Apple'), findsOneWidget);
      } else {
        expect(find.text('Sign in with Apple'), findsNothing);
      }
    });

    testWidgets('renders terms and privacy links', (tester) async {
      await tester.pumpWidget(createTestWidget(authService: mockAuthService));

      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });
  });
}
