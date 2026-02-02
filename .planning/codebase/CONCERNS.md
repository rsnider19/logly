# Codebase Concerns

**Analysis Date:** 2026-02-02

## Tech Debt

**Complex Activity Form State Management:**
- Issue: The `ActivityFormStateNotifier` in `lib/features/activity_logging/presentation/providers/activity_form_provider.dart` (673 lines) is a monolithic provider handling creation, editing, multi-day logging, and optimistic saves. The state class has 11 parameters with multiple boolean flags and multiple `copyWith` methods using clear* flags rather than explicit nullability, making mutations error-prone.
- Files: `lib/features/activity_logging/presentation/providers/activity_form_provider.dart`
- Impact: Hard to reason about state transitions, increased chance of silent state bugs, difficult to test isolated state changes, and risk of incorrect optimistic updates causing inconsistent UI.
- Fix approach: Split into three separate providers: single-day form, multi-day form, and optimistic save handler. Introduce proper union types (sealed classes) instead of boolean flags for different form modes.

**Health Sync Initialization Race Condition:**
- Issue: In `lib/features/health_integration/application/health_sync_initializer.dart`, the `_onUserAuthenticated` method uses manual delays (`Future.delayed(500ms)`) and polling for preferences instead of waiting for the preference provider's async state. There's a fallback retry mechanism that could mask real errors.
- Files: `lib/features/health_integration/application/health_sync_initializer.dart` (lines 56-75)
- Impact: Health sync may fail silently on slow devices, or trigger multiple times if preferences take longer to load. No guarantee sync completes before user navigates away.
- Fix approach: Replace manual delay with `ref.read(preferencesStateProvider).when()` that waits for AsyncValue completion. Remove the retry loop and let the provider handle loading states.

**Settings Screen Size and Complexity:**
- Issue: `lib/features/settings/presentation/screens/settings_screen.dart` is 963 lines and contains stateful logic, multiple UI sections, navigation, dialogs, and service calls all in one widget. The state management uses multiple boolean flags (`_isSigningOut`, `_isDeleting`, `_isTogglingNotifications`) for loading states.
- Files: `lib/features/settings/presentation/screens/settings_screen.dart`
- Impact: Difficult to maintain, high risk of UI state inconsistencies, hard to test individual settings features, and layout/scroll performance may degrade.
- Fix approach: Refactor into feature-focused sub-screens (SettingsGeneralScreen, SettingsNotificationsScreen, etc.). Move each section's logic into separate providers instead of stateful flags.

**Unimplemented SharedPreferencesProvider:**
- Issue: `lib/core/providers/shared_preferences_provider.dart` throws `UnimplementedError`, indicating an incomplete dependency setup that may be bypassed or cause runtime crashes.
- Files: `lib/core/providers/shared_preferences_provider.dart`
- Impact: If any code path calls this provider, the app crashes. Unknown if this is actively used or dead code.
- Fix approach: Either implement this provider properly or remove all references and verify through code search that nothing depends on it.

## Performance Bottlenecks

**Contribution Graph Data Processing:**
- Issue: In `lib/features/profile/presentation/widgets/contribution_graph.dart`, the `_CachedContributionContentState` manually caches data in instance variables (`_cachedData`) rather than using providers. The graph rebuild may regenerate color calculations and data processing on every build if not carefully optimized.
- Files: `lib/features/profile/presentation/widgets/contribution_graph.dart` (lines 59-72)
- Impact: Unnecessary rebuilds when filter changes, potential memory leaks from stale cached data, and inefficient re-renders of GitHub-style contribution grid (potentially 365+ cells).
- Fix approach: Move cache logic into a provider that survives filter changes. Use `build_context: false` or a separate widget that only rebuilds on data changes, not on filter changes.

**Monthly Chart Widget Re-rendering:**
- Issue: `lib/features/profile/presentation/widgets/monthly_chart.dart` uses `_MonthlyChartContentState` to maintain previous data during loading transitions (lines 43-50). However, the chart data provider `monthlyChartDataProvider` likely re-queries on every profile filter change, and there's no memoization on the chart building itself.
- Files: `lib/features/profile/presentation/widgets/monthly_chart.dart`
- Impact: fl_chart's BarChart widget can be expensive to render with animation. If data provider queries database/network on every filter change, this could cause UI jank.
- Fix approach: Implement a provider-level data cache with explicit invalidation only when necessary. Consider using `Debounce` or `AsyncValue.skipWhile` to batch rapid filter changes.

**Daily Activities Pagination Inefficiency:**
- Issue: `lib/features/home/presentation/providers/daily_activities_provider.dart` loads 30 days of data on init and supports infinite scroll backwards. The `loadMore` method re-fetches and refills date ranges every time. For a user with years of data, this creates multiple large queries.
- Files: `lib/features/home/presentation/providers/daily_activities_provider.dart` (lines 75-120)
- Impact: Network bandwidth waste, potential OutOfMemory on old devices with years of activity, and slow scrolling as list grows to thousands of items.
- Fix approach: Implement cursor-based pagination with fixed window size. Use Drift local cache to pre-fill and limit in-memory list to current + future 2 weeks worth of data.

## Fragile Areas

**Activity Repository Fallback to Cache Pattern:**
- Issue: In `lib/features/activity_catalog/data/activity_repository.dart`, when network fails, the repository returns stale cache without version checking. If the user updates an activity on another device, the cached version becomes incorrect but continues to be served.
- Files: `lib/features/activity_catalog/data/activity_repository.dart` (lines 53-64)
- Impact: Silent data inconsistency, user may not realize they're viewing outdated activity details across multiple app sessions.
- Fix approach: Implement cache versioning or timestamps. When returning cache, mark it as stale in the UI. Consider network-first strategy with timeout instead of silent fallback.

**Multi-Day Logging Partial Failures:**
- Issue: In `lib/features/activity_logging/application/activity_logging_service.dart` and consumed by `activity_form_provider.dart`, multi-day logging can result in partial success where some days succeed and others fail. The form shows results but doesn't guide user on recovery (which days failed, why, retry mechanism).
- Files: `lib/features/activity_logging/domain/log_multi_day_result.freezed.dart`, `lib/features/activity_logging/application/activity_logging_service.dart`
- Impact: User may not realize only 3 of 5 days were logged, leading to incomplete history.
- Fix approach: UI should display failed date list explicitly. Implement single-click retry for failed days only, not all days.

**Optimistic Save Without Rollback Strategy:**
- Issue: `lib/features/activity_logging/presentation/providers/pending_save_provider.dart` implements optimistic saves but if the Supabase request fails, the error snackbar shows but the optimistically-added item may remain in UI, causing "silent failure" user experience.
- Files: `lib/features/activity_logging/presentation/providers/pending_save_provider.dart`
- Impact: User thinks activity was saved, navigates away, then discovers on next app restart it wasn't actually persisted.
- Fix approach: Implement explicit rollback: remove optimistically-added item from list on failure. Show prominent error dialog (not snackbar) with retry button that both retries the server AND re-adds the item.

**TextEditingController Lifecycle in LogActivityScreen:**
- Issue: `lib/features/activity_logging/presentation/screens/log_activity_screen.dart` creates `_commentsController` in `initState` and disposes in `dispose`, but there's no protection against double-disposal if the stateful widget is popped/replaced while async operations are pending.
- Files: `lib/features/activity_logging/presentation/screens/log_activity_screen.dart` (lines 49-60)
- Impact: Potential "TextEditingController for inactive TextField" warnings or crashes on rapid navigation.
- Fix approach: Add `mounted` check before accessing controller in callbacks. Consider using a `try-finally` wrapper in `dispose` to catch if already disposed.

## Missing Critical Features / Known Gaps

**No Offline-First Conflict Resolution:**
- Issue: The Drift local cache in `lib/app/database/drift_database.dart` stores activities locally, but there's no conflict resolution if user edits on phone (offline), then app syncs on another device with different data.
- Files: `lib/app/database/drift_database.dart`
- Impact: One version of the data wins silently; user loses edits from one device.
- Fix approach: Implement last-write-wins with timestamp comparison, or flag conflicts for manual resolution.

**Health Data Sync Validation:**
- Issue: Health sync imports data from HealthKit/Health Connect but there's no validation of imported data bounds (e.g., step counts < 0, distance > Earth circumference).
- Files: `lib/features/health_integration/application/health_sync_service.dart`
- Impact: Invalid health metrics could corrupt activity statistics and break streak calculations.
- Fix approach: Add range validation before inserting synced health data. Log and skip invalid records with user notification.

**No Rate Limiting on Activity Logging:**
- Issue: No client-side rate limiting on creating activities. User can spam log 100 activities in seconds, each generating a Supabase insert, overloading the backend.
- Files: `lib/features/activity_logging/application/activity_logging_service.dart`
- Impact: Potential DOS attack vector (even if accidental), backend billing spike.
- Fix approach: Add client-side throttle on activity creation (e.g., max 1 per second) and queue additional requests.

**Subscription Status Not Cached:**
- Issue: In `lib/features/subscriptions/presentation/providers/entitlement_provider.dart`, entitlements are fetched from RevenueCat but if network fails and cache is empty, the app shows loading indefinitely.
- Files: `lib/features/subscriptions/presentation/providers/entitlement_provider.dart` (lines 25-34)
- Impact: Premium features become inaccessible if offline, even if subscription is active.
- Fix approach: Persist last-known entitlements to Drift. On fetch failure, return cached + stale flag. Show banner that subscription status is stale.

## Test Coverage Gaps

**Limited Integration Tests for Activity Logging:**
- Issue: Only 23 test files exist. No comprehensive integration tests for multi-day logging edge cases (e.g., DST transitions, leap years, end-of-month rollover).
- Files: `test/` directory (23 files total), specifically missing integration tests in `test/features/activity_logging/`
- Risk: Edge case bugs discovered in production only.
- Priority: High - Activity logging is core user-facing feature

**No E2E Tests for Health Sync:**
- Issue: Health sync is critical but no E2E tests exist for it. Testing requires actual HealthKit/Health Connect simulator setup.
- Files: `lib/features/health_integration/`
- Risk: Health data corruption goes undetected until user report it.
- Priority: High - Health data directly affects user trust

**Database Migration Untested:**
- Issue: `drift_database.dart` has `onUpgrade` as empty stub. No tests for schema migrations.
- Files: `lib/app/database/drift_database.dart` (lines 29-31)
- Risk: Future schema changes will break on upgrade.
- Priority: Medium - But becomes critical as schema evolves

## Security Considerations

**Supabase RLS Assumed Correct:**
- Issue: Repository pattern assumes all Supabase queries are properly protected by Row-Level Security (RLS) policies, but there's no validation that RLS is actually enabled or covers all tables.
- Files: All repository files in `lib/features/*/data/`
- Current mitigation: Trust in Supabase configuration, but no audit logs or tests to verify.
- Recommendations: Add integration test that attempts to query another user's data and verifies it fails. Document which tables have RLS enforced.

**No Input Sanitization on Comments:**
- Issue: In `activity_form_provider.dart`, user-provided comments are directly serialized to JSON and sent to Supabase without HTML/script sanitization.
- Files: `lib/features/activity_logging/presentation/providers/activity_form_provider.dart`
- Risk: If comments are ever displayed in rich text or HTML context (e.g., web dashboard), XSS is possible.
- Recommendations: Even though Flutter only uses plaintext, add sanitization for defense-in-depth.

**Storage Permissions Not Enforced:**
- Issue: File storage and health data permissions are requested but there's minimal validation that permissions were actually granted before attempting access.
- Files: `lib/features/health_integration/presentation/providers/health_sync_provider.dart`
- Risk: Crashes if user denies permission after initial grant.
- Recommendations: Wrap all health API calls in permission checks with fallback UI.

## Scaling Limits

**Database Query N+1 Patterns:**
- Issue: Multiple nested joins (e.g., `activity > category > details > sub_activities`) are done in single queries, but if display later needs another relationship, a new query is required without caching.
- Files: All repository methods with `select('*, activity_category(*), activity_detail(*), sub_activity(*)')`
- Current capacity: Works fine for catalogs of ~100 activities.
- Limit: As activity catalog grows to 1000+, these query responses become large (MB). Pagination should be implemented.
- Scaling path: Implement lazy loading of nested resources. Fetch basic activity info first, then details on demand.

**Drift Database File Growth:**
- Issue: Local Drift cache has no cleanup strategy. `deleteExpiredCache()` is implemented but never called automatically.
- Files: `lib/app/database/drift_database.dart` (lines 75-77)
- Current capacity: Fine for 1-2 years of daily activity logs (~1000 entries).
- Limit: After 5+ years, SQLite file may grow to 50+ MB, affecting app launch time.
- Scaling path: Implement periodic cleanup job that deletes cache > 30 days old on app launch.

**Contribution Graph Memory:**
- Issue: `contribution_graph.dart` loads full year of data (365 days) into memory, even if only displaying month view.
- Current capacity: Works fine on modern devices.
- Limit: On older devices with limited RAM, this contributes to memory pressure.
- Scaling path: Load data in chunks per quarter. Implement virtual scrolling if contribution graph becomes interactive.

**Home Feed Pagination Limit:**
- Issue: `dailyActivitiesStateProvider` loads 30 days initially, then 30 more on scroll. With no upper bound, in theory user could scroll to year 2000 and load 10,000 days worth of summaries into memory.
- Files: `lib/features/home/presentation/providers/daily_activities_provider.dart`
- Limit: ~5000 days (13 years) before noticeable memory/scroll slowdown.
- Scaling path: Implement "load older" as explicit action rather than infinite scroll. Or implement virtual scrolling with list item virtualization.

## Dependencies at Risk

**RevenueCat Integration Tight Coupling:**
- Issue: Subscription logic is tightly coupled to RevenueCat SDK. Entitlements checked directly via `Purchases.getCustomerInfo()` throughout app. No abstraction layer.
- Files: `lib/features/subscriptions/` uses RevenueCat directly
- Risk: Migrating to another subscription provider (Apple StoreKit2, custom) would require changes across multiple features.
- Impact: Medium - Manageable as it's contained in subscriptions feature
- Migration plan: Create abstract `SubscriptionProvider` interface, implement RevenueCat concrete class, allow swap via dependency injection.

**HealthKit/Health Connect Hard Dependency:**
- Issue: Health integration is always initialized but only used if enabled. If library version introduces breaking changes, all users affected.
- Files: `lib/features/health_integration/`
- Risk: Low - Health permissions make it safe to have
- Mitigation: This is acceptable since it's feature-flagged in settings and properly gated by permissions.

**Flutter Very Goods Lint Rules Enforcement:**
- Issue: `very_good_analysis` lint rules enforced via pub, but can be overridden. No CI check to prevent lint violations from merging.
- Impact: Code style consistency may degrade
- Recommendation: Add pre-commit hook to run `fvm flutter analyze` and fail if violations detected.

---

*Concerns audit: 2026-02-02*
