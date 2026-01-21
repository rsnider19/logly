# 10 - Health Integration

## Overview

Health integration enables automatic syncing of workout data from Apple Health (iOS) and Google Fit (Android). Synced workouts are automatically converted to Logly activity entries using a mapping table, allowing users to see all their activities in one place.

## Requirements

### Functional Requirements

- [ ] Request health data permissions (WORKOUT type)
- [ ] Sync workout data from Apple Health (iOS)
- [ ] Sync workout data from Google Fit (Android)
- [ ] Map external workout types to Logly activities
- [ ] Auto-create log entries from synced workouts
- [ ] Track last sync date per user
- [ ] Handle unmapped workout types gracefully
- [ ] Support manual sync trigger
- [ ] Show sync status in UI

### Non-Functional Requirements

- [ ] Sync must complete within 30 seconds for typical data
- [ ] Background sync should not impact app performance
- [ ] Duplicate detection must prevent duplicate entries

## Architecture

### Sync Flow

```
App Launch → Check Last Sync Date → Fetch New Workouts
                                         ↓
                              Map to Logly Activities
                                         ↓
                              Create User Activity Entries
                                         ↓
                              Store Raw Data in external_data
                                         ↓
                              Update Last Sync Date
```

### Workout Type Mapping

```
Apple Health / Google Fit Workout Type
              ↓
    external_data_mapping table
              ↓
    Logly Activity + Subactivity
```

### Data Model

```
external_data (raw workout data)
    ↑
    │ external_data_id
    │
user_activity (logged entry)
```

## Components

### Files to Create

```
lib/features/health_integration/
├── data/
│   ├── health_repository.dart
│   ├── external_data_repository.dart
│   └── workout_mapper.dart
├── domain/
│   ├── health_workout.dart
│   ├── external_data.dart
│   ├── workout_mapping.dart
│   └── health_exception.dart
└── presentation/
    ├── screens/
    │   └── health_settings_screen.dart
    ├── widgets/
    │   ├── sync_status_indicator.dart
    │   └── last_sync_tile.dart
    └── providers/
        ├── health_provider.dart
        ├── sync_provider.dart
        └── health_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `HealthWorkout` | Parsed workout from health package |
| `ExternalData` | Raw data stored in database |
| `WorkoutMapping` | Maps external types to activities |
| `HealthService` | Orchestrates sync process |
| `WorkoutMapper` | Converts workouts to user activities |

## Data Operations

### Request Permissions

```dart
Future<bool> requestPermissions() async {
  final types = [
    HealthDataType.WORKOUT,
    if (Platform.isAndroid) ...[
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.TOTAL_CALORIES_BURNED,
    ],
  ];

  return await Health().requestAuthorization(types, permissions: [
    HealthDataAccess.READ,
  ]);
}
```

### Fetch Workouts

```dart
Future<List<HealthWorkout>> fetchWorkouts({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final health = Health();
  final data = await health.getHealthDataFromTypes(
    types: [HealthDataType.WORKOUT],
    startTime: startDate,
    endTime: endDate,
  );

  return data.map((d) => HealthWorkout.fromHealthData(d)).toList();
}
```

### Get Workout Mappings

```dart
Future<Map<String, WorkoutMapping>> getWorkoutMappings() async {
  final response = await _supabase
      .from('external_data_mapping')
      .select('*, activity:activity_id(*), sub_activity:sub_activity_id(*)');

  return Map.fromEntries(
    (response as List).map((e) => MapEntry(
      e['source_name'] as String,
      WorkoutMapping.fromJson(e),
    )),
  );
}
```

### Sync Workouts

```dart
Future<SyncResult> syncWorkouts() async {
  // Get last sync date
  final profile = await _supabase.rpc('my_profile');
  final lastSync = profile['last_health_sync_date'] != null
      ? DateTime.parse(profile['last_health_sync_date'])
      : DateTime.now().subtract(const Duration(days: 30));

  // Fetch new workouts
  final workouts = await fetchWorkouts(
    startDate: lastSync,
    endDate: DateTime.now(),
  );

  // Get mappings
  final mappings = await getWorkoutMappings();

  // Process each workout
  var created = 0;
  var skipped = 0;

  for (final workout in workouts) {
    final mapping = mappings[workout.workoutType];
    if (mapping == null) {
      skipped++;
      continue;
    }

    // Check for duplicates
    final exists = await _checkDuplicate(workout);
    if (exists) {
      skipped++;
      continue;
    }

    // Store raw data
    final externalData = await _storeExternalData(workout);

    // Create user activity
    await _createUserActivity(workout, mapping, externalData.id);
    created++;
  }

  // Update last sync date
  await _supabase.from('profile').update({
    'last_health_sync_date': DateTime.now().toIso8601String(),
  });

  return SyncResult(created: created, skipped: skipped);
}
```

### Store External Data

```dart
Future<ExternalData> _storeExternalData(HealthWorkout workout) async {
  final response = await _supabase
      .from('external_data')
      .insert({
        'external_data_id': workout.sourceId,
        'external_data_source': 'apple_google',
        'data': workout.toJson(),
      })
      .select()
      .single();

  return ExternalData.fromJson(response);
}
```

### Create User Activity from Workout

```dart
Future<void> _createUserActivity(
  HealthWorkout workout,
  WorkoutMapping mapping,
  String externalDataId,
) async {
  final userActivity = {
    'activity_id': mapping.activityId,
    'activity_timestamp': workout.startTime.toIso8601String(),
    'external_data_id': externalDataId,
  };

  final details = <Map<String, dynamic>>[];

  // Add duration if available
  if (workout.duration != null) {
    details.add({
      'activity_detail_type': 'duration',
      'duration_in_sec': workout.duration!.inSeconds,
    });
  }

  // Add distance if available
  if (workout.distance != null) {
    details.add({
      'activity_detail_type': 'distance',
      'distance_in_meters': workout.distance,
    });
  }

  await _supabase.rpc('log_activity_with_details', params: {
    'p_user_activity': userActivity,
    'p_user_activity_details': details,
  });
}
```

## Database Schema Reference

### external_data

| Column | Type | Description |
|--------|------|-------------|
| external_data_id | text | Source system's ID |
| user_id | uuid | FK to profile |
| external_data_source | enum | 'apple_google' |
| data | jsonb | Raw workout data |
| created_at | timestamptz | When synced |

### external_data_mapping

| Column | Type | Description |
|--------|------|-------------|
| external_data_mapping_id | uuid | Primary key |
| source_name | text | Workout type name |
| external_data_source | enum | Source system |
| activity_id | uuid | Mapped activity |
| sub_activity_id | uuid | Optional subactivity |

### profile

| Column | Type | Description |
|--------|------|-------------|
| last_health_sync_date | timestamptz | Last successful sync |

## Integration Points

- **Onboarding**: Permission request during onboarding
- **Settings**: Toggle sync on/off, manual sync trigger
- **Activity Logging**: Synced activities appear in daily list
- **Profile**: Synced activities count in stats

## Testing Requirements

### Unit Tests

- [ ] WorkoutMapper converts types correctly
- [ ] Duplicate detection works
- [ ] Date range calculations correct

### Integration Tests

- [ ] Full sync flow with mock health data
- [ ] Mappings applied correctly
- [ ] Duplicates prevented

## Success Criteria

- [ ] Permissions requested correctly per platform
- [ ] Workouts fetched from health platform
- [ ] Workout types mapped to Logly activities
- [ ] Unmapped types handled gracefully
- [ ] User activities created from workouts
- [ ] Raw data stored in external_data
- [ ] Last sync date updated
- [ ] Duplicates prevented
- [ ] Manual sync trigger works
- [ ] Sync status displayed in UI
