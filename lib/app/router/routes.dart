import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'routes.g.dart';

/// Home route - main screen of the app.
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _ConnectionTestScreen();
  }
}

/// Auth route - authentication screen.
@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

/// Screen to test Supabase connection.
class _ConnectionTestScreen extends StatefulWidget {
  const _ConnectionTestScreen();

  @override
  State<_ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<_ConnectionTestScreen> {
  String _status = 'Testing connection...';
  int? _trendingCount;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_testConnection());
  }

  Future<void> _testConnection() async {
    try {
      final response = await Supabase.instance.client
          .from('trending_activity')
          .select('activity_id')
          .limit(100);

      final count = (response as List).length;
      setState(() {
        _trendingCount = count;
        _status = count > 0 ? 'Connected' : 'Connected (RLS active)';
        _error = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Failed';
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Connection Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _error == null ? Icons.check_circle : Icons.error,
                size: 64,
                color: _error == null ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              if (_trendingCount != null) ...[
                Text(
                  'Trending activities: $_trendingCount',
                  style: theme.textTheme.bodyLarge,
                ),
                if (_trendingCount == 0)
                  Text(
                    '(RLS blocking anonymous access - expected)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'URL: ${EnvService.supabaseUrl}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _testConnection,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
