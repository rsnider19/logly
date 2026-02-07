# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Logly is a Flutter mobile app for tracking and logging personal activities (fitness, wellness, lifestyle). Users can log activities with metrics, sync health data from Apple HealthKit/Google Health Connect, view statistics and streaks, and get AI-powered insights.

- **App version**: 4.1.4
- **Flutter**: 3.38.6 (managed via FVM)
- **Dart SDK**: ^3.9.0

## Build & Run Commands

```bash
# Run with flavor (development/staging/production)
fvm flutter run --flavor development --target lib/main_development.dart
fvm flutter run --flavor staging --target lib/main_staging.dart
fvm flutter run --flavor production --target lib/main_production.dart

# Run tests
very_good test --coverage --test-randomize-ordering-seed random

# Run a single test file
fvm flutter test test/path/to/test_file.dart

# Code generation (Drift, Freezed, Riverpod, JSON serializable)
fvm dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
fvm dart run build_runner serve --delete-conflicting-outputs

# Analyze code
fvm flutter analyze
fvm dart run custom_lint
```

## Development Workflow

After you are all done making code changes and return to the user, always perform a hot restart on the running app using the `hot_restart` tool.

If it fails, ask the user for the DTD Uri and run `connect_dart_tooling_daemon` with the DTD Uri. NEVER run `launch_app`. I will always have it running from my IDE for debugging.

This ensures the user sees the changes immediately. If the hot restart fails due to compilation errors, fix the errors first and retry.

## Architecture

### State Management & Backend

- **Riverpod** for state management with code generation (`riverpod_annotation`, `riverpod_generator`)
  - when creating a new provider, always use the `riverpod_generator` to generate the provider and the provider notifier. use the `@Riverpod(keepAlive: true)` annotation to keep the provider alive if it is expected to always be in use. if the provider is only used in a specific screen, do not use the `keepAlive` annotation.
  - for Notifier providers, the class name should be formatted like `<classname>StateNotifier` and the generated provider will be formatted like `<classname>StateProvider`.
  - **NEVER use `ref` inside `State.dispose()`**. The `BuildContext` is invalid at that point. Instead, save any needed provider references (notifiers, values) in fields during `initState()` and use those fields in `dispose()`.
- **Supabase** for backend (auth, database via PostgREST, storage, edge functions)
- **Drift** for local SQLite caching and offline support

### Supabase & PostgREST

Data fetching uses Supabase's PostgREST client (`supabase_flutter`). Key patterns:

```dart
// Query with filters
final response = await supabase
    .from('activities')
    .select('id, name, category:categories(id, name)')
    .eq('user_id', userId)
    .order('created_at', ascending: false);

// Insert
final response = await supabase
    .from('log_entries')
    .insert({'activity_id': activityId, 'logged_at': DateTime.now().toIso8601String()})
    .select()
    .single();

// Update
await supabase
    .from('log_entries')
    .update({'notes': notes})
    .eq('id', entryId);

// Delete
await supabase
    .from('log_entries')
    .delete()
    .eq('id', entryId);

// RPC (stored procedures)
final response = await supabase.rpc('get_user_stats', params: {'user_id': userId});
```

### Supabase Edge Functions

Edge functions are Deno-based serverless functions that run on Supabase infrastructure. They are located in `supabase/functions/[function-name]/`.

**CRITICAL**: When creating a new edge function, you MUST update `supabase/config.toml` with a configuration block for the function. Without this configuration, the function will not run in the local development environment.

Each edge function requires the following configuration in `supabase/config.toml`:

```toml
[functions.function-name]
enabled = true
verify_jwt = false  # Set to true if the function should verify JWT tokens automatically
import_map = "./functions/function-name/deno.json"
entrypoint = "./functions/function-name/index.ts"
```

**JWT Verification**: Most edge functions should use `verify_jwt = false` and implement manual JWT verification via middleware for better control over authentication logic. Only set to `true` if you want Supabase to automatically verify JWT tokens before the function executes.

### Database Schema

The database schema is defined in `supabase/schema.ts` (generated TypeScript types). When working with data:

1. Reference `schema.ts` for table structures and relationships
2. Use the exact column names from the schema
3. Respect foreign key relationships for joins

### Freezed

when creating a new freezed class, always use the `freezed` package to generate the class. use the `@freezed` annotation to generate the class. always include a `fromJson` and `toJson` method for serialization. always make it an abstract class.

### Code Generation

The project uses extensive code generation. Generated files have these extensions:

- `*.g.dart` - JSON serializable, Riverpod, Drift
- `*.freezed.dart` - Freezed immutable classes
- `*.gen.dart` - Flutter Gen (assets)

### Flavor Configuration

Three environments configured via `.env` files in `env/` directory:

- `env/.env.development`
- `env/.env.staging`
- `env/.env.production`

Each flavor has its own entry point (`lib/main_*.dart`) that passes the env path to `bootstrap()`.

### Bootstrap & Initialization

`lib/bootstrap.dart` initializes in order:
1. Load env vars (`EnvService.load`)
2. Init Sentry (non-debug only, with AppException enrichment)
3. Init Supabase
4. Init RevenueCat (platform-specific API keys via `EnvService.revenueCatApiKey`)
5. Init SharedPreferences
6. Clear image cache

Post-app initialization (in `App.initState` via `addPostFrameCallback`):
1. Notification service
2. Health sync initializer (auto-syncs if enabled + previously synced)
3. Subscription initializer (syncs RevenueCat login with auth state)
4. Sentry user context (syncs auth state)

### Supabase Edge Functions

Six Deno/TypeScript edge functions in `supabase/functions/`:
- `activity` - Activity data operations
- `ai-insights` - AI chat completions (streaming)
- `embed` - Generate embeddings for activity search
- `search-activities` - Hybrid search (FTS + vector)
- `revenue-cat` - Webhook handler for subscription events
- `migrate-user` - Data migration utility

### Project Structure

```
lib/
├── app/                    # App widget, router, theme, database
│   ├── router/             # GoRouter config (app_router.dart, routes.dart)
│   ├── theme/              # AppTheme (FlexColorScheme)
│   └── database/           # Drift SQLite setup and cache tables
├── core/                   # Shared infrastructure
│   ├── providers/          # logger, supabase, shared_preferences, scaffold_messenger
│   ├── services/           # EnvService, LoggerService, SentryInitializer
│   ├── exceptions/         # AppException base class
│   └── utils/              # date_utils, extensions (String, DateTime, AsyncValue)
├── features/               # Feature modules (see below)
├── widgets/                # Shared widgets (SkeletonLoader, SupabaseImage, HapticItem, LoglyIcons)
└── gen/                    # Generated asset references (Flutter Gen)

supabase/
├── schema.ts               # Generated database types (reference for table structures)
├── migrations/             # SQL migration files
└── functions/              # Deno/TypeScript edge functions

specs/                      # Feature specification docs (01-core.md through 11-ai-insights.md)
```

#### Feature Modules

12 feature modules under `lib/features/`:

| Module | Description |
|--------|-------------|
| `auth` | Apple/Google sign-in, session management |
| `activity_catalog` | Browse/search activities and categories |
| `activity_logging` | Log, edit, delete activities with metrics |
| `custom_activity` | User-created custom activities |
| `home` | Daily activity feed, trending activities |
| `onboarding` | Intro pager, profile questions, favorites selection |
| `profile` | User stats, streaks, activity heatmap, charts |
| `settings` | Preferences, notifications, account management |
| `health_integration` | Apple HealthKit / Google Health Connect sync |
| `subscriptions` | RevenueCat integration, entitlements, paywalls |
| `ai_insights` | AI chat for activity insights (premium) |
| `developer` | Dev-only debugging tools |

#### Feature Module Anatomy

Each feature follows this layer structure:
- `domain/` - Freezed models, exception classes
- `data/` - Repositories (Supabase data access)
- `application/` - Services (business logic, validation, coordination)
- `presentation/` - screens/, widgets/, providers/

## Code Styles

### Dart

- Uses `very_good_analysis` lint rules
- Page width: 120 characters
- Trailing commas: preserved
- Generated files are excluded from analysis

### dartx Extensions

Use `dartx` package extensions for common operations instead of manual implementations:

```dart
import 'package:dartx/dartx.dart';

// Get date-only DateTime (strips time component)
final dateOnly = dateTime.date;  // NOT: DateTime(dt.year, dt.month, dt.day)

// Other useful dartx extensions
list.sortedBy((e) => e.name);      // Returns new sorted list
list.distinctBy((e) => e.id);       // Remove duplicates by key
string.isNullOrEmpty;               // Null-safe empty check
```

### Git

- always use conventional commits for commit messages

## Feature Development Patterns

### SPEC Files

Feature specifications are in `specs/` at the repo root (numbered files: `01-core.md` through `11-ai-insights.md`). Each spec includes: Overview, Requirements, Architecture, Components, Data Operations, Integration, Testing Requirements, Future Considerations, checkbox-based Success Criteria, and a checklist of items to complete. Some features also have a `SPEC.md` within their feature directory for additional context.

### Domain Models

Use Freezed for all domain models:

```dart
@freezed
abstract class LogEntry with _$LogEntry {
  const factory LogEntry({
    required String id,
    required String activityId,
    required DateTime loggedAt,
    String? notes,
  }) = _LogEntry;
  factory LogEntry.fromJson(Map<String, dynamic> json) => _$LogEntryFromJson(json);
}
```

### Repository Pattern

"Dumb" data access layer: fetch/mutate only, no business logic. Accept all IDs/params (no provider dependencies). Return domain models, throw custom exceptions, log errors only, fail fast (no retry). Use `@Riverpod(keepAlive: true)`. **ONLY called from services, never from UI**. Combine class + provider in same file with provider at bottom.

```dart
class LogEntryRepository {
  LogEntryRepository(this._supabase, this._logger);
  final SupabaseClient _supabase;
  final LoggerService _logger;

  Future<LogEntry> getById(String id) async {
    try {
      final response = await _supabase
          .from('log_entries')
          .select('*, activity:activities(*)')
          .eq('id', id)
          .single();
      return LogEntry.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch log entry', error: e, stackTrace: st);
      throw LogEntryException('Could not load activity', e.toString());
    }
  }

  Future<List<LogEntry>> getByDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _supabase
        .from('log_entries')
        .select('*, activity:activities(*)')
        .eq('user_id', userId)
        .gte('logged_at', startOfDay.toIso8601String())
        .lt('logged_at', endOfDay.toIso8601String())
        .order('logged_at', ascending: false);

    return (response as List).map((e) => LogEntry.fromJson(e)).toList();
  }

  Future<LogEntry> create(CreateLogEntry entry) async {
    final response = await _supabase
        .from('log_entries')
        .insert(entry.toJson())
        .select('*, activity:activities(*)')
        .single();
    return LogEntry.fromJson(response);
  }
}

@Riverpod(keepAlive: true)
LogEntryRepository logEntryRepository(Ref ref) {
  return LogEntryRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
```

### Service Pattern

Business logic layer: validate input, coordinate repositories/providers, enrich data. Use `@Riverpod(keepAlive: true)`. Throw specific exceptions. **Services are the ONLY layer that calls repositories**. Combine class + provider in same file with provider at bottom.

```dart
class LogEntryService {
  LogEntryService(this._repository, this._logger);
  final LogEntryRepository _repository;
  final LoggerService _logger;

  Future<LogEntry> logActivity({
    required String activityId,
    required DateTime loggedAt,
    String? notes,
  }) async {
    if (activityId.isEmpty) throw ValidationException('Activity required');

    final entry = CreateLogEntry(
      activityId: activityId,
      loggedAt: loggedAt,
      notes: notes,
    );
    return await _repository.create(entry);
  }
}

@Riverpod(keepAlive: true)
LogEntryService logEntryService(Ref ref) {
  return LogEntryService(
    ref.watch(logEntryRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
```

### Exception Handling

Custom exceptions per feature with `message` (user-facing) and `technicalDetails` (logging). All feature exceptions extend `AppException` from `lib/core/exceptions/app_exception.dart`:

```dart
// Base class (in lib/core/exceptions/app_exception.dart)
abstract class AppException implements Exception {
  const AppException(this.message, [this.technicalDetails]);
  final String message;
  final String? technicalDetails;
}

// Feature-specific exception (in lib/features/{feature}/domain/{feature}_exception.dart)
class AuthException extends AppException {
  const AuthException(super.message, [super.technicalDetails]);
}

class AuthSignInCancelledException extends AuthException {
  const AuthSignInCancelledException() : super('Sign in was cancelled');
}
```

### Provider Patterns

- **Repositories/Services**: `@Riverpod(keepAlive: true)`
- **State notifiers**: Class named `<ClassName>StateNotifier` generates `classNameStateProvider`
- **UI providers**: `@riverpod` (auto-dispose) unless app-wide
- Use `ref.watch()` for reactive dependencies

### Testing

Write unit tests for repositories (mock Supabase client), services (mock repositories), and domain models. Write widget tests for UI (loading/error/success states). Focus on behaviors over coverage percentages.

### Validation & Configuration

- Services validate (not repositories), throw specific exceptions
- Use environment variables via `EnvService` (`lib/core/services/env_service.dart`) for config

### UI/UX

- **Theming**: `flex_color_scheme` with `FlexScheme.shadNeutral`, dark mode only (`ThemeMode.dark`). Theme defined in `lib/app/theme/app_theme.dart`
- **UI Framework**: Material Design 3 for all components
- **Icons**: `lucide_icons_flutter` for consistent iconography
- Loading (shimmer/progress that keeps the same widget shape and dimensions as the content), error (retry button), empty states (CTA)
- Confirmation dialogs for destructive actions
- Accessibility: semantic labels, contrast, 48x48dp touch targets
- Screenshots may be given as general guidance and do not necessitate pixel perfection:
  - use placeholders for images that you see
  - don't worry about the exact colors, fonts, or spacing
  - focus on the layout and functionality
  - if you are unsure about something, use your best judgment

### Permissions

1. Primer screen → 2. Request → 3. Denied screen ("Open Settings") → 4. Router guards → 5. Initialize in bootstrap

### Navigation & Errors

- GoRouter in `app_router.dart` with guards. Use `go_router_builder` to generate the router and have strongly typed navigation.
- SnackBars for transient feedback, Dialogs for errors requiring action
- User-friendly messages, log technical details, no auto-retry

### Mock Data

Mock repositories with delays for realistic UX testing. Easy swap to real implementation. Same file structure (class + provider).

### Success Criteria

SPEC.md checklist: domain models, data operations, repositories, services, providers, integration, tests, docs.

## Key Dependencies

Major packages beyond standard Flutter:

| Package | Purpose |
|---------|---------|
| `supabase_flutter` / `supabase_auth_ui` | Backend and auth UI |
| `purchases_flutter` / `purchases_ui_flutter` | RevenueCat subscriptions |
| `health` | Apple HealthKit / Google Health Connect |
| `sentry_flutter` | Error reporting and performance monitoring |
| `mixpanel_flutter` | User analytics |
| `growthbook_sdk_flutter` | Feature flags |
| `fl_chart` | Charts (profile stats) |
| `flex_color_scheme` | Material Design 3 theming |
| `lucide_icons_flutter` | Icons |
| `flutter_chat_ui` / `flutter_chat_core` | AI insights chat UI |
| `drift` / `sqlite3_flutter_libs` | Local SQLite database |
| `go_router` / `go_router_builder` | Routing with code generation |
| `shimmer` | Loading skeleton effects |

## CI/CD

- **GitHub Actions** (`.github/workflows/main.yaml`): Semantic PR check, Flutter build validation, spell check. Runs on push/PR to main.
- **Codemagic** (`codemagic.yaml`): Production builds triggered by `v*` tags. Builds AAB (Google Play internal track) and IPA (App Store). Uses mac_mini_m2.
