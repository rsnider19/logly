import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/health_integration/application/health_sync_service.dart';
import 'package:logly/features/health_integration/presentation/providers/health_sync_provider.dart';
import 'package:logly/features/home/presentation/providers/daily_activities_provider.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'health_sync_initializer.g.dart';

/// Service that handles automatic health sync after authentication.
class HealthSyncInitializer {
  HealthSyncInitializer(this._ref, this._logger);

  final Ref _ref;
  final LoggerService _logger;
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;
  bool _initialized = false;

  /// Initializes the health sync listener.
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    _logger.i('HealthSyncInitializer: Starting auth state listener');

    // Listen to auth state changes
    _authSubscription = _ref.listen(authStateProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.initialSession) {
          _onUserAuthenticated();
        }
      });
    });

    // Check current auth state
    final currentAuthState = _ref.read(authStateProvider);
    currentAuthState.whenData((authState) {
      if (authState.session != null) {
        _onUserAuthenticated();
      }
    });
  }

  /// Called when user is authenticated - triggers health sync if enabled.
  Future<void> _onUserAuthenticated() async {
    _logger.i('HealthSyncInitializer: User authenticated, checking health sync settings');

    try {
      // Wait for preferences to load
      final preferencesAsync = _ref.read(preferencesStateProvider);

      final preferences = switch (preferencesAsync) {
        AsyncData(:final value) => value,
        _ => null,
      };

      if (preferences == null) {
        _logger.d('HealthSyncInitializer: Preferences not loaded yet, waiting...');
        // Wait a bit and try again
        await Future<void>.delayed(const Duration(milliseconds: 500));
        final retryPreferences = _ref.read(preferencesStateProvider);
        final prefs = switch (retryPreferences) {
          AsyncData(:final value) => value,
          _ => null,
        };
        if (prefs == null || !prefs.healthSyncEnabled) {
          _logger.d('HealthSyncInitializer: Health sync not enabled');
          return;
        }
        await _performSync();
      } else if (preferences.healthSyncEnabled) {
        await _performSync();
      } else {
        _logger.d('HealthSyncInitializer: Health sync not enabled');
      }
    } catch (e, st) {
      _logger.e('HealthSyncInitializer: Error checking health sync settings', e, st);
    }
  }

  /// Performs the health sync in a non-blocking way.
  Future<void> _performSync() async {
    _logger.i('HealthSyncInitializer: Starting background health sync');

    try {
      final syncNotifier = _ref.read(healthSyncStateProvider.notifier);
      final syncState = _ref.read(healthSyncStateProvider);

      // Don't sync if already syncing
      if (syncState.isSyncing) {
        _logger.d('HealthSyncInitializer: Sync already in progress');
        return;
      }

      // Check for last sync date directly from the service (provider state may not be loaded yet)
      final service = _ref.read(healthSyncServiceProvider);
      final lastSyncDate = await service.getLastSyncDate();

      // Don't do first-time sync automatically (requires user to pick date range)
      if (lastSyncDate == null) {
        _logger.d('HealthSyncInitializer: First sync requires user interaction');
        return;
      }

      _logger.i('HealthSyncInitializer: Last sync was $lastSyncDate, starting sync');

      // Perform sync in background (non-blocking)
      unawaited(
        syncNotifier.sync().then((_) {
          final result = _ref.read(healthSyncStateProvider).lastSyncResult;
          if (result != null && result.created > 0) {
            _logger.i('HealthSyncInitializer: Sync completed, refreshing daily activities');
            // Invalidate daily activities provider to refresh the home screen
            _ref.invalidate(dailyActivitiesStateProvider);
          }
        }),
      );
    } catch (e, st) {
      _logger.e('HealthSyncInitializer: Error during sync', e, st);
    }
  }

  /// Disposes the initializer and closes subscriptions.
  void dispose() {
    _authSubscription?.close();
    _authSubscription = null;
    _initialized = false;
  }
}

/// Provides the health sync initializer instance.
@Riverpod(keepAlive: true)
HealthSyncInitializer healthSyncInitializer(Ref ref) {
  final initializer = HealthSyncInitializer(ref, ref.watch(loggerProvider));
  ref.onDispose(initializer.dispose);
  return initializer;
}
