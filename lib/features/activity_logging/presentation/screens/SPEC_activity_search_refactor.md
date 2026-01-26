# Activity Search Screen Refactoring

## Overview

Refactor the Activity Search Screen to improve navigation flow, visual consistency, and user experience. This includes converting the favorites section to match category section styling, using outlined chips with icons throughout, persisting expand/collapse state, and implementing proper navigation with push replacement for activity selection.

## Requirements

### Navigation Changes

1. **Activity Selection Navigation**
   - When selecting an activity from the Search Screen, use push replacement to navigate to LogActivityScreen
   - LogActivityScreen replaces the Search Screen entirely in the navigation stack
   - Save action on LogActivityScreen performs a single pop, returning to the initial screen (Home, Profile, etc.)

2. **View All Navigation**
   - "View all" chip navigates to a new Category Detail Screen (regular push, not replacement)
   - Back button from Category Detail Screen returns to Search Screen
   - Selecting an activity from Category Detail Screen replaces the entire modal stack (Search + Category Detail) with LogActivityScreen
   - Save action performs a single pop to initial screen

### Visual Changes

1. **Activity Chips**
   - All activity chips use outlined style (not filled) with neutral border color (onSurface at 25% opacity)
   - All chips display icons alongside activity names
   - Use `ActivityChip` widget with `showIcon: true` and `isFilled: false`

2. **Favorites Section**
   - Convert from horizontal scrolling cards to ExpansionTile pattern matching category sections
   - Section header displays a filled red heart icon (not the current amber star)
   - Activities displayed as outlined chips in a Wrap layout
   - Section hidden entirely when user has no favorites

3. **Category Sections**
   - Each section shows only `is_suggested_favorite = true` activities (use existing `suggestedFavoritesByCategoryProvider`)
   - Sections ordered by `sort_order` of ActivityCategory
   - "View all" chip at end of each Wrap (inline with activity chips)
   - "View all" chip: outlined in category color, label in category color, trailing chevron/arrow icon

4. **Search Results**
   - Display as outlined ActivityChips with icons in a Wrap layout

5. **Already Logged Activities Section**
   - Remains as static Wrap at top (not expandable)
   - Always visible when entries exist for the selected date

### Expand/Collapse State Persistence

1. **Default State**
   - All sections (favorites, categories) default to expanded

2. **SharedPreferences Storage**
   - Key format: `search_section_favorites` for favorites
   - Key format: `search_section_category_{uuid}` for each category
   - Value: boolean indicating expanded state

3. **Lifecycle**
   - State cleared on user logout (user-specific preferences)
   - State persists across app sessions for same user

### Category Detail Screen (New)

1. **App Bar**
   - Back button (leading)
   - Category name as title

2. **Content**
   - All activities in the category displayed as outlined chips in scrollable Wrap
   - No search/filter capability
   - Activities ordered by popularity (descending)

3. **Activity Selection**
   - Push replacement that replaces entire modal stack with LogActivityScreen

## Architecture

### Navigation Flow

```
Initial Screen (Home/Profile)
    |
    v (push modal)
Activity Search Screen
    |
    +--- Select Activity --> (push replacement) --> Log Activity Screen
    |                                                      |
    |                                                      v (pop)
    |                                              Initial Screen
    |
    +--- View All --> (push) --> Category Detail Screen
                                        |
                                        +--- Back --> Activity Search Screen
                                        |
                                        +--- Select Activity --> (replace stack) --> Log Activity Screen
                                                                                            |
                                                                                            v (pop)
                                                                                    Initial Screen
```

### Provider Changes

1. **New Provider: `activityCategoryProvider`** (keepAlive)
   - Fetches all activity categories sorted by `sort_order` ascending
   - Reusable across the app (future refactor will update other usages)
   - Returns `List<ActivityCategory>`

2. **Existing Provider: `suggestedFavoritesByCategoryProvider`**
   - Already exists - fetches activities where `is_suggested_favorite = true` for a given category ID
   - Used by each category section

3. **New Provider: `searchSectionExpansionProvider`**
   - Manages expand/collapse state for all sections
   - Reads initial state from SharedPreferences
   - Writes state changes to SharedPreferences
   - Methods: `isExpanded(String sectionId)`, `toggle(String sectionId)`, `reset()`

### Widget Changes

1. **`ActivitySearchScreen`**
   - Replace Navigator.push with GoRouter push replacement for activity selection
   - Convert favorites from horizontal scroll to ExpansionTile
   - Update category sections to use `suggestedFavoritesByCategoryProvider`
   - Use new `activityCategoryProvider` for category ordering
   - Add "View all" chip to each category section
   - Integrate `searchSectionExpansionProvider` for state persistence

2. **New Widget: `SearchSectionTile`**
   - Reusable ExpansionTile wrapper for favorites and category sections
   - Props: `sectionId`, `title`, `leadingIcon`, `leadingIconColor`, `children`, `trailing` (optional for View all)
   - Integrates with `searchSectionExpansionProvider`

3. **New Widget: `ViewAllChip`**
   - Outlined chip with category color
   - Label "View all" in category color
   - Trailing chevron icon
   - onPressed navigates to Category Detail Screen

4. **New Screen: `CategoryDetailScreen`**
   - Displays all activities for a category
   - Props: `categoryId`, `initialDate` (passed through for logging)

## Components

### Screens

| Screen | File | Description |
|--------|------|-------------|
| ActivitySearchScreen | `activity_search_screen.dart` | Refactored main search screen |
| CategoryDetailScreen | `category_detail_screen.dart` | New screen showing all activities in a category |

### Widgets

| Widget | File | Description |
|--------|------|-------------|
| SearchSectionTile | `search_section_tile.dart` | Expandable section with persistence |
| ViewAllChip | `view_all_chip.dart` | Category-colored chip for navigation |

### Providers

| Provider | File | Description |
|----------|------|-------------|
| activityCategoryProvider | `category_provider.dart` | All categories sorted by sort_order (keepAlive, reusable) |
| searchSectionExpansionProvider | `search_section_expansion_provider.dart` | Expansion state management with SharedPreferences |
| suggestedFavoritesByCategoryProvider | (existing) | Suggested favorites filtered by category |

## Data Operations

### Read Operations

1. **Get all categories ordered by sort_order** (new `activityCategoryProvider`)
   ```sql
   SELECT * FROM activity_categories
   ORDER BY sort_order ASC
   ```

2. **Get suggested favorites by category** (existing provider)
   ```sql
   SELECT * FROM activities
   WHERE category_id = :categoryId
   AND is_suggested_favorite = true
   ORDER BY popularity DESC
   ```

3. **Get all activities by category** (for Category Detail Screen)
   ```sql
   SELECT * FROM activities
   WHERE category_id = :categoryId
   ORDER BY popularity DESC
   ```

### SharedPreferences Operations

1. **Read expansion state**
   - Key: `search_section_{type}_{id}`
   - Default: `true` (expanded)

2. **Write expansion state**
   - Triggered on user toggle
   - Immediate write, no debounce needed

3. **Clear on logout**
   - Remove all keys matching `search_section_*` pattern

## Integration

### GoRouter Updates

1. **Add CategoryDetailScreen route**
   - Path: `/log-activity/category/:categoryId`
   - Parameters: `categoryId`, `initialDate`

2. **Update activity selection navigation**
   - Use `context.pushReplacement` for LogActivityScreen from Search
   - Use stack replacement for LogActivityScreen from Category Detail

### Logout Flow

1. **Clear expansion preferences**
   - Call `searchSectionExpansionProvider.reset()` during logout
   - Provider clears all `search_section_*` keys from SharedPreferences

## Testing Requirements

### Unit Tests

1. **ActivityCategoryProvider**
   - Returns categories sorted by sort_order ascending
   - Provider is keepAlive (does not auto-dispose)

2. **SearchSectionExpansionProvider**
   - Default state is expanded for all sections
   - Toggle updates state and persists to SharedPreferences
   - Reset clears all section states
   - Reads initial state from SharedPreferences on initialization

### Widget Tests

1. **SearchSectionTile**
   - Renders expanded by default
   - Toggles on chevron tap
   - Displays correct icon and title
   - Shows children when expanded, hides when collapsed

2. **ViewAllChip**
   - Displays "View all" text
   - Uses category color for outline and label
   - Shows trailing chevron
   - Calls onPressed when tapped

3. **ActivitySearchScreen**
   - Favorites section hidden when empty
   - Favorites section shows red heart icon
   - Category sections ordered by sort_order
   - Category sections show only suggested favorites
   - View all chip appears at end of each category Wrap
   - Search results display as chips in Wrap

4. **CategoryDetailScreen**
   - Displays category name in app bar
   - Shows all activities as chips in Wrap
   - Back navigation returns to search screen

### Integration Tests

1. **Navigation Flow: Search -> Activity -> Save**
   - Select activity from search replaces to LogActivity
   - Save pops to initial screen

2. **Navigation Flow: Search -> View All -> Back**
   - View all pushes Category Detail
   - Back returns to Search

3. **Navigation Flow: Search -> View All -> Activity -> Save**
   - Select activity replaces entire stack with LogActivity
   - Save pops to initial screen

4. **Expansion State Persistence**
   - Collapse a section, close app, reopen -> section remains collapsed
   - Logout, login -> sections reset to expanded

## Future Considerations

1. **Animated chip transitions** - Animate chips when search results change
2. **Recent activities section** - Show recently logged activity types for quick access
3. **Smart ordering** - Order suggested favorites by user's logging frequency
4. **Offline support** - Cache expansion state in Drift for offline-first experience
5. **Refactor existing category usages** - Update rest of app to use new `activityCategoryProvider`

## Success Criteria

- [ ] Activity selection from Search Screen uses push replacement to LogActivityScreen
- [ ] Save on LogActivityScreen pops once to initial screen
- [ ] Favorites section styled as ExpansionTile with filled red heart icon
- [ ] Favorites section hidden when user has no favorites
- [ ] All activity chips are outlined style with icons
- [ ] Category sections show only `is_suggested_favorite = true` activities
- [ ] Category sections ordered by `sort_order` via new `activityCategoryProvider`
- [ ] "View all" chip at end of each category Wrap with category color and trailing arrow
- [ ] "View all" navigates to new Category Detail Screen
- [ ] Category Detail Screen shows all activities in scrollable Wrap
- [ ] Back from Category Detail returns to Search Screen
- [ ] Activity selection from Category Detail replaces entire stack with LogActivityScreen
- [ ] All sections default to expanded
- [ ] Expand/collapse state persists to SharedPreferences
- [ ] SharedPreferences keys use `search_section_{type}_{id}` format
- [ ] Expansion state cleared on logout
- [ ] Search results display as outlined chips in Wrap

## Items to Complete

- [ ] Create `activityCategoryProvider` (keepAlive) with sort_order ordering
- [ ] Create `SearchSectionExpansionProvider` with SharedPreferences integration
- [ ] Create `SearchSectionTile` widget
- [ ] Create `ViewAllChip` widget
- [ ] Create `CategoryDetailScreen`
- [ ] Add CategoryDetailScreen route to GoRouter
- [ ] Refactor `ActivitySearchScreen` favorites section to ExpansionTile
- [ ] Update favorites section icon to filled red heart
- [ ] Refactor category sections to use `suggestedFavoritesByCategoryProvider`
- [ ] Use `activityCategoryProvider` for category section ordering
- [ ] Add "View all" chip to each category section
- [ ] Update activity selection navigation to push replacement
- [ ] Implement stack replacement for Category Detail -> LogActivity navigation
- [ ] Update search results to display as chips in Wrap
- [ ] Add logout hook to clear expansion state
- [ ] Write unit tests for providers
- [ ] Write widget tests for new components
- [ ] Write integration tests for navigation flows
