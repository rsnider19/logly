import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Provides the app router instance with auth-based redirects.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Watch auth state to trigger router refresh on auth changes
  final isAuthenticated = ref.watch(currentUserProvider) != null;

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: (context, state) {
      final isAuthRoute = state.matchedLocation == '/auth';

      // Redirect to auth if not authenticated and not already on auth route
      if (!isAuthenticated && !isAuthRoute) {
        return '/auth';
      }

      // Redirect to home if authenticated and on auth route
      if (isAuthenticated && isAuthRoute) {
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
