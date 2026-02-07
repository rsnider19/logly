import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'analytics_initializer.g.dart';

/// Initializer that syncs Mixpanel identity with Supabase auth state.
///
/// Identifies user on sign-in, resets on sign-out.
/// Sets user profile properties and the subscription_plan super property.
class AnalyticsInitializer {
  AnalyticsInitializer(this._ref, this._analytics, this._logger);

  final Ref _ref;
  final AnalyticsService _analytics;
  final LoggerService _logger;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  bool _initialized = false;

  /// Starts listening to auth state changes and syncs Mixpanel identity.
  void initialize() {
    if (_initialized) return;
    if (!_analytics.isInitialized) {
      _logger.d('AnalyticsInitializer: Analytics not initialized, skipping');
      return;
    }
    _initialized = true;

    _logger.i('AnalyticsInitializer: Starting auth state listener');

    _authSubscription = _ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.initialSession) {
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

  void _onUserAuthenticated(Session? session) {
    if (session == null) return;

    final user = session.user;
    _analytics.identify(user.id);

    final entitlements = _ref.read(entitlementStateProvider);
    final plan = entitlements.isPro ? 'pro' : 'free';

    _analytics.setUserProperties({
      r'$name': user.userMetadata?['full_name'] ?? '',
      r'$email': user.email ?? '',
      'signup_date': user.createdAt,
      'subscription_plan': plan,
      'auth_provider': user.appMetadata['provider'] ?? 'unknown',
    });

    _analytics.setSuperProperty('subscription_plan', plan);

    _logger.d('AnalyticsInitializer: Identified user ${user.id}');
  }

  void _onUserSignedOut() {
    _analytics.trackSignOutCompleted();
    _analytics.reset();
    _logger.d('AnalyticsInitializer: Reset identity');
  }

  /// Disposes the initializer and closes subscriptions.
  void dispose() {
    _authSubscription?.close();
    _authSubscription = null;
    _initialized = false;
  }
}

/// Provides the analytics initializer instance.
@Riverpod(keepAlive: true)
AnalyticsInitializer analyticsInitializer(Ref ref) {
  final initializer = AnalyticsInitializer(
    ref,
    ref.watch(analyticsServiceProvider),
    ref.watch(loggerProvider),
  );
  ref.onDispose(initializer.dispose);
  return initializer;
}
