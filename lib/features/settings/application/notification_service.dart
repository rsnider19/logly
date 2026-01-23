import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/settings/data/notification_preferences_repository.dart';
import 'package:logly/features/settings/domain/notification_exception.dart';
import 'package:logly/features/settings/domain/notification_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

part 'notification_service.g.dart';

/// Permission status for notifications.
enum NotificationPermissionStatus {
  /// Permission has been granted.
  granted,

  /// Permission has been denied.
  denied,

  /// Permission has been permanently denied.
  permanentlyDenied,
}

/// Service for managing notifications.
class NotificationService {
  NotificationService(this._repository, this._logger);

  final NotificationPreferencesRepository _repository;
  final LoggerService _logger;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _dailyReminderId = 0;
  static const _channelId = 'logly_reminders';
  static const _channelName = 'Daily Reminders';
  static const _channelDescription = 'Daily reminder to log your activities';

  bool _initialized = false;

  /// Initializes the notification service.
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_getLocalTimezoneName()));

    // Initialize flutter_local_notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              description: _channelDescription,
              importance: Importance.defaultImportance,
            ),
          );
    }

    _initialized = true;
    _logger.i('NotificationService initialized');

    // Reschedule notification if enabled
    final prefs = _repository.getPreferences();
    if (prefs.enabled) {
      await scheduleDailyReminder(prefs.reminderTime);
    }
  }

  String _getLocalTimezoneName() {
    try {
      // Try to get the timezone from the device
      final offset = DateTime.now().timeZoneOffset;
      final hours = offset.inHours;

      // Build a simple timezone name based on offset
      if (hours >= 0) {
        return 'Etc/GMT-$hours';
      } else {
        return 'Etc/GMT+${hours.abs()}';
      }
    } catch (e) {
      _logger.w('Could not determine timezone, using UTC');
      return 'UTC';
    }
  }

  /// Checks the current notification permission status.
  Future<NotificationPermissionStatus> checkPermissionStatus() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      return _mapPermissionStatus(status);
    } else if (Platform.isIOS) {
      final status = await Permission.notification.status;
      return _mapPermissionStatus(status);
    }
    return NotificationPermissionStatus.granted;
  }

  /// Requests notification permission.
  Future<NotificationPermissionStatus> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      return _mapPermissionStatus(status);
    } else if (Platform.isIOS) {
      // Request via flutter_local_notifications for iOS
      final result = await _plugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      if (result == true) {
        return NotificationPermissionStatus.granted;
      }
      // Check if permanently denied
      final status = await Permission.notification.status;
      return _mapPermissionStatus(status);
    }
    return NotificationPermissionStatus.granted;
  }

  NotificationPermissionStatus _mapPermissionStatus(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted || PermissionStatus.limited => NotificationPermissionStatus.granted,
      PermissionStatus.permanentlyDenied => NotificationPermissionStatus.permanentlyDenied,
      _ => NotificationPermissionStatus.denied,
    };
  }

  /// Enables notifications with the given preferences.
  Future<void> enableNotifications(NotificationPreferences prefs) async {
    await _repository.setEnabled(true);
    await scheduleDailyReminder(prefs.reminderTime);
    _logger.i('Notifications enabled');
  }

  /// Disables notifications.
  Future<void> disableNotifications() async {
    await _repository.setEnabled(false);
    await cancelDailyReminder();
    _logger.i('Notifications disabled');
  }

  /// Sets the reminder time and reschedules if enabled.
  Future<void> setReminderTime(TimeOfDay time) async {
    await _repository.setReminderTime(time);
    final prefs = _repository.getPreferences();
    if (prefs.enabled) {
      await scheduleDailyReminder(time);
    }
    _logger.i('Reminder time set to ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
  }

  /// Schedules a daily reminder notification.
  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    try {
      await cancelDailyReminder();

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.zonedSchedule(
        _dailyReminderId,
        'Logly Reminder',
        "Don't forget to log your activities today!",
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      _logger.i('Daily reminder scheduled for ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    } catch (e, st) {
      _logger.e('Failed to schedule daily reminder', e, st);
      throw ScheduleNotificationException(e.toString());
    }
  }

  /// Cancels the daily reminder notification.
  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(_dailyReminderId);
      _logger.i('Daily reminder cancelled');
    } catch (e, st) {
      _logger.e('Failed to cancel daily reminder', e, st);
      throw CancelNotificationException(e.toString());
    }
  }

  /// Gets the current notification preferences.
  NotificationPreferences getPreferences() {
    return _repository.getPreferences();
  }
}

/// Provides the notification service instance.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(
    ref.watch(notificationPreferencesRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
