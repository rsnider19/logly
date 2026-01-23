import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provides the app router instance with auth-based redirects.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Watch auth state to trigger router refresh on auth changes
  final isAuthenticated = ref.watch(currentUserProvider) != null;

  // Watch onboarding status - use switch to handle async state
  final onboardingCompletedAsync = ref.watch(onboardingCompletedProvider);
  final onboardingCompleted = switch (onboardingCompletedAsync) {
    AsyncData(:final value) => value,
    _ => null,
  };

  // Watch returning user status - used to determine if we should skip intro
  final isReturningUserAsync = ref.watch(isReturningUserProvider);
  final isReturningUser = switch (isReturningUserAsync) {
    AsyncData(:final value) => value,
    _ => null,
  };

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute = location == '/auth';
      final isOnboardingRoute = location.startsWith('/onboarding');

      // Redirect to auth if not authenticated and not already on auth route
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth';
      }

      // Redirect to home if authenticated and on auth route
      if (isAuthenticated && isAuthRoute) {
        // If onboarding status is not yet loaded, go to home and let next refresh handle it
        if (onboardingCompleted == null) {
          return '/';
        }
        // If onboarding not completed, redirect to appropriate onboarding route
        if (!onboardingCompleted) {
          // If returning user, skip intro and go directly to favorites
          if (isReturningUser == true) {
            return '/onboarding/favorites';
          }
          return '/onboarding';
        }
        return '/';
      }

      // If authenticated but onboarding not completed, redirect to onboarding
      if (isAuthenticated && !isOnboardingRoute && onboardingCompleted == false) {
        // If returning user, skip intro
        if (isReturningUser == true) {
          return '/onboarding/favorites';
        }
        return '/onboarding';
      }

      // If onboarding completed and on onboarding route, redirect to home
      if (isAuthenticated && isOnboardingRoute && onboardingCompleted == true) {
        return '/';
      }

      return null;
    },
    errorBuilder: _errorBuilder,
  );
}

/// Builds the error page for unknown routes.
Widget _errorBuilder(BuildContext context, GoRouterState state) {
  return Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Route: ${state.matchedLocation}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  );
}
