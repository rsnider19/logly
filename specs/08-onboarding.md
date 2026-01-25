# 08 - Onboarding

## Overview

Onboarding guides new users through an intro pager, favorite activity selection, and optional health platform connection. Returning users on new devices see pre-populated favorites from their server-synced data.

## Requirements

### Functional Requirements

- [x] Display 3-page intro pager for first-time users
- [x] Show favorite activity selection screen
- [x] Pre-populate favorites for returning users
- [x] Suggest 3+ favorites without enforcing
- [x] Display popular activities section
- [x] Show activities organized by category
- [x] Present Health Connect permission screen
- [x] Track onboarding completion
- [x] Allow skipping health permissions

### Non-Functional Requirements

- [x] Onboarding must complete within 3 screen transitions
- [x] Activity selection must support scrolling through all activities
- [ ] Pre-population must load within 1 second

## Architecture

### Onboarding Flow

```
New User:
Intro Page 1 → Intro Page 2 → Intro Page 3 → Favorites → Health Connect → Home

Returning User (New Device):
Favorites (pre-populated) → Health Connect → Home
```

### Intro Pager Content

| Page | Title | Description |
|------|-------|-------------|
| 1 | Track Everything | Log any activity from fitness to lifestyle |
| 2 | Build Streaks | Stay consistent and build healthy habits |
| 3 | Get Insights | AI-powered analysis of your activity patterns |

### Favorites Selection Layout

```
┌─────────────────────────────────────────────┐
│ Choose your favorite activities             │
│ We recommend selecting at least 3...        │
├─────────────────────────────────────────────┤
│ Selected: [Activity 1] [Activity 2] [...]   │
├─────────────────────────────────────────────┤
│ Here are a few popular ones                 │
│ [Popular 1] [Popular 2] [Popular 3] ...     │
├─────────────────────────────────────────────┤
│ ▼ Fitness                                   │
│ [Running] [Yoga] [Swimming] ...             │
├─────────────────────────────────────────────┤
│ ▼ Sports                                    │
│ [Basketball] [Tennis] [Golf] ...            │
├─────────────────────────────────────────────┤
│ ... (more categories)                       │
├─────────────────────────────────────────────┤
│              [Continue]                     │
└─────────────────────────────────────────────┘
```

## Components

### Files to Create

```
lib/features/onboarding/
├── data/
│   ├── onboarding_repository.dart
│   └── favorite_repository.dart
├── domain/
│   ├── onboarding_state.dart
│   └── onboarding_exception.dart
└── presentation/
    ├── screens/
    │   ├── intro_pager_screen.dart
    │   ├── favorites_selection_screen.dart
    │   └── health_connect_screen.dart
    ├── widgets/
    │   ├── intro_page.dart
    │   ├── page_indicator.dart
    │   ├── selected_favorites_row.dart
    │   ├── popular_activities_section.dart
    │   ├── category_activities_section.dart
    │   └── empty_favorite_chip.dart
    └── providers/
        ├── onboarding_provider.dart
        ├── favorites_selection_provider.dart
        └── onboarding_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `OnboardingState` | Tracks onboarding progress |
| `OnboardingService` | Business logic for onboarding |
| `FavoritesSelectionProvider` | Manages selected favorites |
| `IntroPagerScreen` | 3-page intro carousel |
| `FavoritesSelectionScreen` | Activity selection UI |
| `HealthConnectScreen` | Health permission request |

## Data Operations

### Check Onboarding Status

```dart
Future<bool> hasCompletedOnboarding() async {
  final profile = await _supabase.rpc('my_profile');
  return profile['onboarding_completed'] ?? false;
}
```

### Get Existing Favorites

```dart
Future<List<String>> getExistingFavorites() async {
  final response = await _supabase
      .from('favorite_user_activity')
      .select('activity_id');
  return (response as List).map((e) => e['activity_id'] as String).toList();
}
```

### Save Favorites

```dart
Future<void> saveFavorites(List<String> activityIds) async {
  // Delete existing favorites
  await _supabase.from('favorite_user_activity').delete();

  // Insert new favorites
  final inserts = activityIds.map((id) => {'activity_id': id}).toList();
  await _supabase.from('favorite_user_activity').insert(inserts);
}
```

### Complete Onboarding

```dart
Future<void> completeOnboarding() async {
  await _supabase.from('profile').update({
    'onboarding_completed': true,
  });
}
```

### Get Popular Activities

```dart
Future<List<Activity>> getPopularActivities() async {
  final response = await _supabase.rpc('popular_activities');
  return (response as List).map((e) => Activity.fromJson(e)).toList();
}
```

## Health Connect Flow

### iOS (Apple Health)

1. Show explanation screen
2. On Continue: Request HealthKit authorization
3. Handle permission result
4. Navigate to Home

### Android (Google Fit)

1. Show explanation screen
2. On Continue: Request Health Connect authorization
3. Handle permission result
4. Navigate to Home

```dart
Future<bool> requestHealthPermissions() async {
  final types = [
    HealthDataType.WORKOUT,
    if (Platform.isAndroid) ...[
      HealthDataType.DISTANCE_DELTA,
      HealthDataType.TOTAL_CALORIES_BURNED,
    ],
  ];

  return await Health().requestAuthorization(types);
}
```

## Integration Points

- **Auth**: New users routed to onboarding after first sign-in
- **Activity Catalog**: Activities and categories for selection
- **Health Integration**: Permission request initiates sync setup
- **Home**: Navigate to home after completion

## Testing Requirements

### Unit Tests

- [ ] OnboardingService tracks state correctly
- [ ] Favorites save and load correctly
- [ ] Popular activities fetched correctly

### Widget Tests

- [ ] Intro pager swipes between pages
- [ ] Activity chips toggle selection
- [ ] Selected favorites row updates
- [ ] Continue button enables correctly

### Integration Tests

- [ ] Full onboarding flow completes
- [ ] Returning user sees pre-populated favorites
- [ ] Health permissions requested correctly

## Success Criteria

- [x] Intro pager displays 3 pages with correct content
- [x] Favorites selection shows popular activities
- [x] Favorites selection shows all categories
- [x] Activity chips toggle on tap
- [x] Selected row shows up to 3 favorites (or empty chips)
- [x] Continue navigates to Health Connect screen
- [x] Health Connect explains platform-specific integration
- [x] Skip button bypasses health permissions
- [x] Onboarding completion tracked in database
- [x] Returning users see existing favorites pre-selected
