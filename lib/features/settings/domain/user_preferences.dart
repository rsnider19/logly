import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// Unit system options.
enum UnitSystem { metric, imperial }

/// User preferences model.
@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// The user's preferred theme mode.
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,

    /// Whether health sync is enabled.
    @Default(false) bool healthSyncEnabled,

    /// The user's preferred unit system.
    @UnitSystemConverter() @Default(UnitSystem.metric) UnitSystem unitSystem,

    /// Whether haptic feedback on scroll is enabled.
    @Default(true) bool hapticFeedbackEnabled,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
}

/// JSON converter for ThemeMode.
class ThemeModeConverter implements JsonConverter<ThemeMode, String?> {
  const ThemeModeConverter();

  @override
  ThemeMode fromJson(String? json) {
    return switch (json) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  String toJson(ThemeMode object) {
    return switch (object) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}

/// JSON converter for UnitSystem.
class UnitSystemConverter implements JsonConverter<UnitSystem, String?> {
  const UnitSystemConverter();

  @override
  UnitSystem fromJson(String? json) {
    return switch (json) {
      'imperial' => UnitSystem.imperial,
      _ => UnitSystem.metric,
    };
  }

  @override
  String toJson(UnitSystem object) {
    return switch (object) {
      UnitSystem.imperial => 'imperial',
      UnitSystem.metric => 'metric',
    };
  }
}
