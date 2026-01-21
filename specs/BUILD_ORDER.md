# Build Order

This document outlines the recommended implementation sequence for Logly features. The order is determined by dependencies between features and the goal of achieving testable milestones as early as possible.

## Dependency Graph

```
                    ┌─────────────┐
                    │   01-core   │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
        ┌─────────┐  ┌──────────┐  ┌─────────────┐
        │ 02-auth │  │03-subscr.│  │04-act.catalog│
        └────┬────┘  └────┬─────┘  └──────┬──────┘
             │            │               │
             │            │               │
             ▼            │               ▼
       ┌───────────┐      │        ┌─────────────┐
       │08-onboard.│◄─────┼────────│05-act.logging│
       └─────┬─────┘      │        └──────┬──────┘
             │            │               │
             ▼            │               │
       ┌───────────┐      │        ┌──────┴──────┐
       │10-health  │      │        │             │
       └─────┬─────┘      │        ▼             ▼
             │            │   ┌─────────┐   ┌─────────┐
             │            │   │ 06-home │   │07-profile│
             │            │   └─────────┘   └─────────┘
             │            │
             │            ▼
             │      ┌───────────┐
             │      │11-ai-insight│
             │      └───────────┘
             │
             ▼
       ┌───────────┐
       │09-settings│
       └───────────┘
```

## Implementation Phases

### Phase 1: Foundation
**Goal**: Establish core infrastructure and authentication

| Order | Feature | Rationale |
|-------|---------|-----------|
| 1 | **01-core** | Everything depends on Supabase client, routing, and base patterns |
| 2 | **02-auth** | All data access requires authentication |

**Milestone**: User can sign in and see a placeholder home screen

### Phase 2: Data Foundation
**Goal**: Enable activity data to flow through the system

| Order | Feature | Rationale |
|-------|---------|-----------|
| 3 | **04-activity-catalog** | Activities must exist before they can be logged |
| 4 | **05-activity-logging** | Core user interaction - logging activities |

**Milestone**: User can browse activities and log an activity

### Phase 3: Core Experience
**Goal**: Complete the main user journey

| Order | Feature | Rationale |
|-------|---------|-----------|
| 5 | **06-home** | Display logged activities in daily list |
| 6 | **07-profile** | Show user stats and progress |
| 7 | **08-onboarding** | Guide new users through favorites selection |

**Milestone**: Complete basic app flow (onboarding → home → log → profile)

### Phase 4: Health & Settings
**Goal**: Add health sync and user preferences

| Order | Feature | Rationale |
|-------|---------|-----------|
| 8 | **10-health-integration** | Auto-sync workouts from health platforms |
| 9 | **09-settings** | User preferences and account management |

**Milestone**: Health data syncs, user can customize preferences

### Phase 5: Premium Features
**Goal**: Enable monetization and premium experiences

| Order | Feature | Rationale |
|-------|---------|-----------|
| 10 | **03-subscriptions** | Gate premium features |
| 11 | **11-ai-insights** | Premium AI-powered insights |

**Milestone**: Complete app with all features

---

## Detailed Implementation Order

### 1. Core Infrastructure (`01-core.md`)

**Duration Estimate**: Foundation setup

**Prerequisites**: None

**Deliverables**:
- [ ] Environment configuration (dev/staging/prod)
- [ ] Supabase client initialization
- [ ] Logger service
- [ ] Base exception classes
- [ ] GoRouter setup with placeholder routes
- [ ] Drift database schema
- [ ] Repository and service patterns documented

**Verification**:
- App launches in all three flavors
- Supabase client connects successfully
- Routes navigate without errors

---

### 2. Authentication (`02-auth.md`)

**Duration Estimate**: Auth implementation

**Prerequisites**: 01-core

**Deliverables**:
- [ ] Apple Sign-in integration
- [ ] Google Sign-in integration
- [ ] Auth state provider
- [ ] Sign-in screen
- [ ] Auth route guards
- [ ] Sign-out functionality

**Verification**:
- User can sign in with Apple
- User can sign in with Google
- Auth state persists across restarts
- Unauthenticated users redirected to sign-in

---

### 3. Activity Catalog (`04-activity-catalog.md`)

**Duration Estimate**: Data layer + basic UI

**Prerequisites**: 01-core, 02-auth

**Deliverables**:
- [ ] Category domain model and repository
- [ ] Activity domain model and repository
- [ ] SubActivity domain model and repository
- [ ] ActivityDetail domain model and repository
- [ ] Activity search (basic FTS first, hybrid later)
- [ ] Category and activity list widgets
- [ ] Activity chip component

**Verification**:
- All categories load from database
- Activities display with correct colors/icons
- Search returns relevant results

---

### 4. Activity Logging (`05-activity-logging.md`)

**Duration Estimate**: Forms and data entry

**Prerequisites**: 04-activity-catalog

**Deliverables**:
- [ ] Activity search/selection screen
- [ ] Log activity screen
- [ ] All detail field widgets (duration, distance, etc.)
- [ ] Subactivity multi-select
- [ ] Date picker
- [ ] UserActivity repository
- [ ] Log/update/delete operations
- [ ] Favorite toggle

**Verification**:
- User can search and select activity
- All detail fields render based on activity type
- Activity saves to database
- Activity can be edited and deleted

---

### 5. Home Screen (`06-home.md`)

**Duration Estimate**: Shell route + list

**Prerequisites**: 05-activity-logging

**Deliverables**:
- [ ] Shell route with app bar and bottom nav
- [ ] Daily activities list with infinite scroll
- [ ] Empty day rows
- [ ] Activity chip list per day
- [ ] Trending activities bottom sheet
- [ ] Navigation between routes

**Verification**:
- Daily list shows logged activities
- Empty days display correctly
- Tap chip opens edit screen
- Tap row opens log screen for date
- Navigation works correctly

---

### 6. Profile Screen (`07-profile.md`)

**Duration Estimate**: Stats and charts

**Prerequisites**: 06-home

**Deliverables**:
- [ ] Streak card with current/longest
- [ ] Summary card with time period filter
- [ ] Category progress bars
- [ ] Contribution graph (GitHub-style)
- [ ] 12-month stacked bar chart
- [ ] Category filter for chart
- [ ] Collapsible sections

**Verification**:
- Streak displays correctly
- Summary updates with time period
- Contribution graph renders last year
- 12-month chart filters by category

---

### 7. Onboarding (`08-onboarding.md`)

**Duration Estimate**: Flows and screens

**Prerequisites**: 04-activity-catalog, 06-home

**Deliverables**:
- [ ] Intro pager (3 pages)
- [ ] Favorites selection screen
- [ ] Popular activities section
- [ ] Category sections
- [ ] Health connect permission screen
- [ ] Onboarding completion tracking
- [ ] Pre-population for returning users

**Verification**:
- New users see intro pager
- Favorites can be selected
- Health permission screen displays
- Onboarding completes and navigates to home

---

### 8. Health Integration (`10-health-integration.md`)

**Duration Estimate**: Platform integration

**Prerequisites**: 05-activity-logging, 08-onboarding

**Deliverables**:
- [ ] Health package setup
- [ ] Permission request flow
- [ ] Workout fetching
- [ ] Workout type mapping
- [ ] Auto-create user activities
- [ ] Last sync tracking
- [ ] Duplicate detection

**Verification**:
- Permissions requested correctly per platform
- Workouts sync from health app
- Activities created automatically
- No duplicates on re-sync

---

### 9. Settings (`09-settings.md`)

**Duration Estimate**: Preferences and account

**Prerequisites**: 02-auth, 08-onboarding, 10-health-integration

**Deliverables**:
- [ ] Settings screen layout
- [ ] Account info display
- [ ] Unit preference toggle
- [ ] Edit favorites (reuse onboarding)
- [ ] Theme selector
- [ ] Health sync toggle
- [ ] Export data
- [ ] Sign out
- [ ] Delete account

**Verification**:
- All settings display correctly
- Preferences persist
- Export generates file
- Sign out clears data
- Delete account soft deletes

---

### 10. Subscriptions (`03-subscriptions.md`)

**Duration Estimate**: RevenueCat integration

**Prerequisites**: 01-core, 02-auth

**Note**: Can be started in parallel with other features but gates should be added last

**Deliverables**:
- [ ] RevenueCat SDK setup
- [ ] Entitlement checking service
- [ ] Paywall presentation
- [ ] Premium gate widget
- [ ] Webhook endpoint (already exists)

**Verification**:
- RevenueCat initializes
- Entitlements check correctly
- Paywall displays
- Purchase flow completes

---

### 11. AI Insights (`11-ai-insights.md`)

**Duration Estimate**: Premium feature

**Prerequisites**: 03-subscriptions

**Deliverables**:
- [ ] AI insights screen
- [ ] Chat message UI
- [ ] Suggested prompts
- [ ] Query input
- [ ] Streaming response display
- [ ] Chat history
- [ ] Premium gate integration

**Verification**:
- Premium gate blocks non-subscribers
- Suggested prompts display
- Queries process correctly
- Responses stream incrementally
- History persists

---

## Checkpoints

### Checkpoint 1: MVP Internal Testing
After completing phases 1-3, the app should be testable internally:
- Sign in works
- Activities can be logged
- Home screen shows daily activities
- Profile shows basic stats
- Onboarding guides new users

### Checkpoint 2: Beta Release
After completing phases 1-4:
- Health sync working
- Settings fully functional
- All core features complete

### Checkpoint 3: Production Release
After completing phase 5:
- Premium features gated
- AI insights working
- Full app functionality

---

## Notes

1. **Parallel Work**: Some features can be developed in parallel by different developers:
   - Activity Catalog + Auth (after core)
   - Profile + Onboarding (after home)
   - Settings + Subscriptions (after core features)

2. **Testing Throughout**: Write tests alongside implementation, not after. Each feature spec includes testing requirements.

3. **Database Already Complete**: The Supabase schema is already set up. Focus is on Flutter implementation.

4. **Edge Functions Exist**: AI insights and search edge functions are already implemented. Focus on Flutter integration.

5. **Incremental Premium Gates**: Build features first, then add premium gates. This allows testing full functionality before restricting access.
