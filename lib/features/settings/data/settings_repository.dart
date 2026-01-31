import 'package:flutter/material.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/settings/domain/settings_exception.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'settings_repository.g.dart';

/// Repository for settings-related data operations.
class SettingsRepository {
  SettingsRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches the current user's preferences from the profile table.
  Future<UserPreferences> getPreferences() async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>('my_profile');

      return UserPreferences(
        themeMode: _parseThemeMode(response['theme_mode'] as String?),
        healthSyncEnabled: response['health_sync_enabled'] as bool? ?? false,
        unitSystem: _parseUnitSystem(response['unit_system'] as String?),
        hapticFeedbackEnabled: response['haptic_feedback_enabled'] as bool? ?? true,
      );
    } catch (e, st) {
      _logger.e('Failed to load preferences', e, st);
      throw LoadPreferencesException(e.toString());
    }
  }

  /// Saves the user's theme mode preference.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const SavePreferencesException('User not authenticated');
      }

      final themeModeString = switch (themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };

      await _supabase.from('profile').update({
        'theme_mode': themeModeString,
      }).eq('user_id', userId);
    } catch (e, st) {
      _logger.e('Failed to save theme mode', e, st);
      if (e is SavePreferencesException) rethrow;
      throw SavePreferencesException(e.toString());
    }
  }

  /// Saves the user's health sync enabled preference.
  Future<void> setHealthSyncEnabled(bool enabled) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const SavePreferencesException('User not authenticated');
      }

      await _supabase.from('profile').update({
        'health_sync_enabled': enabled,
      }).eq('user_id', userId);
    } catch (e, st) {
      _logger.e('Failed to save health sync preference', e, st);
      if (e is SavePreferencesException) rethrow;
      throw SavePreferencesException(e.toString());
    }
  }

  /// Saves the user's haptic feedback enabled preference.
  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const SavePreferencesException('User not authenticated');
      }

      await _supabase.from('profile').update({
        'haptic_feedback_enabled': enabled,
      }).eq('user_id', userId);
    } catch (e, st) {
      _logger.e('Failed to save haptic feedback preference', e, st);
      if (e is SavePreferencesException) rethrow;
      throw SavePreferencesException(e.toString());
    }
  }

  /// Saves the user's unit system preference.
  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const SavePreferencesException('User not authenticated');
      }

      final unitSystemString = switch (unitSystem) {
        UnitSystem.metric => 'metric',
        UnitSystem.imperial => 'imperial',
      };

      await _supabase.from('profile').update({
        'unit_system': unitSystemString,
      }).eq('user_id', userId);
    } catch (e, st) {
      _logger.e('Failed to save unit system preference', e, st);
      if (e is SavePreferencesException) rethrow;
      throw SavePreferencesException(e.toString());
    }
  }

  ThemeMode _parseThemeMode(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  UnitSystem _parseUnitSystem(String? value) {
    return switch (value) {
      'imperial' => UnitSystem.imperial,
      _ => UnitSystem.metric,
    };
  }
}

/// Provides the settings repository instance.
@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
