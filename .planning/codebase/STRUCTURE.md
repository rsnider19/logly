# Codebase Structure

**Analysis Date:** 2026-02-02

## Directory Layout

```
logly/
├── lib/
│   ├── main_development.dart      # Entry point for development flavor
│   ├── main_staging.dart          # Entry point for staging flavor
│   ├── main_production.dart       # Entry point for production flavor
│   ├── bootstrap.dart             # App initialization (Sentry, Supabase, RevenueCat, etc.)
│   │
│   ├── app/                       # App-level configuration and shell
│   │   ├── app.dart               # Root ConsumerStatefulWidget (initializes services)
│   │   ├── router/                # Navigation configuration
│   │   │   ├── app_router.dart    # GoRouter instance with auth redirect logic
│   │   │   └── routes.dart        # Route definitions (TypedGoRoute, shells, branches)
│   │   ├── database/              # Local SQLite caching via Drift
│   │   │   ├── drift_database.dart
│   │   │   ├── tables/            # Drift table definitions
│   │   │   └── database_provider.dart
│   │   └── theme/                 # Material Design 3 theme
│   │       └── app_theme.dart
│   │
│   ├── core/                      # Shared utilities and infrastructure
│   │   ├── exceptions/            # Base and environment exceptions
│   │   │   └── app_exception.dart
│   │   ├── providers/             # Infrastructure providers (DI)
│   │   │   ├── logger_provider.dart
│   │   │   ├── supabase_provider.dart
│   │   │   ├── shared_preferences_provider.dart
│   │   │   └── scaffold_messenger_provider.dart
│   │   ├── services/              # Shared services
│   │   │   ├── logger_service.dart
│   │   │   ├── env_service.dart
│   │   │   └── sentry_initializer.dart
│   │   └── utils/                 # Extensions and utilities
│   │       ├── extensions.dart    # String, DateTime extensions
│   │       └── date_utils.dart
│   │
│   ├── features/                  # Feature modules (clean architecture per feature)
│   │   ├── auth/                  # Authentication feature
│   │   │   ├── domain/            # Business entities
│   │   │   │   ├── auth_user.dart
│   │   │   │   ├── auth_exception.dart
│   │   │   │   └── *.freezed.dart (generated)
│   │   │   ├── data/              # Data access layer
│   │   │   │   ├── auth_repository.dart (+ provider)
│   │   │   │   └── *.g.dart (generated)
│   │   │   └── presentation/      # UI layer
│   │   │       ├── providers/
│   │   │       │   ├── auth_state_provider.dart
│   │   │       │   └── auth_service_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── sign_in_screen.dart
│   │   │       └── widgets/
│   │   │           ├── apple_sign_in_button.dart
│   │   │           └── google_sign_in_button.dart
│   │   │
│   │   ├── activity_logging/      # Activity logging feature
│   │   │   ├── domain/
│   │   │   │   ├── user_activity.dart
│   │   │   │   ├── create_user_activity.dart
│   │   │   │   ├── update_user_activity.dart
│   │   │   │   ├── activity_logging_exception.dart
│   │   │   │   └── *.freezed.dart
│   │   │   ├── data/
│   │   │   │   ├── user_activity_repository.dart (+ provider)
│   │   │   │   ├── favorite_repository.dart (+ provider)
│   │   │   │   └── *.g.dart
│   │   │   ├── application/
│   │   │   │   ├── activity_logging_service.dart (+ provider)
│   │   │   │   └── *.g.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   ├── user_activities_provider.dart
│   │   │       │   ├── activity_form_provider.dart (StateNotifier)
│   │   │       │   ├── favorites_provider.dart (StateNotifier)
│   │   │       │   ├── pending_save_provider.dart (StateNotifier)
│   │   │       │   ├── activity_statistics_provider.dart
│   │   │       │   └── *.g.dart
│   │   │       ├── screens/
│   │   │       │   ├── log_activity_screen.dart
│   │   │       │   ├── edit_activity_screen.dart
│   │   │       │   ├── activity_statistics_screen.dart
│   │   │       │   ├── activity_search_screen.dart
│   │   │       │   └── category_detail_screen.dart
│   │   │       └── widgets/
│   │   │           ├── detail_inputs/
│   │   │           │   ├── duration_input.dart
│   │   │           │   ├── distance_input.dart
│   │   │           │   ├── weight_input.dart
│   │   │           │   └── *.dart
│   │   │           ├── custom_name_input.dart
│   │   │           ├── date_picker_field.dart
│   │   │           └── *.dart
│   │   │
│   │   ├── activity_catalog/      # Activity definitions and categories
│   │   │   ├── domain/
│   │   │   ├── data/
│   │   │   │   └── catalog_repository.dart (+ provider)
│   │   │   ├── application/
│   │   │   │   └── catalog_service.dart (+ provider)
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       └── widgets/
│   │   │
│   │   ├── custom_activity/       # User-created activities
│   │   │   ├── domain/
│   │   │   ├── data/
│   │   │   ├── application/
│   │   │   └── presentation/
│   │   │       └── providers/
│   │   │           └── create_custom_activity_form_provider.dart (StateNotifier)
│   │   │
│   │   ├── home/                  # Home screen and dashboard
│   │   │   ├── application/
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── home_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   └── app_shell.dart (StatefulNavigationShell)
│   │   │   │   └── providers/
│   │   │   │       ├── daily_activities_provider.dart (StateNotifier)
│   │   │   │       └── home_navigation_provider.dart (StateNotifier)
│   │   │   │
│   │   ├── profile/               # User profile, stats, streaks
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   └── profile_screen.dart
│   │   │   │   └── providers/
│   │   │   │       ├── streak_provider.dart
│   │   │   │       ├── summary_provider.dart
│   │   │   │       ├── monthly_chart_provider.dart
│   │   │   │       └── *.dart
│   │   │   │
│   │   ├── settings/              # User settings, notifications, preferences
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── settings_screen.dart
│   │   │   │   │   └── favorites_screen.dart
│   │   │   │   └── providers/
│   │   │   │       ├── preferences_provider.dart (StateNotifier)
│   │   │   │       └── notification_preferences_provider.dart (StateNotifier)
│   │   │
│   │   ├── health_integration/    # Apple HealthKit / Google Health Connect sync
│   │   │   ├── application/
│   │   │   ├── presentation/
│   │   │   └── providers/
│   │   │       └── health_sync_provider.dart (StateNotifier)
│   │   │
│   │   ├── subscriptions/         # RevenueCat integration, premium features
│   │   │   ├── presentation/
│   │   │   ├── widgets/
│   │   │   │   └── premium_gate.dart
│   │   │   └── providers/
│   │   │       └── entitlement_provider.dart (StateNotifier)
│   │   │
│   │   ├── onboarding/            # Pre and post-auth setup flows
│   │   │   ├── presentation/
│   │   │   │   ├── screens/
│   │   │   │   │   ├── intro_pager_screen.dart
│   │   │   │   │   ├── onboarding_questions_shell.dart
│   │   │   │   │   └── post_auth_setup_shell.dart
│   │   │   │   └── providers/
│   │   │   │       └── onboarding_status_provider.dart
│   │   │   │
│   │   ├── ai_insights/           # AI-powered recommendations
│   │   │   ├── data/
│   │   │   ├── presentation/
│   │   │   └── providers/
│   │   │       └── *.dart
│   │   │
│   │   └── developer/             # Development utilities
│   │       └── presentation/
│   │           └── screens/
│   │               └── developer_screen.dart
│   │
│   ├── widgets/                   # App-wide reusable components
│   │   ├── skeleton_loader.dart   # Shimmer loading placeholder
│   │   ├── supabase_image.dart    # Image loading from Supabase storage
│   │   ├── logly_icons.dart       # Custom icon definitions
│   │   └── *.dart
│   │
│   └── gen/                       # Generated asset references
│       └── assets.gen.dart        # flutter_gen generated file
│
├── test/                          # Test suite (mirrors lib structure)
│   ├── helpers/
│   │   ├── pump_app.dart          # Widget test setup helper
│   │   └── mocks/
│   │       └── *.dart
│   ├── core/
│   │   ├── exceptions/
│   │   ├── services/
│   │   └── utils/
│   └── features/
│       ├── auth/
│       ├── activity_logging/
│       └── *.dart
│
├── env/                           # Environment configuration files
│   ├── .env.development
│   ├── .env.staging
│   └── .env.production
│
├── supabase/                      # Supabase configuration
│   └── schema.ts                  # Generated TypeScript types (reference only)
│
└── pubspec.yaml                   # Dart dependencies
```

## Directory Purposes

**lib/app/**
- Purpose: Application-level configuration and routing
- Key files:
  - `app.dart`: Root widget that initializes post-frame services (NotificationService, HealthSync, Subscriptions, Sentry)
  - `router/`: Navigation with auth guards and redirects
  - `database/`: Local SQLite via Drift for offline caching
  - `theme/`: Dark mode by default, Material Design 3

**lib/core/**
- Purpose: Shared infrastructure and utilities
- Key files:
  - `exceptions/app_exception.dart`: Base exception class
  - `providers/`: Dependency injection (Supabase, Logger, SharedPreferences)
  - `services/`: EnvService (env vars), LoggerService (with Sentry breadcrumbs)
  - `utils/`: String/DateTime extensions

**lib/features/[feature]/**
- Purpose: Isolated feature modules
- Structure per feature:
  - `domain/`: Freezed models, enums, exceptions (no external deps)
  - `data/`: Repositories (Supabase + error handling)
  - `application/`: Services (business logic, validation)
  - `presentation/`: Screens, widgets, providers (UI)
- Only cross-feature communication: via services/providers, never direct imports

**lib/widgets/**
- Purpose: App-wide reusable UI components
- Examples: SkeletonLoader, SupabaseImage, custom icon definitions
- Used by: Multiple features, shared across screens

**test/**
- Purpose: Unit, widget, and integration tests
- Structure: Mirrors lib/ structure for easy navigation
- Helpers: `pump_app.dart` for widget test setup, mocks/ for test doubles

**env/**
- Purpose: Flavor-specific configuration
- Files: `.env.development`, `.env.staging`, `.env.production`
- Loaded by: `EnvService.load()` in bootstrap
- Contents: Supabase URL/key, RevenueCat API key, Sentry DSN, app environment

## Key File Locations

**Entry Points:**
- `lib/main_development.dart`: Calls `bootstrap(App(), 'env/.env.development')`
- `lib/main_staging.dart`: Calls `bootstrap(App(), 'env/.env.staging')`
- `lib/main_production.dart`: Calls `bootstrap(App(), 'env/.env.production')`

**Configuration:**
- `lib/bootstrap.dart`: Initializes Sentry, Supabase, RevenueCat, SharedPreferences
- `lib/core/services/env_service.dart`: Loads and provides env vars
- `pubspec.yaml`: Dependencies (flutter_riverpod, supabase_flutter, drift, etc.)

**Core Logic:**
- `lib/app/app.dart`: Service initialization (notifications, health sync, subscriptions)
- `lib/app/router/app_router.dart`: Auth and onboarding redirects
- `lib/app/router/routes.dart`: Route definitions (TypedGoRoute, shells, branches)

**Testing:**
- `test/helpers/pump_app.dart`: Widget test setup with ProviderScope and ProviderContainer
- `test/helpers/mocks/`: Mock repositories and services
- `test/features/[feature]/`: Unit and widget tests per feature

## Naming Conventions

**Files:**
- PascalCase for Dart files: `user_activity.dart`, `activity_logging_service.dart`
- Suffixes: `_repository.dart`, `_service.dart`, `_provider.dart`, `_screen.dart`, `_widget.dart`
- Generated files: `*.g.dart` (JSON serialization, Riverpod), `*.freezed.dart` (Freezed), `*.gen.dart` (flutter_gen)
- Test files: `*_test.dart`, `*_test.dart` (mirroring source structure)

**Directories:**
- snake_case: `lib/features/activity_logging/`, `lib/core/providers/`
- Feature names: Plural when collection (activities, settings), singular when feature (auth, home, profile)
- Sublayers: `domain/`, `data/`, `application/`, `presentation/`
- Presentation sub-layers: `screens/`, `widgets/`, `providers/`

**Classes:**
- PascalCase: `UserActivity`, `ActivityLoggingService`, `ActivityFormStateNotifier`
- Exceptions: `[Feature]Exception` or `[Feature][Type]Exception`
  - Example: `ActivityLoggingValidationException`, `AuthSignInCancelledException`
- StateNotifier: `[ClassName]StateNotifier` generates provider `[className]StateProvider`
- Providers: `@riverpod` (auto-dispose), `@Riverpod(keepAlive: true)` (app-wide)

**Provider Names:**
- Query: `userActivitiesByDate`, `activityProvider`
- State mutation: `activityFormProvider` (StateNotifier), `preferencesProvider`
- Stream: `authStateProvider`
- Infrastructure: `loggerProvider`, `supabaseProvider`

## Where to Add New Code

**New Feature:**
1. Create directory: `lib/features/[feature_name]/`
2. Structure:
   - `domain/` - Domain models (Freezed), exceptions, enums
   - `data/` - Repositories with `@Riverpod(keepAlive: true)` providers
   - `application/` (optional) - Services with `@Riverpod(keepAlive: true)` providers if complex business logic
   - `presentation/` - Screens, widgets, providers
3. Example: `lib/features/new_feature/domain/new_entity.dart` (Freezed model)

**New Screen:**
1. Create file: `lib/features/[feature]/presentation/screens/[screen_name]_screen.dart`
2. Extend: `ConsumerStatefulWidget` or `ConsumerWidget`
3. Route: Add `TypedGoRoute` to `lib/app/router/routes.dart`
4. Navigate: Use `context.go('/path')` from GoRouter

**New Provider:**
1. Location: `lib/features/[feature]/presentation/providers/[name]_provider.dart`
2. If query/async: Use `@riverpod` (auto-dispose)
3. If app-wide state: Use `@Riverpod(keepAlive: true)`
4. If form/mutable: Use StateNotifier class + `@riverpod`

**New Widget:**
1. Location: `lib/features/[feature]/presentation/widgets/[name]_widget.dart`
2. Extend: `StatelessWidget`, `StatefulWidget`, or `ConsumerWidget`
3. Reusable: If used in multiple features, move to `lib/widgets/`

**New Service:**
1. Location: `lib/features/[feature]/application/[name]_service.dart`
2. Pattern: Accept repository providers, validate input, throw exceptions
3. Provider: Add `@Riverpod(keepAlive: true)` at file bottom
4. Usage: Called by UI providers and screens only

**New Repository:**
1. Location: `lib/features/[feature]/data/[name]_repository.dart`
2. Pattern: Accept Supabase + Logger, return domain models, throw exceptions
3. Provider: Add `@Riverpod(keepAlive: true)` at file bottom
4. Usage: Called by services only, never by UI

**Utilities/Extensions:**
- Global: `lib/core/utils/`
- Feature-specific: `lib/features/[feature]/presentation/utils/` or inline in widget

## Special Directories

**lib/gen/**
- Purpose: Generated asset references
- Generated: Yes (flutter_gen)
- Committed: Yes (checked in)
- Usage: `FlutterGenAssets.images.logoSvg` (type-safe asset access)

**lib/app/database/tables/**
- Purpose: Drift table definitions
- Generated: Partially (migrations)
- Committed: Yes
- Usage: `CachedData` for generic caching

**test/helpers/mocks/**
- Purpose: Test doubles (mock repositories, services)
- Generated: No (hand-written)
- Committed: Yes
- Pattern: Mock classes extend repository/service, implement methods with test behavior

**env/**
- Purpose: Environment configuration per flavor
- Generated: No (hand-written)
- Committed: No (.gitignored, only template provided)
- Structure: KEY=VALUE pairs for Supabase, RevenueCat, Sentry URLs/keys

---

*Structure analysis: 2026-02-02*
