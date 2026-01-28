# Create Custom Activity Screen

## Overview

The Create Custom Activity screen allows users to define their own activities with customizable tracking fields. Custom activities are stored in the same `activities` table as system activities, differentiated by the `created_by` column containing the user's ID. They appear seamlessly alongside system activities in search results, can be favorited, and support all standard logging functionality.

## Requirements

### Functional Requirements

1. **Activity Definition**
   - Users must select a category from predefined options (Fitness, Sports, Wellness, Lifestyle, Health)
   - Users must provide an activity name (2-50 characters)
   - Activity name must be unique per user (case-insensitive comparison)
   - Activity names may duplicate system activity names
   - Custom activities use the category icon (no custom icon selection)

2. **Activity Details**
   - Users can add 0-10 detail fields (details are optional)
   - Available detail types: Number, Duration, Distance, Environment, Pace
   - Multiple instances of Number, Duration, and Distance are allowed
   - Environment and Pace are limited to single instances
   - Each detail requires a label (type-specific placeholder hints)
   - Numeric details require a maximum value (with sensible defaults)
   - Minimum value is always 0

3. **Number Detail Type**
   - Required: Label, Maximum value
   - User chooses integer or decimal format
   - Default maximum: 100
   - Slider interval: 1 (integer)

4. **Duration Detail Type**
   - Required: Label, Maximum value
   - Default label placeholder: "e.g. Workout Time"
   - Default maximum: 2 hours (7200 seconds)
   - Slider interval: 60 seconds
   - Toggle for "Use for pace calculation" (mutually exclusive)

5. **Distance Detail Type**
   - Required: Label, Maximum value, Distance type (Short/Long)
   - Short (m/yd): Sets metric_uom=meters, imperial_uom=yards
   - Long (km/mi): Sets metric_uom=kilometers, imperial_uom=miles
   - Default maximum: Short=1000, Long=50
   - Slider interval: 0.1
   - Toggle for "Use for pace calculation" (mutually exclusive)

6. **Environment Detail Type**
   - Optional: Custom label (defaults to "Environment")
   - Single instance only
   - No additional configuration needed

7. **Pace Detail Type**
   - Requires one Duration and one Distance marked for pace calculation
   - Shows error state if dependencies not met
   - Dropdown for pace type: minutesPerUom (default), minutesPer100Uom, minutesPer500m, floorsPerMinute
   - Friendly labels based on user's measurement system preference
   - Single instance only

8. **Data Persistence**
   - Custom activities stored in `activities` table with `created_by` = user ID
   - Activity details stored in `activity_details` table
   - `sort_order` = 10 * index (0, 10, 20, 30...)
   - `slider_interval` values: weight=0.1, integer=1, liquidVolume=1, duration=60, distance=0.1

### Non-Functional Requirements

1. **Limitations**
   - No editing after creation (future feature)
   - No deletion of custom activities (future feature)
   - No sub-activities for custom activities
   - No custom icon selection (future feature)
   - Private to creator only

2. **Behavior**
   - Custom activities appear mixed with system activities in search
   - Custom activities can be favorited
   - No visual distinction from system activities

## Architecture

### Entry Point

- Accessed via Activity Search Screen when search query has no exact match
- "Create Activity" list tile shows with query as title, "Create a custom activity" as subtitle
- Navigation: Regular push to `/activities/create?name={searchQuery}`

### Screen Structure

```
┌─────────────────────────────────────┐
│ ← Cancel    Create Custom Activity  │ Save
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Category Selector (3 per row)   ││
│  │ [Fitness] [Sports] [Wellness]   ││
│  │ [Lifestyle] [Health]            ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Activity Name                   ││
│  │ [____________________________]  ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Duration              [Delete]  ││
│  │ Label: [e.g. Workout Time    ]  ││
│  │ Maximum: [__h] [__m] [__s]      ││
│  │ ○ Use for pace calculation      ││
│  └─────────────────────────────────┘│
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Distance              [Delete]  ││
│  │ ...                             ││
│  └─────────────────────────────────┘│
│                                     │
├─────────────────────────────────────┤
│  Add Detail                         │
│  [Number] [Duration] [Distance]     │
│  [Environment] [Pace]               │
└─────────────────────────────────────┘
```

### Navigation Flow

1. User searches in Activity Search Screen
2. No exact match → "Create {query}" list tile appears
3. Tap → Push to Create Custom Activity Screen (name pre-populated)
4. Fill required fields → Save enabled
5. Save → Create activity in database
6. Success → Replace with Log Activity Screen (new activity selected)
7. Error → Snackbar with retry option

### State Management

- Local form state for all fields
- Validation state for save button enablement
- Loading state for save operation
- Dirty state for discard confirmation

## Components

### Widgets

1. **CreateCustomActivityScreen** - Main screen scaffold
   - AppBar: Cancel button (leading), "Create Custom Activity" title, Save button (action)
   - Body: Scrollable form content
   - Bottom: Sticky "Add Detail" section

2. **CategorySelector** - Category chip grid
   - 3 chips per row, wrapped
   - Sorted by `sort_order` (use `activityCategoriesProvider`)
   - Unselected: category color outline and label
   - Selected: category color fill, white label
   - Required validation with error state

3. **ActivityNameInput** - Name text field
   - Pre-populated from search query
   - Min 2, max 50 characters
   - Case-insensitive duplicate validation
   - Error display for validation failures

4. **DetailCard** - Container for each detail instance
   - Header: Detail type name (left), Delete button (right)
   - Body: Type-specific input fields
   - Always expanded (not collapsible)
   - Individual card styling

5. **NumberDetailForm** - Number detail configuration
   - Label input (required, placeholder: "e.g. Reps, Sets")
   - Integer/Decimal toggle
   - Maximum input (default: 100)

6. **DurationDetailForm** - Duration detail configuration
   - Label input (required, placeholder: "e.g. Workout Time")
   - Maximum inputs: hours, minutes, seconds (default: 2:00:00)
   - "Use for pace calculation" toggle

7. **DistanceDetailForm** - Distance detail configuration
   - Label input (required, placeholder: "e.g. Running Distance")
   - Short/Long segmented control
   - Maximum input (default: 1000 or 50)
   - "Use for pace calculation" toggle

8. **EnvironmentDetailForm** - Environment detail configuration
   - Label input (optional, placeholder: "e.g. Setting")

9. **PaceDetailForm** - Pace detail configuration
   - Error state if Duration/Distance not designated
   - Pace type dropdown (default: minutesPerUom)
   - Read-only pace format preview based on user's measurement preference

10. **AddDetailSection** - Sticky bottom section
    - Text-only chips: Number, Duration, Distance, Environment, Pace
    - Disabled chips when: total limit (10) reached, or single-instance type already added
    - Tapping adds empty instance, scrolls to bottom, auto-focuses label field

### Providers

1. **createCustomActivityFormProvider** - Form state notifier
   - Selected category
   - Activity name
   - List of detail configurations
   - Validation state
   - Dirty state

2. **customActivityValidationProvider** - Derived validation state
   - Category selected check
   - Name valid check
   - All details valid check
   - Pace dependencies check

3. **userCustomActivitiesProvider** - User's existing custom activity names
   - For duplicate name validation

### Routes

```dart
@TypedGoRoute<CreateCustomActivityRoute>(path: '/activities/create')
class CreateCustomActivityRoute extends GoRouteData {
  const CreateCustomActivityRoute({this.name});
  final String? name;  // Pre-populated activity name from search
}
```

## Data Operations

### Create Custom Activity

```dart
Future<Activity> createCustomActivity({
  required String userId,
  required String categoryId,
  required String name,
  required List<ActivityDetailConfig> details,
}) async {
  // 1. Insert activity record
  final activityResponse = await supabase
      .from('activities')
      .insert({
        'activity_category_id': categoryId,
        'name': name,
        'activity_code': _generateActivityCode(name),
        'activity_date_type': 'single',
        'created_by': userId,
        'pace_type': _getPaceType(details),
      })
      .select()
      .single();

  // 2. Insert activity details
  if (details.isNotEmpty) {
    final detailRecords = details.asMap().entries.map((e) => {
      'activity_id': activityResponse['activity_id'],
      'label': e.value.label,
      'activity_detail_type': e.value.type.name,
      'sort_order': e.key * 10,
      'slider_interval': _getSliderInterval(e.value.type),
      ...e.value.toDbFields(),
    }).toList();

    await supabase.from('activity_details').insert(detailRecords);
  }

  // 3. Fetch complete activity with details
  return activityRepository.getById(activityResponse['activity_id']);
}
```

### Validate Activity Name

```dart
Future<bool> isNameUnique(String userId, String name) async {
  final existing = await supabase
      .from('activities')
      .select('activity_id')
      .eq('created_by', userId)
      .ilike('name', name)
      .maybeSingle();

  return existing == null;
}
```

## Integration

### With Activity Search Screen

- Add "Create Activity" list tile when:
  - Search query exists AND
  - No exact match (case-insensitive) in results
- List tile navigates to: `CreateCustomActivityRoute(name: searchQuery).push(context)`

### With Log Activity Screen

- After successful creation:
  - `LogActivityRoute(activityId: newActivity.activityId).pushReplacement(context)`
- New custom activity works identically to system activities

### With Favorites

- Custom activities can be favorited via existing favorite system
- Appear in Favorites section of Activity Search Screen

## Testing Requirements

### Unit Tests

1. **Form Validation**
   - Category selection required
   - Name length validation (2-50)
   - Name uniqueness validation (case-insensitive)
   - Detail label required
   - Maximum value required and valid
   - Pace dependency validation

2. **Data Transformation**
   - Detail config to database fields
   - Sort order calculation
   - Slider interval assignment
   - Activity code generation

3. **State Management**
   - Add/remove detail instances
   - Toggle pace calculation designation
   - Dirty state tracking
   - Validation state derivation

### Widget Tests

1. **CategorySelector**
   - Renders all categories in correct order
   - Single selection behavior
   - Visual states (selected/unselected)
   - Error state display

2. **DetailCard**
   - Delete button removes instance
   - Header displays correct type
   - Form fields render correctly

3. **AddDetailSection**
   - Chips disabled at limit
   - Single-instance types disabled when added
   - Adding scrolls and focuses

4. **CreateCustomActivityScreen**
   - Save button disabled until valid
   - Discard confirmation on back
   - Loading state during save
   - Error snackbar display

### Integration Tests

1. **Full Flow**
   - Search → Create → Save → Log Activity
   - Custom activity appears in future searches
   - Custom activity can be logged
   - Custom activity can be favorited

## Future Considerations

1. **Editing Custom Activities** - Allow modifying name, category, and details after creation
2. **Deleting Custom Activities** - Soft delete with preserved log entries
3. **Custom Icons** - Icon library or emoji picker for personalization
4. **Sharing** - Share custom activity definitions with other users
5. **Import/Export** - Backup and restore custom activity configurations
6. **Templates** - Pre-defined custom activity templates for common use cases

## Success Criteria

- [ ] User can create a custom activity with just name and category
- [ ] User can add up to 10 detail fields of various types
- [ ] Multiple Number, Duration, Distance instances work correctly
- [ ] Environment and Pace limited to single instances
- [ ] Pace shows error when dependencies not met
- [ ] Pace calculation designation toggles work (mutual exclusion)
- [ ] Custom activity appears in search results
- [ ] Custom activity can be logged
- [ ] Custom activity can be favorited
- [ ] Form validation prevents invalid submissions
- [ ] Discard confirmation prevents accidental data loss
- [ ] Error handling with retry works correctly

## Items to Complete

- [ ] Create domain model: `ActivityDetailConfig` for form state
- [ ] Create route: `CreateCustomActivityRoute` in routes.dart
- [ ] Create screen: `CreateCustomActivityScreen`
- [ ] Create widget: `CategorySelector`
- [ ] Create widget: `ActivityNameInput`
- [ ] Create widget: `DetailCard`
- [ ] Create widget: `NumberDetailForm`
- [ ] Create widget: `DurationDetailForm`
- [ ] Create widget: `DistanceDetailForm`
- [ ] Create widget: `EnvironmentDetailForm`
- [ ] Create widget: `PaceDetailForm`
- [ ] Create widget: `AddDetailSection`
- [ ] Create provider: `createCustomActivityFormProvider`
- [ ] Create provider: `customActivityValidationProvider`
- [ ] Create repository method: `createCustomActivity`
- [ ] Create repository method: `isNameUnique`
- [ ] Create service method: `createCustomActivity`
- [ ] Update Activity Search Screen to show "Create Activity" list tile
- [ ] Add navigation from search to create screen
- [ ] Add navigation from create screen to log activity screen
- [ ] Write unit tests for validation logic
- [ ] Write unit tests for data transformation
- [ ] Write widget tests for form components
- [ ] Write integration test for full flow
