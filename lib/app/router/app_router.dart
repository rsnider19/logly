import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/core/services/analytics_route_observer.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provides the app router instance with auth-based redirects.
///
/// Uses [ref.listen] + [refreshListenable] so the GoRouter is created once
/// and redirect logic is re-evaluated when auth/onboarding state changes,
/// without recreating the router (which would reset navigation state).
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = ValueNotifier<int>(0);
  ref.onDispose(refreshNotifier.dispose);

  // Listen for changes — triggers redirect re-evaluation without rebuilding GoRouter
  ref.listen(currentUserProvider, (_, __) => refreshNotifier.value++);
  ref.listen(onboardingCompletedProvider, (_, __) => refreshNotifier.value++);

  final analyticsService = ref.watch(analyticsServiceProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: $appRoutes,
    refreshListenable: refreshNotifier,
    observers: [AnalyticsRouteObserver(analyticsService)],
    redirect: (context, state) {
      // Read current state at redirect evaluation time (not at provider build time)
      final isAuthenticated = ref.read(currentUserProvider) != null;
      final onboardingCompletedAsync = ref.read(onboardingCompletedProvider);
      final onboardingCompleted = switch (onboardingCompletedAsync) {
        AsyncData(:final value) => value,
        _ => null,
      };

      final location = state.matchedLocation;
      final isAuthRoute = location == '/auth';
      final isOnboardingRoute = location.startsWith('/onboarding');
      final isPreAuthOnboarding = location == '/onboarding' || location == '/onboarding/questions';
      final isQuestionsFromSettings =
          location == '/onboarding/questions' && state.uri.queryParameters['source'] == 'settings';

      // Allow authenticated users to access questions from settings
      if (isAuthenticated && isQuestionsFromSettings) {
        return null;
      }

      // Allow pre-auth onboarding routes without authentication
      if (!isAuthenticated && isPreAuthOnboarding) {
        return null;
      }

      // Redirect unauthenticated users to the onboarding intro
      if (!isAuthenticated && !isAuthRoute && !isOnboardingRoute) {
        return '/onboarding';
      }

      // If on auth route and not authenticated, allow it
      if (!isAuthenticated && isAuthRoute) {
        return null;
      }

      // While onboarding status is still loading, don't redirect — avoids
      // flashing the wrong screen. Redirects re-evaluate once data loads.
      if (isAuthenticated && !onboardingCompletedAsync.hasValue) {
        return null;
      }

      // Authenticated user on auth route: go to setup or home
      if (isAuthenticated && isAuthRoute) {
        if (onboardingCompleted == null) return '/onboarding/setup';
        if (!onboardingCompleted) return '/onboarding/setup';
        return '/';
      }

      // Authenticated user on pre-auth onboarding routes: redirect to setup or home
      if (isAuthenticated && isPreAuthOnboarding) {
        if (onboardingCompleted == null) return '/onboarding/setup';
        if (!onboardingCompleted) return '/onboarding/setup';
        return '/';
      }

      // Authenticated, not on onboarding, but onboarding not completed: go to setup
      if (isAuthenticated && !isOnboardingRoute && onboardingCompleted != true) {
        return '/onboarding/setup';
      }

      // Authenticated, onboarding complete, but on onboarding route: go home
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
