// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  enabled: json['enabled'] as bool? ?? false,
  reminderTime: json['reminder_time'] == null
      ? const TimeOfDay(hour: 20, minute: 0)
      : const TimeOfDayConverter().fromJson(
          json['reminder_time'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'reminder_time': const TimeOfDayConverter().toJson(instance.reminderTime),
};
