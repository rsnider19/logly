# 09 - Settings

## Overview

The settings screen provides access to all user preferences, account management, and app configuration options. It includes account info, unit preferences, favorites editing, notifications, appearance, health integration, data export, and account deletion.

## Requirements

### Functional Requirements

- [ ] Display account info (email, profile picture)
- [ ] Allow unit preference selection (metric/imperial)
- [ ] Provide edit favorites shortcut
- [ ] Configure notification preferences
- [ ] Set appearance/theme (light/dark/system)
- [ ] Toggle Health Connect integration
- [ ] Export user data
- [ ] Send feedback
- [ ] Sign out with confirmation
- [ ] Delete account with confirmation

### Non-Functional Requirements

- [ ] Settings must persist across sessions
- [ ] Changes must apply immediately
- [ ] Export must complete within 30 seconds

## Architecture

### Settings Sections

```
Settings Screen
├── Account Section
│   ├── Profile Picture
│   ├── Email
│   └── Subscription Status
├── Preferences Section
│   ├── Unit Preference (Metric/Imperial)
│   ├── Edit Favorites
│   └── Notifications
├── Appearance Section
│   └── Theme (Light/Dark/System)
├── Health Section
│   └── Health Connect Toggle
├── Data Section
│   ├── Export Data
│   └── Send Feedback
└── Account Management Section
    ├── Sign Out
    └── Delete Account
```

### Preference Storage

| Preference | Storage | Default |
|------------|---------|---------|
| Unit System | Local (SharedPreferences) | System locale |
| Theme | Local (SharedPreferences) | System |
| Notifications | Local + Remote | Enabled |
| Health Sync | Remote (profile) | Per onboarding |

## Components

### Files to Create

```
lib/features/settings/
├── data/
│   ├── settings_repository.dart
│   └── export_repository.dart
├── domain/
│   ├── user_preferences.dart
│   ├── export_data.dart
│   └── settings_exception.dart
└── presentation/
    ├── screens/
    │   ├── settings_screen.dart
    │   ├── edit_favorites_screen.dart
    │   └── notification_settings_screen.dart
    ├── widgets/
    │   ├── account_info_tile.dart
    │   ├── unit_preference_tile.dart
    │   ├── theme_selector.dart
    │   ├── health_toggle_tile.dart
    │   ├── export_tile.dart
    │   ├── feedback_tile.dart
    │   ├── sign_out_tile.dart
    │   └── delete_account_tile.dart
    └── providers/
        ├── settings_provider.dart
        ├── preferences_provider.dart
        └── export_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `UserPreferences` | Freezed model for all preferences |
| `SettingsRepository` | Read/write preferences |
| `ExportRepository` | Generate data export |
| `SettingsScreen` | Main settings UI |
| `EditFavoritesScreen` | Reuses onboarding favorites UI |

## Data Operations

### Load Preferences

```dart
Future<UserPreferences> getPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return UserPreferences(
    unitSystem: UnitSystem.values.byName(prefs.getString('unit_system') ?? 'metric'),
    theme: ThemeMode.values.byName(prefs.getString('theme') ?? 'system'),
    notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
  );
}
```

### Save Unit Preference

```dart
Future<void> setUnitSystem(UnitSystem system) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('unit_system', system.name);
}
```

### Save Theme

```dart
Future<void> setTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme', mode.name);
}
```

### Toggle Health Sync

```dart
Future<void> toggleHealthSync(bool enabled) async {
  if (enabled) {
    final granted = await _healthService.requestPermissions();
    if (!granted) return;
  }

  await _supabase.from('profile').update({
    'health_sync_enabled': enabled,
  });
}
```

### Export Data

```dart
Future<ExportData> exportUserData() async {
  final activities = await _supabase
      .from('user_activity')
      .select('*, user_activity_detail(*), user_activity_sub_activity(*)');

  return ExportData(
    exportDate: DateTime.now(),
    activities: activities,
  );
}

Future<File> generateExportFile(ExportData data) async {
  final json = jsonEncode(data.toJson());
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/logly_export_${DateTime.now().millisecondsSinceEpoch}.json');
  await file.writeAsString(json);
  return file;
}
```

### Send Feedback

```dart
Future<void> sendFeedback() async {
  final url = Uri.parse('mailto:feedback@logly.app?subject=Logly Feedback');
  await launchUrl(url);
}
```

### Sign Out

```dart
Future<void> signOut() async {
  await _supabase.auth.signOut();
  await _clearLocalData();
}
```

### Delete Account

```dart
Future<void> deleteAccount() async {
  // Soft delete - sets deletion_requested_at
  await _supabase.functions.invoke('request-account-deletion');
  await signOut();
}
```

## Integration Points

- **Auth**: Sign out and account deletion
- **Core**: Theme provider for app-wide theming
- **Health Integration**: Health sync toggle
- **Onboarding**: Edit favorites reuses selection screen

## Testing Requirements

### Unit Tests

- [ ] SettingsRepository loads correct defaults
- [ ] Preferences persist correctly
- [ ] Export generates valid JSON

### Widget Tests

- [ ] All settings tiles render
- [ ] Unit toggle changes preference
- [ ] Theme selector updates immediately
- [ ] Confirmation dialogs display

### Integration Tests

- [ ] Full settings flow
- [ ] Export downloads file
- [ ] Sign out clears data
- [ ] Delete account soft deletes

## Success Criteria

- [ ] Account info displays correctly
- [ ] Unit preference toggles metric/imperial
- [ ] Edit favorites opens selection screen
- [ ] Notification settings configurable
- [ ] Theme changes apply immediately
- [ ] Health toggle enables/disables sync
- [ ] Export generates downloadable file
- [ ] Feedback opens email client
- [ ] Sign out clears local data
- [ ] Account deletion confirms and soft deletes
- [ ] All changes persist across app restarts
