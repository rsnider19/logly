# Activity Summary vs Detail Model Split

## Overview

This feature introduces an `ActivitySummary` Freezed model for lightweight activity display (chips, lists, search results) and reserves the full `Activity` model for detail/form screens (log, edit). This reduces over-fetching across search, category, home, and favorites screens.

## Requirements

- Activity chips, search results, favorites, and category lists use `ActivitySummary` (no detail/subactivity joins)
- Log and edit screens fetch the full `Activity` by ID on screen load
- Home screen strips `activity_detail` and `user_activity_detail` from the daily activities query
- Navigation passes `activityId` (String) instead of full `Activity` objects via `$extra`

## Architecture

### Domain Models

- **`ActivitySummary`**: Lightweight model with `activityId`, `activityCategoryId`, `name`, `activityCode`, `description?`, `activityDateType`, `isSuggestedFavorite`, `activityCategory?`, `getColor()`, `icon` getter
- **`Activity`**: Full model with all of the above plus `paceType`, `activityDetail`, `subActivity`
- **`FavoriteActivity`**: `activity` field is `ActivitySummary?` (was `Activity?`)

### Repository Layer

`ActivityRepository` has two sets of methods:
- **Summary methods**: `getByCategorySummary`, `searchSummary`, `getSuggestedFavoritesSummary`, `getSuggestedFavoritesByCategorySummary`, `getPopularSummary` - use `*, activity_category:activity_category(*)` select
- **Detail methods**: `getById`, `getByCategory` - use full joins including `activity_detail(*)`, `sub_activity(*)`

Each set has its own Drift cache entries (`activity_summary` vs `activity` cache types).

### Service Layer

`CatalogService` mirrors the repository split with summary methods that delegate to the new repository summary methods.

### Provider Layer

- `activitiesByCategorySummaryProvider` replaces `activitiesByCategoryProvider` for chip screens
- `suggestedFavoritesByCategorySummaryProvider` replaces `suggestedFavoritesByCategoryProvider`
- `popularActivitiesSummaryProvider` replaces `popularActivitiesProvider`
- `searchResultsProvider` returns `List<ActivitySummary>`
- `activityByIdProvider` remains, returning full `Activity` for log/edit screens

### Navigation

- `LogActivityRoute` accepts `activityId` (String) + optional `date` - no `$extra`
- `LogActivityScreen` fetches full `Activity` via `activityByIdProvider` on load
- `EditActivityScreen` unchanged (already fetches by `userActivityId`)

### Home Screen

`DailyActivitiesRepository._selectWithRelations` excludes `activity_detail(*)` and `user_activity_detail(*)`. Only fetches activity + category + user-selected subactivities for display.

## Components

| Component | Model Used |
|-----------|-----------|
| ActivityChip | ActivitySummary |
| UserActivityChip | UserActivity (with nested Activity) |
| ActivitySummaryIcon | ActivitySummary |
| ActivityIcon | Activity |
| UserActivityIcon | UserActivity |
| LogActivityScreen | Activity (fetched by ID) |
| EditActivityScreen | UserActivity (fetched by ID) |
| ActivitySearchScreen | ActivitySummary |
| CategoryDetailScreen | ActivitySummary |
| FavoritesSelectionScreen | ActivitySummary |
| FavoritesBottomSheet | ActivitySummary |

## Success Criteria

- [x] ActivitySummary Freezed model created
- [x] FavoriteActivity uses ActivitySummary
- [x] Repository has summary + detail methods with separate cache
- [x] Service has summary methods
- [x] Providers return summary types for chip/list screens
- [x] ActivityChip accepts ActivitySummary
- [x] ActivitySummaryIcon added to logly_icons
- [x] LogActivityScreen fetches full Activity by ID on load
- [x] Navigation uses activityId only (no $extra)
- [x] Home screen query excludes activity_detail and user_activity_detail
- [x] Onboarding and settings screens updated
- [x] Code generation passes
- [x] Static analysis passes (no errors)
