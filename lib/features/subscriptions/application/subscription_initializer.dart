import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/subscriptions/data/subscription_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'subscription_initializer.g.dart';

/// Service that handles RevenueCat login/logout based on Supabase auth state.
class SubscriptionInitializer {
  SubscriptionInitializer(this._ref, this._repository, this._logger);

  final Ref _ref;
  final SubscriptionRepository _repository;
  final LoggerService _logger;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  bool _initialized = false;

  /// Initializes the subscription listener.
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _logger.i('SubscriptionInitializer: Starting auth state listener');

    // Listen to auth state changes
    _authSubscription = _ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.initialSession) {
          unawaited(_onUserAuthenticated(authState.session));
        } else if (authState.event == AuthChangeEvent.signedOut) {
          unawaited(_onUserSignedOut());
        }
      });
    });

    // Check current auth state
    _ref.read(authStateProvider).whenData((authState) {
      if (authState.session != null) {
        unawaited(_onUserAuthenticated(authState.session));
      }
    });
  }

  /// Called when user is authenticated - logs in to RevenueCat.
  Future<void> _onUserAuthenticated(Session? session) async {
    if (session == null) return;

    final userId = session.user.id;
    final email = session.user.email;

    _logger.i('SubscriptionInitializer: User authenticated, logging in to RevenueCat');

    try {
      await _repository.loginUser(userId, email);
    } catch (e, st) {
      _logger.e('SubscriptionInitializer: Failed to login to RevenueCat', e, st);
      // Don't rethrow - subscription login failure shouldn't block the app
    }
  }

  /// Called when user signs out - logs out from RevenueCat.
  Future<void> _onUserSignedOut() async {
    _logger.i('SubscriptionInitializer: User signed out, logging out from RevenueCat');

    try {
      await _repository.logoutUser();
    } catch (e, st) {
      _logger.e('SubscriptionInitializer: Failed to logout from RevenueCat', e, st);
      // Don't rethrow - subscription logout failure shouldn't block the app
    }
  }

  /// Disposes the initializer and closes subscriptions.
  void dispose() {
    _authSubscription?.close();
    _authSubscription = null;
    _initialized = false;
  }
}

/// Provides the subscription initializer instance.
@Riverpod(keepAlive: true)
SubscriptionInitializer subscriptionInitializer(Ref ref) {
  final initializer = SubscriptionInitializer(
    ref,
    ref.watch(subscriptionRepositoryProvider),
    ref.watch(loggerProvider),
  );
  ref.onDispose(initializer.dispose);
  return initializer;
}
