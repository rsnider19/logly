# 04 - Activity Catalog

## Overview

The activity catalog manages the master list of activities users can log. Activities are organized into 6 fixed categories, with subactivities providing more specific options. Activity search uses hybrid semantic + full-text search via an edge function.

## Requirements

### Functional Requirements

- [x] Load all activity categories from database
- [x] Load activities by category
- [x] Load subactivities for each activity
- [x] Load activity detail configurations
- [x] Search activities with semantic + FTS hybrid search
- [x] Get popular activities for onboarding/favorites
- [ ] Create custom activities (premium feature)
- [x] Cache activities locally for offline access

### Non-Functional Requirements

- [ ] Initial catalog load must complete within 2 seconds
- [ ] Search results must appear within 500ms
- [x] Categories and activities must be available offline

## Architecture

### Category Structure

| Category | Code | Color |
|----------|------|-------|
| Fitness | fitness | #FF6B6B |
| Sports | sports | #4ECDC4 |
| Wellness | wellness | #95E1D3 |
| Lifestyle | lifestyle | #DDA0DD |
| Health | health | #98D8C8 |
| Other | other | #B0B0B0 |

### Activity Detail Types

| Type | Widget | Value Storage |
|------|--------|---------------|
| `duration` | Hours/Minutes/Seconds inputs + slider | `duration_in_sec` |
| `distance` | Input + unit selector + slider | `distance_in_meters` |
| `integer` | Input + slider | `numeric_value` |
| `double` | Input + slider | `numeric_value` |
| `environment` | Indoor/Outdoor segment | `environment_value` |
| `liquidVolume` | Input + unit selector + slider | `liquid_volume_in_liters` |
| `weight` | Input + unit selector + slider | `weight_in_kilograms` |

### Search Architecture

```
User Query → Edge Function → Generate Embedding → Hybrid Search
                                                      ↓
                                              (Semantic + FTS + Trigram)
                                                      ↓
                                              Ranked Results
```

## Components

### Files to Create

```
lib/features/activity_catalog/
├── data/
│   ├── category_repository.dart
│   ├── activity_repository.dart
│   ├── sub_activity_repository.dart
│   └── activity_detail_repository.dart
├── domain/
│   ├── activity_category.dart
│   ├── activity.dart
│   ├── sub_activity.dart
│   ├── activity_detail.dart
│   ├── activity_detail_type.dart
│   └── catalog_exception.dart
└── presentation/
    ├── providers/
    │   ├── category_provider.dart
    │   ├── activity_provider.dart
    │   ├── search_provider.dart
    │   └── catalog_service_provider.dart
    └── widgets/
        ├── activity_chip.dart
        ├── category_section.dart
        └── activity_search_field.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `ActivityCategory` | Freezed model for categories |
| `Activity` | Freezed model for activities |
| `SubActivity` | Freezed model for subactivities |
| `ActivityDetail` | Freezed model for detail configurations |
| `CatalogService` | Coordinates catalog data access |
| `ActivityChip` | Reusable chip widget for activities |

## Data Operations

### Load Categories

```dart
Future<List<ActivityCategory>> getCategories() async {
  final response = await _supabase
      .from('activity_category')
      .select()
      .order('sort_order');
  return (response as List).map((e) => ActivityCategory.fromJson(e)).toList();
}
```

### Load Activities by Category

```dart
Future<List<Activity>> getActivitiesByCategory(String categoryId) async {
  final response = await _supabase
      .from('activity')
      .select('*, activity_detail(*), sub_activity(*)')
      .eq('activity_category_id', categoryId)
      .order('name');
  return (response as List).map((e) => Activity.fromJson(e)).toList();
}
```

### Search Activities

```dart
Future<List<Activity>> searchActivities(String query) async {
  final response = await _supabase.functions.invoke(
    'activity/search',
    body: {'query': query, 'limit': 20},
  );
  return (response.data as List).map((e) => Activity.fromJson(e)).toList();
}
```

### Get Popular Activities

```dart
Future<List<Activity>> getPopularActivities() async {
  final response = await _supabase.rpc('popular_activities');
  return (response as List).map((e) => Activity.fromJson(e)).toList();
}
```

### Create Custom Activity (Premium)

```dart
Future<Activity> createCustomActivity({
  required String name,
  required String categoryId,
  List<ActivityDetailInput>? details,
}) async {
  // Check premium entitlement first
  final hasFeature = await _subscriptionService.hasFeature(FeatureCode.customActivity);
  if (!hasFeature) throw PremiumRequiredException('custom_activity');

  final response = await _supabase
      .from('activity')
      .insert({
        'name': name,
        'activity_category_id': categoryId,
        'activity_code': _generateCode(name),
        'activity_date_type': 'single',
      })
      .select()
      .single();

  // Insert activity details if provided
  if (details != null) {
    await _insertActivityDetails(response['activity_id'], details);
  }

  return Activity.fromJson(response);
}
```

## Database Schema Reference

### activity

| Column | Type | Description |
|--------|------|-------------|
| activity_id | uuid | Primary key |
| activity_category_id | uuid | FK to category |
| name | text | Display name |
| activity_code | text | Unique code |
| icon | text | Icon name |
| hex_color | text | Optional override color |
| pace_type | enum | How to calculate pace |
| activity_date_type | enum | 'single' or 'range' |
| is_suggested_favorite | boolean | Show in popular |
| created_by | uuid | Creator (system or user) |

### activity_detail

| Column | Type | Description |
|--------|------|-------------|
| activity_detail_id | uuid | Primary key |
| activity_id | uuid | FK to activity |
| label | text | Display label |
| activity_detail_type | enum | Type of detail |
| sort_order | int | Display order |
| min_*/max_* | numeric | Value bounds |
| metric_uom / imperial_uom | enum | Units |
| use_for_pace_calculation | boolean | Include in pace calc |

## Integration Points

- **Activity Logging**: Provides activity and detail configurations
- **Home**: Provides activity display info for chips
- **Profile**: Categories for filtering stats
- **Onboarding**: Popular activities for favorites selection
- **Subscriptions**: Custom activity creation gated

## Testing Requirements

### Unit Tests

- [ ] Category repository fetches all categories
- [ ] Activity repository handles joins correctly
- [ ] Search filters and ranks results

### Widget Tests

- [ ] ActivityChip displays correct colors and icons
- [ ] CategorySection expands/collapses
- [ ] Search field debounces input

### Integration Tests

- [ ] Full catalog loads within performance budget
- [ ] Search edge function returns relevant results
- [ ] Custom activity creation persists correctly

## Success Criteria

- [x] All 6 categories load correctly
- [x] Activities display with correct details
- [x] Subactivities load for each activity
- [x] Search returns relevant results
- [x] Popular activities shown in onboarding
- [ ] Custom activity creation works (premium)
- [x] Offline access via cached data
- [ ] Detail configurations render correct widgets
