import 'package:logly/core/exceptions/app_exception.dart';

/// Exception thrown when notification permission is denied.
class NotificationPermissionException extends AppException {
  const NotificationPermissionException({
    this.isPermanentlyDenied = false,
    String? technicalDetails,
  }) : super(
          isPermanentlyDenied
              ? 'Notification permission permanently denied. Please enable in Settings.'
              : 'Notification permission denied',
          technicalDetails,
        );

  /// Whether the permission is permanently denied.
  final bool isPermanentlyDenied;
}

/// Exception thrown when scheduling a notification fails.
class ScheduleNotificationException extends AppException {
  const ScheduleNotificationException([String? technicalDetails])
      : super('Failed to schedule notification', technicalDetails);
}

/// Exception thrown when canceling a notification fails.
class CancelNotificationException extends AppException {
  const CancelNotificationException([String? technicalDetails])
      : super('Failed to cancel notification', technicalDetails);
}

/// Exception thrown when saving notification preferences fails.
class SaveNotificationPreferencesException extends AppException {
  const SaveNotificationPreferencesException([String? technicalDetails])
      : super('Failed to save notification preferences', technicalDetails);
}

/// Exception thrown when loading notification preferences fails.
class LoadNotificationPreferencesException extends AppException {
  const LoadNotificationPreferencesException([String? technicalDetails])
      : super('Failed to load notification preferences', technicalDetails);
}
