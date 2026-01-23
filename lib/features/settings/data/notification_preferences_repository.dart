import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/shared_preferences_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/settings/domain/notification_exception.dart';
import 'package:logly/features/settings/domain/notification_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notification_preferences_repository.g.dart';

/// Repository for notification preferences stored locally.
class NotificationPreferencesRepository {
  NotificationPreferencesRepository(this._prefs, this._logger);

  final SharedPreferences _prefs;
  final LoggerService _logger;

  static const _prefsKey = 'notification_preferences';

  /// Gets the current notification preferences.
  NotificationPreferences getPreferences() {
    try {
      final json = _prefs.getString(_prefsKey);
      if (json == null) {
        return const NotificationPreferences();
      }
      return NotificationPreferences.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (e, st) {
      _logger.e('Failed to load notification preferences', e, st);
      // Return defaults on error
      return const NotificationPreferences();
    }
  }

  /// Saves the notification preferences.
  Future<void> savePreferences(NotificationPreferences preferences) async {
    try {
      final json = jsonEncode(preferences.toJson());
      await _prefs.setString(_prefsKey, json);
    } catch (e, st) {
      _logger.e('Failed to save notification preferences', e, st);
      throw SaveNotificationPreferencesException(e.toString());
    }
  }

  /// Sets the enabled state.
  Future<void> setEnabled(bool enabled) async {
    final current = getPreferences();
    await savePreferences(current.copyWith(enabled: enabled));
  }

  /// Sets the reminder time.
  Future<void> setReminderTime(TimeOfDay time) async {
    final current = getPreferences();
    await savePreferences(current.copyWith(reminderTime: time));
  }
}

/// Provides the notification preferences repository instance.
@Riverpod(keepAlive: true)
NotificationPreferencesRepository notificationPreferencesRepository(Ref ref) {
  return NotificationPreferencesRepository(
    ref.watch(sharedPreferencesProvider),
    ref.watch(loggerProvider),
  );
}
