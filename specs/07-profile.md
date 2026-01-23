# 07 - Profile Screen

## Overview

The profile screen displays user statistics and progress visualizations. It features collapsible sections for streak information, category summary, a GitHub-style contribution graph, and a 12-month stacked bar chart.

## Requirements

### Functional Requirements

- [x] Display current and longest streak
- [x] Show category summary with progress bars
- [x] Support time period filtering (1W, 1M, 1Y, All)
- [x] Display GitHub-style contribution graph for last year
- [x] Show last 12 months as stacked bar chart
- [x] Support category filtering on 12-month chart
- [x] Make all sections collapsible
- [x] Animate progress bars and charts

### Non-Functional Requirements

- [ ] Stats must load within 2 seconds
- [x] Charts must render smoothly
- [x] Collapsing animations must be fluid

## Architecture

### Section Structure

```
Profile Screen
├── Streak Card (collapsible)
│   ├── Current Streak
│   └── Longest Streak
├── Summary Card (collapsible)
│   ├── Time Period Selector (1W/1M/1Y/All)
│   └── Category Progress Bars
├── Activities Last Year Card (collapsible)
│   ├── Contribution Graph (7 rows x 52 cols)
│   └── Legend
└── Last 12 Months Card (collapsible)
    ├── Category Filter Chips
    └── Stacked Bar Chart
```

### Contribution Graph Colors

| Activity Count | Color |
|----------------|-------|
| 0 | Gray (#333333) |
| 1-2 | #033A16 |
| 3-4 | #196C2E |
| 5-6 | #2EA043 |
| 7+ | #56D364 |

## Components

### Files to Create

```
lib/features/profile/
├── data/
│   ├── streak_repository.dart
│   ├── summary_repository.dart
│   └── contribution_repository.dart
├── domain/
│   ├── streak_data.dart
│   ├── category_summary.dart
│   ├── day_activity_count.dart
│   ├── monthly_category_data.dart
│   └── profile_exception.dart
└── presentation/
    ├── screens/
    │   └── profile_screen.dart
    ├── widgets/
    │   ├── streak_card.dart
    │   ├── summary_card.dart
    │   ├── category_progress_bar.dart
    │   ├── contribution_graph.dart
    │   ├── contribution_legend.dart
    │   ├── monthly_chart.dart
    │   ├── stacked_bar.dart
    │   ├── category_filter_chips.dart
    │   └── collapsible_section.dart
    └── providers/
        ├── streak_provider.dart
        ├── summary_provider.dart
        ├── contribution_provider.dart
        └── profile_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `StreakData` | Current and longest streak values |
| `CategorySummary` | Category ID + activity count |
| `DayActivityCount` | Date + count for contribution graph |
| `MonthlyCategoryData` | Month + category breakdown |
| `CollapsibleSection` | Reusable collapsible card wrapper |

## Data Operations

### Get Streak

```dart
Future<StreakData> getStreak() async {
  final response = await _supabase.rpc('user_activity_streak');
  return StreakData.fromJson(response);
}
```

### Get Category Summary

```dart
Future<List<CategorySummary>> getCategorySummary({
  DateTime? startDate,
  DateTime? endDate,
}) async {
  final response = await _supabase.rpc('user_activity_category_summary', params: {
    '_start_date': startDate?.toIso8601String(),
    '_end_date': endDate?.toIso8601String(),
  });
  return (response as List).map((e) => CategorySummary.fromJson(e)).toList();
}
```

### Get Contribution Data

```dart
Future<Map<DateTime, int>> getContributionData() async {
  final endDate = DateTime.now();
  final startDate = endDate.subtract(const Duration(days: 365));

  final response = await _supabase.rpc('user_activity_day_count', params: {
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
  });

  return Map.fromEntries(
    (response as List).map((e) => MapEntry(
      DateTime.parse(e['date']),
      e['count'] as int,
    )),
  );
}
```

### Get Monthly Category Data

```dart
Future<List<MonthlyCategoryData>> getMonthlyData({
  String? categoryId,
}) async {
  final response = await _supabase.rpc('user_activity_category_monthly', params: {
    '_activity_category_id': categoryId,
  });
  return (response as List).map((e) => MonthlyCategoryData.fromJson(e)).toList();
}
```

## Database Schema Reference

### _user_activity_streak

| Column | Type | Description |
|--------|------|-------------|
| user_id | uuid | User reference |
| current_streak | int | Current consecutive days |
| longest_streak | int | All-time longest streak |
| workout_days_this_week | int | Days active this week |

### _user_activity_category_summary (Function)

| Column | Type | Description |
|--------|------|-------------|
| user_id | uuid | User reference |
| activity_category_id | uuid | Category reference |
| activity_count | int | Count of activities |

### _user_activity_category_month

| Column | Type | Description |
|--------|------|-------------|
| user_id | uuid | User reference |
| activity_month | date | Month (first day) |
| activity_category_id | uuid | Category reference |
| activity_count | int | Count for month/category |

## Integration Points

- **Home**: Accessed via bottom navigation
- **Activity Catalog**: Categories for filtering and display
- **Activity Logging**: Data comes from logged activities

## Testing Requirements

### Unit Tests

- [ ] StreakRepository calculates streaks correctly
- [ ] SummaryRepository filters by date range
- [ ] ContributionRepository generates correct map

### Widget Tests

- [ ] StreakCard displays both values
- [ ] Progress bars animate on load
- [ ] Contribution graph renders correct colors
- [ ] Category filter updates chart
- [ ] Sections collapse/expand

### Integration Tests

- [ ] Full profile loads with real data
- [ ] Time period changes update summary
- [ ] Category filter updates 12-month chart

## Success Criteria

- [x] Streak displays current and longest values
- [x] Summary shows all categories with progress bars
- [x] Time period filter updates summary data
- [x] Contribution graph shows last year
- [x] Correct colors based on activity count
- [x] Legend displays color scale
- [x] 12-month chart shows stacked bars
- [x] Category filter chips work
- [x] All sections collapsible
- [x] Animations are smooth
- [x] Horizontal scroll for contribution graph
