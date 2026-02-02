# Architecture

**Analysis Date:** 2026-02-02

## Pattern Overview

**Overall:** Clean Architecture with Feature-Driven Modular Design

**Key Characteristics:**
- Layered architecture (domain, data, application, presentation)
- State management via Riverpod with code generation
- Backend-first approach with Supabase PostgREST + local Drift caching
- Feature isolation with cross-feature dependencies only through services
- Repository pattern for data access, service pattern for business logic
- Freezed for immutable domain models, riverpod_generator for providers

## Layers

**Domain Layer:**
- Purpose: Define business entities, value objects, and exceptions
- Location: `lib/features/[feature]/domain/`
- Contains: Freezed models (`*.freezed.dart`), domain-specific exceptions, enums
- Depends on: Nothing (pure Dart, no external dependencies)
- Used by: Data layer (repositories), Application layer (services), Presentation layer (UI)
- Example: `lib/features/activity_logging/domain/user_activity.dart` - Freezed immutable model with fromJson/toJson

**Data Layer:**
- Purpose: Fetch/mutate data from external sources (Supabase), no business logic
- Location: `lib/features/[feature]/data/`
- Contains: Repository classes implementing dumb data access
- Depends on: Supabase client (injected), Logger, Domain models
- Used by: Application layer (services only)
- Patterns:
  - Repositories accept IDs/params (no provider dependencies)
  - Return domain models, throw custom exceptions, log errors
  - Fail fast (no retry logic)
  - Combined class + Riverpod provider in same file (provider at bottom with `@Riverpod(keepAlive: true)`)
- Example: `lib/features/activity_logging/data/user_activity_repository.dart` - Fetches activities from Supabase, returns UserActivity models

**Application Layer:**
- Purpose: Coordinate business logic, validate input, enrich data
- Location: `lib/features/[feature]/application/`
- Contains: Service classes with business rules
- Depends on: Repository providers, Logger
- Used by: Presentation layer (UI providers, screens)
- Patterns:
  - Services validate input, throw specific exceptions
  - Only layer that calls repositories
  - Orchestrate multiple repositories/providers
  - Combined class + Riverpod provider in same file with `@Riverpod(keepAlive: true)`
- Example: `lib/features/activity_logging/application/activity_logging_service.dart` - Validates activity dates, coordinates logging to Supabase

**Presentation Layer:**
- Purpose: UI rendering and screen-specific state management
- Location: `lib/features/[feature]/presentation/`
- Contains:
  - `screens/` - Full page UI (ConsumerStatefulWidget/ConsumerWidget)
  - `widgets/` - Reusable components
  - `providers/` - Screen state providers (async queries, form state notifiers)
- Depends on: Services, Domain models, other features' screens
- Patterns:
  - Screens use `ConsumerStatefulWidget` or `ConsumerWidget`
  - Form state via StateNotifier providers (auto-dispose unless app-wide)
  - Query data via async providers (`@riverpod`)
  - Screen-specific state uses state notifiers with `@riverpod` (auto-dispose)
- Example: `lib/features/activity_logging/presentation/screens/log_activity_screen.dart` - Renders form with dynamic detail fields

**Core Layer:**
- Purpose: Shared utilities, exceptions, and infrastructure
- Location: `lib/core/`
- Contains:
  - `exceptions/` - Base AppException and environment exceptions
  - `providers/` - Infrastructure providers (Supabase, Logger, SharedPreferences)
  - `services/` - Shared services (EnvService, LoggerService)
  - `utils/` - Extensions and utilities (DateTimeExtensions, StringExtensions)
- Used by: All layers

**App Layer:**
- Purpose: Application bootstrap and configuration
- Location: `lib/app/`
- Contains:
  - `app.dart` - Root ConsumerStatefulWidget that initializes services
  - `router/` - GoRouter configuration with auth-based redirects
  - `database/` - Drift SQLite setup for local caching
  - `theme/` - Material Design 3 theme configuration

## Data Flow

**Authentication Flow:**
1. User initiates sign-in → `SignInScreen` invokes `AuthRepository.signInWithApple()` or `.signInWithGoogle()`
2. `AuthRepository` calls Supabase OAuth endpoint, returns `AuthResponse`
3. `authStateProvider` emits new `AuthState` to `currentUserProvider`
4. `appRouter` redirect logic detects auth change via `ref.listen(currentUserProvider)`
5. Router rebuilds without recreating (uses `refreshListenable`)
6. Authenticated user navigates based on `onboardingCompletedProvider`

**Activity Logging Flow:**
1. User navigates to `LogActivityScreen` with activityId
2. Screen fetches full `Activity` via `activityProvider` (which calls `ActivityCatalogService`)
3. User fills form (managed by `ActivityFormStateNotifier`)
4. On submit, `ActivityFormStateNotifier` calls `ActivityLoggingService.logActivity()`
5. Service validates input, calls `UserActivityRepository.create()`
6. Repository inserts to Supabase `user_activity` table, returns domain model
7. Service invalidates related providers: `dailyActivitiesProvider`, `userActivitiesProvider`, `summaryProvider`
8. UI rebuilds with fresh data

**State Management Flow:**
- Repositories/Services: `@Riverpod(keepAlive: true)` - live for app lifetime
- Query Providers: `@riverpod` (auto-dispose) - rebuild on params change, dispose when unused
- Form State: StateNotifier with `@riverpod` (auto-dispose unless screen-wide)
- Invalidation: Screens call `ref.invalidate(provider)` to trigger refetch (in AppShell bottom nav)

## Key Abstractions

**Repository:**
- Purpose: Data access without business logic
- Examples: `UserActivityRepository`, `FavoriteRepository`, `AuthRepository`
- Pattern: Accept IDs/params → call external API → map to domain models → throw custom exceptions
- Used by: Services only (never called from UI)

**Service:**
- Purpose: Business logic and orchestration
- Examples: `ActivityLoggingService`, `AuthService`, `CatalogService`
- Pattern: Validate input → call repositories → coordinate side effects → enrich data
- Used by: UI providers and screens

**StateNotifier:**
- Purpose: Screen-wide or feature-wide mutable state
- Examples: `ActivityFormStateNotifier`, `DailyActivitiesStateNotifier`, `PreferencesStateNotifier`
- Pattern: Extends generated `_$ClassName` → implements state mutations → persists across navigations
- Decoration: `@riverpod` (auto-dispose for screen-specific state) or no annotation for class definition

**Provider:**
- Purpose: Reactive data binding and dependency injection
- Examples: `userActivitiesByDate`, `activityProvider`, `currentUserProvider`
- Pattern: Functions decorated with `@riverpod` or `@Riverpod(keepAlive: true)` → watch dependencies via `ref.watch()` → rebuild on dependency change
- Params: Providers can accept parameters (date, id) → memoized by value

**Freezed Model:**
- Purpose: Immutable domain entity
- Examples: `UserActivity`, `Activity`, `AuthUser`
- Pattern: Abstract class with `@freezed` → auto-generates equality, copyWith, toString → includes `fromJson`/`toJson` for serialization
- Usage: Read-only contracts between layers

## Entry Points

**Flutter Entry Point:**
- Location: `lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart`
- Triggers: `main()` calls `bootstrap()` with env path
- Responsibilities: Flavor-specific setup

**Bootstrap Function:**
- Location: `lib/bootstrap.dart`
- Triggers: Called by main() with environment path
- Responsibilities:
  1. Loads environment variables via `EnvService.load()`
  2. Initializes Sentry for non-debug builds
  3. Initializes Supabase with URL/anonKey
  4. Initializes RevenueCat for subscriptions
  5. Initializes SharedPreferences
  6. Wraps app in `ProviderScope` (Riverpod)

**App Widget:**
- Location: `lib/app/app.dart`
- Triggers: Built by bootstrap
- Responsibilities:
  1. Initializes post-frame callbacks for services
  2. Initializes NotificationService, HealthSyncInitializer, SubscriptionInitializer, SentryInitializer
  3. Builds MaterialApp.router with theme and GoRouter config

**Router:**
- Location: `lib/app/router/app_router.dart`
- Triggers: Built once in app, redirect logic re-evaluated on auth state change
- Responsibilities:
  1. Routes with `go_router_builder` code generation
  2. Redirect logic gates access by auth state + onboarding status
  3. Three main branches (Home, Profile, Settings) via StatefulShellRoute
  4. Nested routes (activity details, edit screens, etc.)

**Routes Definition:**
- Location: `lib/app/router/routes.dart`
- Contains: TypedGoRoute definitions for all screens (generated via go_router_builder)
- Example: `HomeRoute` → `/` → `HomeScreen`, `LogActivityRoute` → `/log-activity/:activityId` → `LogActivityScreen`

## Error Handling

**Strategy:** Custom exception hierarchy with user-facing messages + technical details for logging

**Patterns:**
- Base: `AppException` abstract class with `message` and `technicalDetails`
- Feature-specific: Each feature defines exceptions inheriting `AppException`
  - Example: `ActivityLoggingException`, `AuthException`, `UserActivityNotFoundException`
- In Repositories: Catch all errors, log with `.e()`, throw specific exception
- In Services: Validate input before calling repos, throw validation exception, let repo exceptions propagate
- In UI: Catch exceptions in async providers, render error state, show user-facing message
- In Bootstrap: If Sentry enabled, `beforeSend` hook enriches errors with `app_exception_type` tag

**Sentry Integration:**
- Only in non-debug builds with configured DSN
- Error logs (level e) captured as Sentry events
- Info/debug/warn logs added as breadcrumbs
- Custom exceptions include technical details in extra data

## Cross-Cutting Concerns

**Logging:**
- Service: `LoggerService` in `lib/core/services/logger_service.dart`
- Methods: `.d()`, `.i()`, `.w()`, `.e()` (debug, info, warning, error)
- Sentry Integration: Error logs → captureException, others → breadcrumbs
- Usage: Injected via `loggerProvider` from `lib/core/providers/logger_provider.dart`

**Validation:**
- Layer: Application (services)
- Pattern: Validate before calling repositories
- Example: `ActivityLoggingService.logActivity()` checks activity ID not empty, end date after start date
- Exceptions: Throw `ValidationException` with user-facing message

**Authentication:**
- Provider: `currentUserProvider` in `lib/features/auth/presentation/providers/auth_state_provider.dart`
- Watched by: `appRouter` for redirect logic, `subscriptionInitializer`, `sentryInitializer`
- State: User object (null if logged out)

**Environment Configuration:**
- Service: `EnvService` in `lib/core/services/env_service.dart`
- Files: `env/.env.development`, `env/.env.staging`, `env/.env.production`
- Loaded in: `bootstrap()` before Sentry/Supabase init
- Access: Static properties (e.g., `EnvService.supabaseUrl`)

**Database Caching:**
- System: Drift SQLite (local cache)
- Location: `lib/app/database/drift_database.dart`
- Tables: `CachedData` for generic cache storage
- Purpose: Offline support, reduce API calls

---

*Architecture analysis: 2026-02-02*
