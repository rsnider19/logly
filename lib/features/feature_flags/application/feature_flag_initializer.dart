import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/feature_flag_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'feature_flag_initializer.g.dart';

/// Initializer that updates GrowthBook user attributes when auth state changes.
///
/// Follows the same pattern as [SubscriptionInitializer].
class FeatureFlagInitializer {
  FeatureFlagInitializer(this._ref, this._service, this._logger);

  final Ref _ref;
  final FeatureFlagService _service;
  final LoggerService _logger;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  bool _initialized = false;

  String _appVersion = '';
  String _buildNumber = '';
  String _environment = '';

  /// Initializes the feature flag attribute listener.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _logger.i('FeatureFlagInitializer: Starting auth state listener');

    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
    _environment = _inferEnvironment();

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

  String _inferEnvironment() {
    try {
      final supabaseUrl = Supabase.instance.client.supabaseUrl;
      if (supabaseUrl.contains('127.0.0.1') || supabaseUrl.contains('localhost')) {
        return 'development';
      }
      return 'production';
    } catch (_) {
      return 'unknown';
    }
  }

  Future<void> _onUserAuthenticated(Session? session) async {
    if (session == null) return;

    final userId = session.user.id;
    final email = session.user.email;

    final entitlements = _ref.read(entitlementStateProvider);
    final isPro = entitlements.isPro;

    _logger.i('FeatureFlagInitializer: User authenticated, updating attributes');

    try {
      await _service.updateAttributes(
        FeatureFlagService.buildAuthenticatedAttributes(
          userId: userId,
          email: email,
          appVersion: _appVersion,
          buildNumber: _buildNumber,
          environment: _environment,
          isPro: isPro,
        ),
      );
    } catch (e, st) {
      _logger.e('FeatureFlagInitializer: Failed to update attributes', e, st);
    }
  }

  Future<void> _onUserSignedOut() async {
    _logger.i('FeatureFlagInitializer: User signed out, reverting to anonymous attributes');

    try {
      await _service.updateAttributes(
        FeatureFlagService.buildAnonymousAttributes(
          appVersion: _appVersion,
          buildNumber: _buildNumber,
          environment: _environment,
        ),
      );
    } catch (e, st) {
      _logger.e('FeatureFlagInitializer: Failed to reset attributes', e, st);
    }
  }

  /// Disposes the initializer and closes subscriptions.
  void dispose() {
    _authSubscription?.close();
    _authSubscription = null;
    _initialized = false;
  }
}

/// Provides the feature flag initializer instance.
@Riverpod(keepAlive: true)
FeatureFlagInitializer featureFlagInitializer(Ref ref) {
  final initializer = FeatureFlagInitializer(
    ref,
    ref.watch(featureFlagServiceProvider),
    ref.watch(loggerProvider),
  );
  ref.onDispose(initializer.dispose);
  return initializer;
}
