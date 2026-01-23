// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    _UserPreferences(
      themeMode: json['theme_mode'] == null
          ? ThemeMode.system
          : const ThemeModeConverter().fromJson(json['theme_mode'] as String?),
      healthSyncEnabled: json['health_sync_enabled'] as bool? ?? false,
      unitSystem: json['unit_system'] == null
          ? UnitSystem.metric
          : const UnitSystemConverter().fromJson(
              json['unit_system'] as String?,
            ),
    );

Map<String, dynamic> _$UserPreferencesToJson(_UserPreferences instance) =>
    <String, dynamic>{
      'theme_mode': const ThemeModeConverter().toJson(instance.themeMode),
      'health_sync_enabled': instance.healthSyncEnabled,
      'unit_system': const UnitSystemConverter().toJson(instance.unitSystem),
    };
