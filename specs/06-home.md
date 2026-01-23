# 06 - Home Screen

## Overview

The home screen is the primary interface users see after authentication. It displays a chronological list of days with logged activities shown as chips. The screen uses a shell route pattern with consistent navigation elements.

## Requirements

### Functional Requirements

- [x] Display shell route with consistent app bar and bottom nav
- [x] Show daily activity list with infinite scroll
- [x] Load ~30 days initially, paginate on scroll
- [x] Display empty rows for days with no activities
- [x] Allow future dates
- [x] Show activity chips with category colors and icons
- [x] Tap chip to edit logged activity
- [x] Tap row (outside chip) to log new activity for that date
- [x] Display Global Trending Activities bottom sheet
- [x] Navigate between Home, Profile, and Settings

### Non-Functional Requirements

- [ ] Initial load must complete within 2 seconds
- [x] Scroll must be smooth (60fps)
- [x] List must support thousands of days without performance degradation

## Architecture

### Shell Route Structure

```
ShellRoute (AppShell)
├── HomeRoute (/) - Daily activity list
├── ProfileRoute (/profile) - Stats and graphs
└── SettingsRoute (/settings) - User settings
```

### App Bar

| Element | Position | Action |
|---------|----------|--------|
| Route Title | Left | None |
| Globe Icon | Right | Opens Trending bottom sheet |
| Settings Icon | Right | Navigates to Settings |

### Bottom Navigation

| Element | Position | Action |
|---------|----------|--------|
| Profile Picture | Left | Navigate to Profile |
| Logly Icon | Center | Navigate to Home, scroll to top |
| Plus Icon | Right | Open Log Activity (full screen modal) |

### Daily List Item

```
┌────────────────────────────────────────────────────────┐
│ Mon   │ [Running 🏃] [Yoga 🧘] [Meditation 🧘‍♂️] →     │
│ 01/21 │                                                │
└────────────────────────────────────────────────────────┘
```

## Components

### Files to Create

```
lib/features/home/
├── data/
│   ├── daily_activities_repository.dart
│   └── trending_repository.dart
├── domain/
│   ├── daily_activity_summary.dart
│   ├── trending_activity.dart
│   └── home_exception.dart
└── presentation/
    ├── screens/
    │   └── home_screen.dart
    ├── widgets/
    │   ├── app_shell.dart
    │   ├── custom_app_bar.dart
    │   ├── custom_bottom_nav.dart
    │   ├── daily_activity_row.dart
    │   ├── activity_chip_list.dart
    │   └── trending_bottom_sheet.dart
    └── providers/
        ├── daily_activities_provider.dart
        ├── trending_provider.dart
        └── home_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `DailyActivitySummary` | Day + list of logged activities |
| `TrendingActivity` | Activity with rank change info |
| `AppShell` | Shell route wrapper with app bar/bottom nav |
| `DailyActivityRow` | Single day row with chips |
| `TrendingBottomSheet` | Global trending activities list |

## Data Operations

### Load Daily Activities

```dart
Future<List<DailyActivitySummary>> getDailyActivities({
  required DateTime startDate,
  required DateTime endDate,
}) async {
  final response = await _supabase
      .rpc('user_activities_by_date')
      .gte('activity_date', startDate.toIso8601String())
      .lte('activity_date', endDate.toIso8601String())
      .order('activity_date', ascending: false);

  return (response as List).map((e) => DailyActivitySummary.fromJson(e)).toList();
}
```

### Get Trending Activities

```dart
Future<List<TrendingActivity>> getTrendingActivities() async {
  final response = await _supabase
      .rpc('global_trending_activity')
      .select('*, activity:activity_id(name, icon, hex_color, activity_category:activity_category_id(hex_color))')
      .limit(25);

  return (response as List).map((e) => TrendingActivity.fromJson(e)).toList();
}
```

### Paginate Daily Activities

```dart
class DailyActivitiesNotifier extends AsyncNotifier<List<DailyActivitySummary>> {
  DateTime _oldestLoaded = DateTime.now();

  Future<void> loadMore() async {
    final newEnd = _oldestLoaded.subtract(const Duration(days: 1));
    final newStart = newEnd.subtract(const Duration(days: 30));

    final moreActivities = await _repository.getDailyActivities(
      startDate: newStart,
      endDate: newEnd,
    );

    state = AsyncData([...state.value!, ...moreActivities]);
    _oldestLoaded = newStart;
  }
}
```

## Database Schema Reference

### _user_activities_by_date (Materialized View)

| Column | Type | Description |
|--------|------|-------------|
| user_id | uuid | User reference |
| activity_date | date | The date |
| activity_count | int | Number of activities |
| user_activities | jsonb | Array of activity details |

### trending_activity

| Column | Type | Description |
|--------|------|-------------|
| activity_id | uuid | FK to activity |
| current_rank | int | Current position |
| previous_rank | int | Previous position |
| rank_change | int | Change in rank |

## Integration Points

- **Auth**: User ID for fetching activities
- **Activity Logging**: Tap chip opens edit, tap row opens log
- **Profile**: Bottom nav navigates to profile
- **Settings**: App bar and bottom nav navigate to settings

## Testing Requirements

### Unit Tests

- [ ] DailyActivitiesRepository handles pagination
- [ ] TrendingRepository parses rank changes
- [ ] Date range calculations correct

### Widget Tests

- [ ] DailyActivityRow displays date correctly
- [ ] Activity chips show correct colors
- [ ] Empty days show empty row
- [ ] Infinite scroll triggers load more

### Integration Tests

- [ ] Full list loads with real data
- [ ] Tap chip navigates to edit screen
- [ ] Tap row navigates to log screen
- [ ] Trending bottom sheet displays activities

## Success Criteria

- [x] Shell route displays consistent navigation
- [x] Daily list loads with ~30 days
- [x] Infinite scroll loads more days
- [x] Empty days display correctly
- [x] Future dates accessible
- [x] Activity chips colored by category
- [x] Chip tap opens edit screen
- [x] Row tap opens log screen for date
- [x] Trending bottom sheet shows top 25
- [x] Trending icons show up/down/same
- [x] Navigation between Home/Profile/Settings works
- [x] Log button opens full screen modal
