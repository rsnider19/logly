# Logly - Project Overview

## App Summary & Vision

Logly is an all-in-one wellness, fitness, and lifestyle tracker that consolidates activity logging into a single app. Instead of using multiple apps for different activities, Logly lets users track everything in one place - from workouts and sports to meditation, doctor visits, and daily habits.

### Key Differentiator

A centralized wellness platform not tied to any single ecosystem. User data travels across platforms via Apple Health and Google Fit integrations.

### Core Features

- **Custom Activity Tracking** - Log any activity with customizable details
- **Streaks & Daily Insights** - Track consistency and build habits
- **Personalized Stats & Visual History** - See progress over time
- **Health Platform Integration** - Syncs with Apple Health and Google Fit
- **AI-Powered Insights** - Natural language queries about activity data (premium)

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter (fvm managed) |
| **State Management** | Riverpod with code generation |
| **Backend** | Supabase (Auth, PostgREST, Storage, Edge Functions) |
| **Local Storage** | Drift (SQLite) for offline caching |
| **Models** | Freezed for immutable domain models |
| **Navigation** | GoRouter with go_router_builder |
| **UI Components** | shadcn_flutter (primary), Material Design 3 (fallback) |
| **Subscriptions** | RevenueCat |
| **Analytics** | Mixpanel |
| **Feature Flags** | GrowthBook |
| **Health Data** | health package (Apple Health / Google Fit) |

---

## Cross-Cutting Concerns

### Error Handling Patterns

1. **Custom Exceptions per Feature**
   ```dart
   abstract class FeatureException implements Exception {
     const FeatureException(this.message, [this.technicalDetails]);
     final String message;        // User-facing
     final String? technicalDetails;  // For logging
   }
   ```

2. **Repository Layer**: Log errors, throw custom exceptions, fail fast (no retry)
3. **Service Layer**: Validate inputs, coordinate operations, throw specific exceptions
4. **UI Layer**: Display user-friendly messages via SnackBars (transient) or Dialogs (actionable)

### Offline Behavior

- **Mode**: Read-only when offline
- **Implementation**: Drift local SQLite cache mirrors critical Supabase data
- **Sync Strategy**: Pull on app launch when online, cache locally
- **User Feedback**: Clear indicator when in offline mode

### Analytics (Mixpanel)

Track key user actions:
- Activity logged/edited/deleted
- Onboarding completion
- Feature usage (AI Insights, custom activities)
- Subscription events
- Health sync events

### Feature Flags (GrowthBook)

Used for:
- A/B testing new features
- Gradual rollouts
- Kill switches for problematic features
- Beta feature access

### Premium Feature Gating

Three premium features gated via RevenueCat entitlements:
1. **AI Insights** - Natural language activity queries
2. **Create Custom Activity** - User-created activities with custom details
3. **Name Override** - Custom naming for logged activities

**Entitlement Check Pattern**:
```dart
final hasFeature = await ref.read(subscriptionServiceProvider).hasFeature('ai_insights');
if (!hasFeature) {
  // Show paywall
}
```

---

## Database Schema Overview

Reference: `supabase/database.types.ts`

### Core Tables

| Table | Purpose |
|-------|---------|
| `profile` | User profile with `last_health_sync_date` |
| `activity_category` | 6 fixed categories (Fitness, Sports, Wellness, etc.) |
| `activity` | Activity definitions with category, icon, pace_type |
| `activity_detail` | Detail field configurations per activity (duration, distance, etc.) |
| `sub_activity` | Subactivities for activities (e.g., Running > Trail, Track) |
| `user_activity` | Logged activity entries with timestamp, comments |
| `user_activity_detail` | Detail values for logged activities |
| `user_activity_sub_activity` | Selected subactivities for logged entries |
| `favorite_user_activity` | User's favorited activities |

### Aggregation Tables (Prefixed with `_`)

| Table | Purpose |
|-------|---------|
| `_user_activities_by_date` | Daily activity summary for home screen |
| `_user_activity_streak` | Current and longest streak |
| `_user_activity_category_summary` | Category breakdown for profile |
| `_user_activity_category_month` | Monthly category data for charts |

### External Data Tables

| Table | Purpose |
|-------|---------|
| `external_data` | Raw health sync data (Apple Health / Google Fit) |
| `external_data_mapping` | Maps external workout types to Logly activities |

### Premium/RevenueCat Tables (Schema: `revenue_cat`)

| Table | Purpose |
|-------|---------|
| `entitlement` | Available entitlements |
| `feature` | Features tied to entitlements |
| `entitlement_feature` | Mapping of entitlements to features |
| `user_entitlement` | User's active entitlements |

### AI Tables

| Table | Purpose |
|-------|---------|
| `ai_insight_suggested_prompt` | Suggested prompts for AI chat |
| `user_ai_insight` | User's AI query history |
| `activity_embedding` / `sub_activity_embedding` | Vector embeddings for search |

### Key Enums

- `activity_date_type`: `single` | `range`
- `activity_detail_type`: `string` | `integer` | `double` | `duration` | `distance` | `location` | `environment` | `liquidVolume` | `weight`
- `environment_type`: `indoor` | `outdoor`
- `pace_type`: `minutesPerUom` | `minutesPer100Uom` | `minutesPer500m` | `floorsPerMinute`
- `distance_uom`: `meters` | `yards` | `kilometers` | `miles`
- `external_data_source`: `legacy` | `apple_google`

---

## Interview Decisions Summary

### Foundational Decisions

| Decision | Choice |
|----------|--------|
| Activity date storage | Store as `DATE` column (not `timestamptz`) |
| API approach | PostgREST (GraphQL only if needed later) |
| Health sync behavior | Auto-create entries from Apple Health / Google Fit |

### Authentication & Onboarding

| Decision | Choice |
|----------|--------|
| Favorites suggestion | Suggest 3+, no max, no enforcement |
| New device behavior | Re-show onboarding with pre-populated selections (synced server-side) |
| Health permissions | Can enable later in Settings |

### Home Screen

| Decision | Choice |
|----------|--------|
| List behavior | Infinite scroll (~30 days initial load) |
| Empty days | Show empty rows for all days |
| Future dates | Allow future dates |

### Data Model

| Decision | Choice |
|----------|--------|
| Categories | 6 fixed categories from database |
| Activities | Database-seeded |
| Subactivities | Multi-select checkbox list, system-defined only |
| Detail configs | Database-driven per activity (min/max/units) |
| Pace type | Stored per activity |
| Multi-day activities | Start/end pickers, creates N separate entries |

### Profile/Stats

| Decision | Choice |
|----------|--------|
| Streaks | Any activity counts (manual + Health) |
| Contribution graph | Display-only (no tap interaction) |
| Last 12 months | Stacked bar chart |

### Trending

| Decision | Choice |
|----------|--------|
| Calculation | Log count over 7 days, trending vs previous week |

### Settings

| Decision | Choice |
|----------|--------|
| Scope | Full featured (notifications, appearance, edit favorites, export, feedback) |

### Edge Cases

| Decision | Choice |
|----------|--------|
| Account deletion | Soft delete 30 days, then anonymize |
| Duplicate logs | Unlimited per activity per day |
| Offline mode | Read-only |

### Custom Activities

| Decision | Choice |
|----------|--------|
| Visibility | Private to creator |
| Detail fields | One of each field type max |
| Icon | Use category icon |

---

## Migration Strategy

### Activity Date Migration (Dual-Write)

The database will transition from `activity_timestamp` (timestamptz) to storing dates in a separate `DATE` column:

1. **Phase 1**: Add `activity_date DATE` column
2. **Phase 2**: Dual-write to both columns on all inserts/updates
3. **Phase 3**: Migrate existing data
4. **Phase 4**: Update queries to use `activity_date`
5. **Phase 5**: Remove reliance on time portion of `activity_timestamp`

This enables simpler date-based queries for the home screen and stats.

---

## Project Structure

```
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   │   └── app_router.dart
│   └── database/
│       └── drift_database.dart
├── core/
│   ├── services/
│   ├── providers/
│   └── utils/
├── features/
│   ├── auth/
│   ├── subscriptions/
│   ├── activity_catalog/
│   ├── activity_logging/
│   ├── home/
│   ├── profile/
│   ├── onboarding/
│   ├── settings/
│   ├── health_integration/
│   └── ai_insights/
└── gen/
```

Each feature follows the standard structure:
- `data/` - Repositories and data access
- `domain/` - Freezed models and Drift tables
- `presentation/` - Screens, widgets, providers

---

## Related Documents

- [01-core.md](./01-core.md) - Core infrastructure
- [02-auth.md](./02-auth.md) - Authentication
- [03-subscriptions.md](./03-subscriptions.md) - RevenueCat integration
- [04-activity-catalog.md](./04-activity-catalog.md) - Activity catalog
- [05-activity-logging.md](./05-activity-logging.md) - Logging activities
- [06-home.md](./06-home.md) - Home screen
- [07-profile.md](./07-profile.md) - Profile & stats
- [08-onboarding.md](./08-onboarding.md) - Onboarding flow
- [09-settings.md](./09-settings.md) - Settings
- [10-health-integration.md](./10-health-integration.md) - Health sync
- [11-ai-insights.md](./11-ai-insights.md) - AI insights
- [BUILD_ORDER.md](./BUILD_ORDER.md) - Implementation sequence
