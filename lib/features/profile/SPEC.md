# Profile Filter Redesign

## Overview

Redesign the profile screen filter bar to replace circular category icon buttons with labeled, scrollable category chips and add stadium-border styling throughout. Includes frequency-based category sorting persisted locally.

## Requirements

- **Time period chips**: Stadium border shape, evenly distributed full-width layout (1W, 1M, 1Y, All)
- **Category chips**: ActivityChip-style with icon + category name, stadium border, filled with category color when selected
- **"All" chip**: First chip in category row, Lucide `listFilter` icon, pre-selected by default, fills with primary color when selected
- **Selection behavior**: Tapping "All" deselects all category chips; tapping a category deselects "All"; multi-select supported; last category deselect auto-reselects "All"
- **Horizontal scrolling**: Category chips in a single-row horizontal ListView
- **Frequency-based sorting**: Track toggle-ON frequency per category in SharedPreferences; sort categories by frequency descending on screen load; default to `sortOrder` when no data

## Architecture

### State Management

- `ProfileFilterState` — holds `TimePeriod` and `Set<String> selectedCategoryIds` (empty = "All")
- `ProfileFilterStateNotifier` — manages toggle/select logic
- `frequencySortedCategoriesProvider` — auto-dispose provider that sorts categories by frequency on rebuild
- `effectiveGlobalCategoryFiltersProvider` — resolves empty set to all category IDs for downstream consumers

### Data Flow

```
User taps category chip
  -> incrementFrequency() if toggling ON
  -> toggleCategory() updates ProfileFilterState
  -> effectiveGlobalCategoryFilters re-evaluates
  -> Summary/Contribution/Radar/Monthly providers re-compute
  -> UI rebuilds with filtered data
```

## Components

### Widgets (`profile_filter_bar.dart`)

- `ProfileFilterBar` — container with Column: category chips row + time period chips row
- `_CategoryChipRow` — horizontal ListView with "All" chip + frequency-sorted category chips
- `_AllFilterChip` — ActionChip with Lucide `listFilter` icon, primary color fill when selected
- `_CategoryFilterChip` — ActionChip with `ActivityCategoryIcon` + category name, category color fill when selected
- `_TimePeriodChipRow` — Row of evenly spaced FilterChips with StadiumBorder

### Providers (`profile_filter_provider.dart`)

- `profileFilterStateProvider` — keepAlive notifier for filter state
- `frequencySortedCategoriesProvider` — auto-dispose, sorts by frequency then sortOrder
- `effectiveGlobalCategoryFiltersProvider` — resolves empty set to all IDs
- `globalTimePeriodProvider` — convenience accessor

### Repository (`category_filter_frequency_repository.dart`)

- `CategoryFilterFrequencyRepository` — SharedPreferences-backed `Map<String, int>` storage
  - `Map<String, int> getFrequencies()` — sync read
  - `Future<void> incrementFrequency(String categoryId)` — async write

## Data Operations

- **Read frequencies**: `getFrequencies()` — sync JSON decode from SharedPreferences
- **Write frequency**: `incrementFrequency(categoryId)` — increment count, JSON encode, write to SharedPreferences
- **Toggle ON tracking**: Only incremented when a category chip transitions from unselected to selected
- **Toggle OFF**: No frequency tracking effect

## Integration

- Downstream providers (`contributionDataProvider`, `categorySummaryProvider`, `weeklyRadarDataProvider`, `monthlyChartDataProvider`) consume `effectiveGlobalCategoryFiltersProvider` unchanged
- Category data sourced from `activityCategoriesProvider` (keepAlive, Supabase-backed)
- SharedPreferences instance from `sharedPreferencesProvider` (bootstrapped at app start)

## Testing Requirements

- **Repository**: Mock SharedPreferences; verify getFrequencies returns empty map initially; verify incrementFrequency persists and increments correctly
- **State notifier**: Verify toggleCategory from empty set selects only that category; verify multi-select add/remove; verify last deselect resets to empty; verify selectAllCategories clears set
- **Frequency sorting**: Verify categories sort by frequency descending; verify ties break by sortOrder; verify zero-frequency categories use sortOrder
- **Widget**: Verify "All" chip renders first and is pre-selected; verify tapping category deselects "All"; verify tapping "All" resets; verify horizontal scroll

## Future Considerations

- Frequency decay: older taps could be weighted less to surface recent preferences
- Pinned/favorite categories: explicit user pinning separate from frequency
- Horizontal scroll hint: fade gradient at trailing edge to indicate more content

## Success Criteria

- [ ] "All" chip appears first with Lucide `listFilter` icon, pre-selected with primary color fill
- [ ] Category chips show icon + name with stadium border, filled with category color when selected
- [ ] Time period chips have stadium border shape
- [ ] Category chips are in a single-row horizontal scrollable ListView
- [ ] Tapping a category deselects "All"; tapping "All" deselects all categories
- [ ] Multi-select works for category chips
- [ ] Deselecting last category auto-reselects "All"
- [ ] Toggle-ON frequency is persisted to SharedPreferences
- [ ] Categories are sorted by frequency on screen load
- [ ] Default sort order used when no frequency data exists
- [ ] Downstream profile sections (Summary, Contribution, Radar, Monthly) still filter correctly
- [ ] No lint errors or test failures

## Items to Complete

- [x] Create `CategoryFilterFrequencyRepository` with SharedPreferences persistence
- [x] Update `toggleCategory` to select only tapped category from "All" state
- [x] Add `frequencySortedCategoriesProvider` for frequency-based sorting
- [x] Replace `_CategoryIconRow` with `_CategoryChipRow` horizontal ListView
- [x] Implement `_AllFilterChip` with Lucide icon and primary color
- [x] Implement `_CategoryFilterChip` mirroring ActivityChip pattern
- [x] Add `StadiumBorder` to time period FilterChips
- [x] Increment frequency on category toggle-ON
- [x] Adjust `PreferredSize` height in profile screen
- [x] Run build_runner for code generation
- [ ] Run analyze and lint
- [ ] Run tests
- [ ] Verify manually via hot restart
