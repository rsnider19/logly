import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';

/// Creates and configures the app router.
///
/// Returns a GoRouter instance with all routes and redirect logic.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: $appRoutes,
    redirect: _handleRedirect,
    errorBuilder: _errorBuilder,
  );
}

/// Handles route redirects based on authentication state.
///
/// Returns the path to redirect to, or null to allow the navigation.
String? _handleRedirect(BuildContext context, GoRouterState state) {
  // TODO(auth): Implement auth-based redirects in 02-auth feature
  // final isAuthenticated = ...;
  // final isAuthRoute = state.matchedLocation == '/auth';
  //
  // if (!isAuthenticated && !isAuthRoute) {
  //   return '/auth';
  // }
  //
  // if (isAuthenticated && isAuthRoute) {
  //   return '/';
  // }

  return null;
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
