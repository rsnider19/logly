import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'sentry_initializer.g.dart';

/// Initializer that syncs Sentry user context with Supabase auth state.
///
/// Sets Sentry user when authenticated, clears on sign-out.
/// No-op when Sentry is not enabled (e.g., debug builds).
class SentryInitializer {
  SentryInitializer(this._ref, this._logger);

  final Ref _ref;
  final LoggerService _logger;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  bool _initialized = false;

  /// Initializes the Sentry user context listener.
  void initialize() {
    if (_initialized) return;
    if (!Sentry.isEnabled) {
      _logger.d('SentryInitializer: Sentry not enabled, skipping');
      return;
    }
    _initialized = true;

    _logger.i('SentryInitializer: Starting auth state listener');

    // Listen to auth state changes
    _authSubscription = _ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedIn || authState.event == AuthChangeEvent.initialSession) {
          _onUserAuthenticated(authState.session);
        } else if (authState.event == AuthChangeEvent.signedOut) {
          _onUserSignedOut();
        }
      });
    });

    // Check current auth state
    _ref.read(authStateProvider).whenData((authState) {
      if (authState.session != null) {
        _onUserAuthenticated(authState.session);
      }
    });
  }

  /// Sets Sentry user context when authenticated.
  void _onUserAuthenticated(Session? session) {
    if (session == null) return;

    final userId = session.user.id;
    final email = session.user.email;

    _logger.d('SentryInitializer: Setting Sentry user context');

    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: userId,
          email: email,
        ),
      );
    });
  }

  /// Clears Sentry user context when signed out.
  void _onUserSignedOut() {
    _logger.d('SentryInitializer: Clearing Sentry user context');

    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Disposes the initializer and closes subscriptions.
  void dispose() {
    _authSubscription?.close();
    _authSubscription = null;
    _initialized = false;
  }
}

/// Provides the Sentry initializer instance.
@Riverpod(keepAlive: true)
SentryInitializer sentryInitializer(Ref ref) {
  final initializer = SentryInitializer(
    ref,
    ref.watch(loggerProvider),
  );
  ref.onDispose(initializer.dispose);
  return initializer;
}
