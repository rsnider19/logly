# 05 - Activity Logging

## Overview

Activity logging is the core user interaction in Logly. Users select an activity, fill in optional details (duration, distance, etc.), select subactivities, and save the log entry. This feature handles both creating new logs and editing existing ones.

## Requirements

### Functional Requirements

- [ ] Display activity search/selection screen
- [ ] Show already-logged activities for the selected date
- [ ] Render conditional detail fields based on activity type
- [ ] Support subactivity multi-select
- [ ] Allow custom name override (premium)
- [ ] Handle multi-day activities (date range)
- [ ] Calculate and display pace when applicable
- [ ] Save log entries to database
- [ ] Edit existing log entries
- [ ] Delete log entries with confirmation
- [ ] Favorite/unfavorite activities

### Non-Functional Requirements

- [ ] Log save must complete within 2 seconds
- [ ] Detail fields must be responsive to slider/input changes
- [ ] Form state must not be lost on keyboard dismiss

## Architecture

### Log Entry Flow

```
Activity Search → Select Activity → Log Activity Screen
                                         ↓
                                  Fill Details (optional)
                                         ↓
                                  Select Subactivities (optional)
                                         ↓
                                  Save → Create N entries for date range
```

### Detail Field Types

| Type | UI Components | Storage |
|------|---------------|---------|
| Duration | 3 inputs (h/m/s) + slider | `duration_in_sec` |
| Distance | Input + unit toggle + slider | `distance_in_meters` |
| Numeric (int/double) | Input + slider | `numeric_value` |
| Environment | Indoor/Outdoor segment | `environment_value` |
| Liquid Volume | Input + unit toggle + slider | `liquid_volume_in_liters` |
| Weight | Input + unit toggle + slider | `weight_in_kilograms` |

### Pace Calculation

Pace is calculated when both duration and distance are present:

| Pace Type | Formula | Display |
|-----------|---------|---------|
| `minutesPerUom` | duration / distance | "10:05 min/mi" |
| `minutesPer100Uom` | duration / (distance / 100) | "1:45 min/100m" |
| `minutesPer500m` | duration / (distance / 500) | "2:30 min/500m" |
| `floorsPerMinute` | floors / (duration / 60) | "12 floors/min" |

## Components

### Files to Create

```
lib/features/activity_logging/
├── data/
│   ├── user_activity_repository.dart
│   └── favorite_repository.dart
├── domain/
│   ├── user_activity.dart
│   ├── user_activity_detail.dart
│   ├── create_user_activity.dart
│   └── logging_exception.dart
└── presentation/
    ├── screens/
    │   ├── activity_search_screen.dart
    │   ├── log_activity_screen.dart
    │   ├── edit_activity_screen.dart
    │   └── create_custom_activity_screen.dart
    ├── widgets/
    │   ├── duration_input.dart
    │   ├── distance_input.dart
    │   ├── numeric_input.dart
    │   ├── environment_selector.dart
    │   ├── liquid_volume_input.dart
    │   ├── weight_input.dart
    │   ├── pace_display.dart
    │   ├── subactivity_selector.dart
    │   ├── date_picker_field.dart
    │   └── date_range_picker.dart
    └── providers/
        ├── log_activity_provider.dart
        ├── activity_form_provider.dart
        └── logging_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `UserActivity` | Freezed model for logged activities |
| `UserActivityDetail` | Freezed model for detail values |
| `CreateUserActivity` | Input model for creating logs |
| `LoggingService` | Business logic for logging |
| `ActivityFormProvider` | Manages form state |

## Data Operations

### Log Activity

```dart
Future<void> logActivity({
  required String activityId,
  required DateTime date,
  String? nameOverride,
  String? comments,
  List<String>? subActivityIds,
  Map<String, dynamic>? details,
}) async {
  final userActivity = {
    'activity_id': activityId,
    'activity_timestamp': date.toIso8601String(),
    'activity_name_override': nameOverride,
    'comments': comments,
  };

  final userActivityDetails = details?.entries.map((e) => {
    'activity_detail_id': e.key,
    ...e.value,
  }).toList();

  await _supabase.rpc('log_activity_with_details', params: {
    'p_user_activity': userActivity,
    'p_user_activity_details': userActivityDetails ?? [],
  });
}
```

### Log Multi-Day Activity

```dart
Future<void> logMultiDayActivity({
  required String activityId,
  required DateTime startDate,
  required DateTime endDate,
  // ... other params
}) async {
  final days = endDate.difference(startDate).inDays + 1;

  for (var i = 0; i < days; i++) {
    final date = startDate.add(Duration(days: i));
    await logActivity(
      activityId: activityId,
      date: date,
      // ... other params
    );
  }
}
```

### Update Activity

```dart
Future<void> updateActivity({
  required String userActivityId,
  String? nameOverride,
  String? comments,
  List<String>? subActivityIds,
  Map<String, dynamic>? details,
}) async {
  await _supabase.rpc('update_activity_with_details', params: {
    'p_user_activity': {
      'user_activity_id': userActivityId,
      'activity_name_override': nameOverride,
      'comments': comments,
    },
    'p_user_activity_details': details,
  });
}
```

### Delete Activity

```dart
Future<void> deleteActivity(String userActivityId) async {
  await _supabase
      .from('user_activity')
      .delete()
      .eq('user_activity_id', userActivityId);
}
```

### Toggle Favorite

```dart
Future<void> toggleFavorite(String activityId, bool isFavorite) async {
  if (isFavorite) {
    await _supabase
        .from('favorite_user_activity')
        .insert({'activity_id': activityId});
  } else {
    await _supabase
        .from('favorite_user_activity')
        .delete()
        .eq('activity_id', activityId);
  }
}
```

## Database Schema Reference

### user_activity

| Column | Type | Description |
|--------|------|-------------|
| user_activity_id | uuid | Primary key |
| user_id | uuid | FK to profile |
| activity_id | uuid | FK to activity |
| activity_timestamp | timestamptz | When logged |
| activity_name_override | text | Custom name (premium) |
| comments | text | User notes |
| external_data_id | uuid | FK to health sync data |

### user_activity_detail

| Column | Type | Description |
|--------|------|-------------|
| user_activity_id | uuid | FK to user_activity |
| activity_detail_id | uuid | FK to activity_detail |
| activity_detail_type | enum | Type of detail |
| duration_in_sec | int | Duration value |
| distance_in_meters | numeric | Distance value |
| numeric_value | numeric | Generic numeric |
| environment_value | enum | Indoor/outdoor |
| liquid_volume_in_liters | numeric | Volume value |
| weight_in_kilograms | numeric | Weight value |

## Integration Points

- **Activity Catalog**: Provides activity definitions and detail configs
- **Home**: Logged activities displayed in daily list
- **Profile**: Logged activities power stats
- **Health Integration**: Auto-logged activities from health sync
- **Subscriptions**: Name override gated as premium

## Testing Requirements

### Unit Tests

- [ ] LoggingService validates required fields
- [ ] Pace calculation correct for all types
- [ ] Multi-day creates correct number of entries
- [ ] Unit conversions accurate

### Widget Tests

- [ ] Detail inputs sync with sliders
- [ ] Date picker shows correct date
- [ ] Subactivity selector handles multi-select
- [ ] Form preserves state on rebuild

### Integration Tests

- [ ] Full log flow creates database entry
- [ ] Edit flow updates existing entry
- [ ] Delete removes entry after confirmation

## Success Criteria

- [ ] Activity search returns relevant results
- [ ] All detail field types render correctly
- [ ] Sliders and inputs stay in sync
- [ ] Pace displays when duration and distance present
- [ ] Subactivities can be multi-selected
- [ ] Multi-day activities create N entries
- [ ] Log saves successfully
- [ ] Edit updates correctly
- [ ] Delete confirms and removes
- [ ] Favorites toggle works
- [ ] Name override works (premium only)
