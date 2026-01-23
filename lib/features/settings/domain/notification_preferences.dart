import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences.freezed.dart';
part 'notification_preferences.g.dart';

/// Notification preferences model.
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    /// Whether notifications are enabled.
    @Default(false) bool enabled,

    /// The time for the daily reminder notification.
    @TimeOfDayConverter() @Default(TimeOfDay(hour: 20, minute: 0)) TimeOfDay reminderTime,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

/// JSON converter for TimeOfDay.
class TimeOfDayConverter implements JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'] as int? ?? 20,
      minute: json['minute'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) {
    return {
      'hour': object.hour,
      'minute': object.minute,
    };
  }
}
