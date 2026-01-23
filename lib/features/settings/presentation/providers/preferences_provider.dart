import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logly/features/settings/application/settings_service.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_provider.g.dart';

/// Provides the current user's preferences.
@riverpod
Future<UserPreferences> userPreferences(Ref ref) async {
  final service = ref.watch(settingsServiceProvider);
  return service.getPreferences();
}

/// State notifier for managing user preferences.
@Riverpod(keepAlive: true)
class PreferencesStateNotifier extends _$PreferencesStateNotifier {
  @override
  FutureOr<UserPreferences> build() async {
    final service = ref.read(settingsServiceProvider);
    return service.getPreferences();
  }

  /// Updates the theme mode preference.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    final currentState = state;
    if (currentState is! AsyncData<UserPreferences>) return;

    // Optimistic update
    state = AsyncData(currentState.value.copyWith(themeMode: themeMode));

    try {
      final service = ref.read(settingsServiceProvider);
      await service.setThemeMode(themeMode);
    } catch (e) {
      // Revert on error
      state = currentState;
      rethrow;
    }
  }

  /// Updates the health sync enabled preference.
  Future<void> setHealthSyncEnabled(bool enabled) async {
    final currentState = state;
    if (currentState is! AsyncData<UserPreferences>) return;

    // Optimistic update
    state = AsyncData(currentState.value.copyWith(healthSyncEnabled: enabled));

    try {
      final service = ref.read(settingsServiceProvider);
      await service.setHealthSyncEnabled(enabled);
    } catch (e) {
      // Revert on error
      state = currentState;
      rethrow;
    }
  }

  /// Updates the unit system preference.
  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    final currentState = state;
    if (currentState is! AsyncData<UserPreferences>) return;

    // Optimistic update
    state = AsyncData(currentState.value.copyWith(unitSystem: unitSystem));

    try {
      final service = ref.read(settingsServiceProvider);
      await service.setUnitSystem(unitSystem);
    } catch (e) {
      // Revert on error
      state = currentState;
      rethrow;
    }
  }
}

/// Provides the current theme mode, with a default fallback.
@Riverpod(keepAlive: true)
ThemeMode currentThemeMode(Ref ref) {
  final preferencesAsync = ref.watch(preferencesStateProvider);
  return switch (preferencesAsync) {
    AsyncData(:final value) => value.themeMode,
    _ => ThemeMode.system,
  };
}
