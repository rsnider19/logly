import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logly/features/settings/application/notification_service.dart';
import 'package:logly/features/settings/domain/notification_exception.dart';
import 'package:logly/features/settings/domain/notification_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_preferences_provider.g.dart';

/// Result of enabling notifications.
sealed class EnableNotificationsResult {
  const EnableNotificationsResult();
}

/// Notifications enabled successfully.
class EnableNotificationsSuccess extends EnableNotificationsResult {
  const EnableNotificationsSuccess();
}

/// Notification permission was denied.
class EnableNotificationsDenied extends EnableNotificationsResult {
  const EnableNotificationsDenied();
}

/// Notification permission was permanently denied.
class EnableNotificationsPermanentlyDenied extends EnableNotificationsResult {
  const EnableNotificationsPermanentlyDenied();
}

/// Error enabling notifications.
class EnableNotificationsError extends EnableNotificationsResult {
  const EnableNotificationsError(this.message);
  final String message;
}

/// State notifier for managing notification preferences.
@Riverpod(keepAlive: true)
class NotificationPreferencesStateNotifier extends _$NotificationPreferencesStateNotifier {
  @override
  NotificationPreferences build() {
    final service = ref.read(notificationServiceProvider);
    return service.getPreferences();
  }

  /// Enables notifications with permission handling.
  Future<EnableNotificationsResult> enableNotifications() async {
    final service = ref.read(notificationServiceProvider);

    try {
      // Check current permission status
      var status = await service.checkPermissionStatus();

      // Request permission if not granted
      if (status != NotificationPermissionStatus.granted) {
        status = await service.requestPermission();
      }

      // Handle permission result
      switch (status) {
        case NotificationPermissionStatus.granted:
          final currentPrefs = state;
          await service.enableNotifications(currentPrefs);
          state = currentPrefs.copyWith(enabled: true);
          return const EnableNotificationsSuccess();

        case NotificationPermissionStatus.denied:
          return const EnableNotificationsDenied();

        case NotificationPermissionStatus.permanentlyDenied:
          return const EnableNotificationsPermanentlyDenied();
      }
    } catch (e) {
      if (e is NotificationPermissionException) {
        if (e.isPermanentlyDenied) {
          return const EnableNotificationsPermanentlyDenied();
        }
        return const EnableNotificationsDenied();
      }
      return EnableNotificationsError(e.toString());
    }
  }

  /// Disables notifications.
  Future<void> disableNotifications() async {
    final service = ref.read(notificationServiceProvider);
    final currentState = state;

    // Optimistic update
    state = currentState.copyWith(enabled: false);

    try {
      await service.disableNotifications();
    } catch (e) {
      // Revert on error
      state = currentState;
      rethrow;
    }
  }

  /// Sets the reminder time.
  Future<void> setReminderTime(TimeOfDay time) async {
    final service = ref.read(notificationServiceProvider);
    final currentState = state;

    // Optimistic update
    state = currentState.copyWith(reminderTime: time);

    try {
      await service.setReminderTime(time);
    } catch (e) {
      // Revert on error
      state = currentState;
      rethrow;
    }
  }
}
