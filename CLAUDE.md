# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Logly is a Flutter mobile app for tracking and logging personal activities (fitness, wellness, lifestyle). Users can log activities with metrics, sync health data from Apple HealthKit/Google Health Connect, view statistics and streaks, and get AI-powered insights.

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

### Project Structure

- `lib/app/` - App widget, database
- `lib/services/` - Service classes (e.g., DotEnvService)
- `lib/features/` - Feature modules (UI, state, models)
  - `application/` - services and providers that could be used by multiple features
  - `domain/` - freezed domain models and drift tables
  - `data/` - repositories and data access
    - `graphql/` - GraphQL queries and mutations
  - `presentation` - UI and state management
    - `screens/` - screens
    - `widgets/` - widgets
    - `providers/` - providers
- `lib/gen/` - Generated asset references
- `supabase/schema.ts` - Generated database types (reference for table structures)

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

Each feature has a `SPEC.md` with: Overview, Requirements, Architecture, Components, Data Operations, Integration, Testing Requirements, Future Considerations, checkbox-based Success Criteria, and a checklist of items to complete.

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
  final Logger _logger;

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
LogEntryRepository logEntryRepository(LogEntryRepositoryRef ref) {
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
  final Logger _logger;

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
LogEntryService logEntryService(LogEntryServiceRef ref) {
  return LogEntryService(
    ref.watch(logEntryRepositoryProvider), 
    ref.watch(loggerProvider)
  );
}
```

### Exception Handling

Custom exceptions per feature with `message` (user-facing) and `technicalDetails` (logging):

```dart
abstract class FeatureException implements Exception {
  const FeatureException(this.message, [this.technicalDetails]);
  final String message;
  final String? technicalDetails;
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
- Use environment variables via `DotEnvService` for config

### UI/UX

- Prefer shadcn_flutter for UI components with dark mode support, fallback to Material Design 3 if needed
- Loading (shimmer/progress that keeps the same widget shape and dimensions as the content), error (retry button), empty states (CTA)
- Confirmation dialogs for destructive actions
- Accessibility: semantic labels, contrast, 48x48dp touch targets
- screenshots may be give to you as general guidance and does not neessitate pixel perfection:
  - use placeholders for images that you see
  - don't worry about the exact colors, fonts, or spacing
  - focus on the layout and functionality
  - if you are unsure about something, use your best judgement

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
