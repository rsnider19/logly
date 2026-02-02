# Coding Conventions

**Analysis Date:** 2026-02-02

## Naming Patterns

**Files:**
- Snake case: `user_preferences.dart`, `home_service.dart`, `daily_activities_repository.dart`
- Descriptive names that reflect purpose and layer

**Functions:**
- Camel case: `getPreferences()`, `fillDateRange()`, `exportData()`
- Private functions prefixed with underscore: `_parseThemeMode()`, `_initializeAndRun()`
- Verb-noun pattern for action methods: `setThemeMode()`, `signInWithGoogle()`, `clearAllCache()`

**Variables:**
- Camel case: `mockAuthService`, `mockLogger`, `mockDailyActivitiesRepository`
- Private members prefixed with underscore: `_repository`, `_supabase`, `_logger`
- Final when appropriate: `final userId = _supabase.auth.currentUser?.id`

**Types:**
- Pascal case for classes: `SettingsService`, `DailyActivitySummary`, `UserPreferences`
- Pascal case for enums: `UnitSystem`, `ThemeMode`
- Private classes prefixed with underscore when generated: `_$UserPreferences` (Freezed generated)

**Providers:**
- Lowercase with descriptive suffix: `settingsServiceProvider`, `settingsRepositoryProvider`, `authServiceProvider`
- Pattern: `<feature><layer>Provider` (e.g., `settingsRepositoryProvider`, `homeServiceProvider`)

## Code Style

**Formatting:**
- Page width: 120 characters (enforced via `analysis_options.yaml`)
- Trailing commas: preserved (not removed)
- Tool: Dart formatter (auto-formatted by Very Good Analysis)

**Linting:**
- Framework: `very_good_analysis` v10.0.0
- Custom lint enabled via `custom_lint`
- Generated files excluded from analysis: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.graphql.dart`, `lib/gen/*`
- Specific rule overrides in `analysis_options.yaml`:
  - `public_member_api_docs: false` - no API docs requirement for public members
  - `lines_longer_than_80_chars: false` - allows 120 chars
  - `require_trailing_commas: true` - enforce trailing commas
  - `avoid_catches_without_on_clauses: false` - allows bare catch

## Import Organization

**Order:**
1. Dart imports: `dart:async`, `dart:io`, `dart:convert`
2. Flutter imports: `package:flutter/...`, `package:flutter_riverpod/...`
3. Package imports: `package:freezed_annotation/...`, `package:riverpod_annotation/...`
4. Local imports: `package:logly/...`
5. Relative imports (used in generated files): `part '*.g.dart'`, `part '*.freezed.dart'`

**Path Aliases:**
- No path aliases used; full package paths consistent across codebase
- Pattern: `import 'package:logly/core/services/logger_service.dart'`
- Aliasing used only for disambiguation: `import 'package:logly/core/utils/date_utils.dart' as app_date_utils`

## Error Handling

**Patterns:**
- Custom exceptions extend `AppException` base class (defined in `lib/core/exceptions/app_exception.dart`)
- All feature exceptions are custom subtypes with two fields:
  - `message` (String) - user-facing error message
  - `technicalDetails` (String?) - technical details for logging, never shown to users
- Exception classes follow naming: `<Feature><Action>Exception` (e.g., `AuthSignInCancelledException`, `SavePreferencesException`, `ExportDataException`)
- Repositories log errors with logger before throwing: `_logger.e('Failed to load preferences', e, st)`
- Services validate input and throw specific exceptions; repositories are "dumb" data access only
- Try-catch pattern: catch, log technical details, throw user-facing exception

**Example from `settings_repository.dart`:**
```dart
Future<void> setThemeMode(ThemeMode themeMode) async {
  try {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const SavePreferencesException('User not authenticated');
    }
    await _supabase.from('profile').update({'theme_mode': themeModeString}).eq('user_id', userId);
  } catch (e, st) {
    _logger.e('Failed to save theme mode', e, st);
    if (e is SavePreferencesException) rethrow;
    throw SavePreferencesException(e.toString());
  }
}
```

## Logging

**Framework:** `LoggerService` wrapper around `logger` package (v2.5.0)

**Patterns:**
- Uses `LoggerService` injected via Riverpod, never direct `print()`
- Four log levels: `d()` (debug), `i()` (info), `w()` (warning), `e()` (error)
- Single parameter for message: `_logger.i('Initiating Google sign-in')`
- Error logging includes error object and stacktrace: `_logger.e('Failed to export data', e, st)`
- Sentry integration: Errors captured automatically in non-debug builds, breadcrumbs for lower levels
- Configuration in `bootstrap()`: Sentry disabled in debug mode, enabled in release with trace sampling

**Example from `settings_service.dart`:**
```dart
_logger.i('Data exported successfully');
// Later...
_logger.e('Failed to export data', e, st);
```

## Comments

**When to Comment:**
- Documentation comments (///) on public classes, functions, and complex logic
- Inline comments (//) for non-obvious algorithm details or business logic
- MARK: comments used for section organization in helpers (e.g., `// MARK: - Mocks`)

**JSDoc/TSDoc:**
- Doc comments on all public APIs, repositories, and services
- Triple-slash format (///) followed by description
- One-liner for simple functions: `/// Capitalizes the first letter of the string.`
- Multi-line for complex behavior with numbered steps

**Example from `extensions.dart`:**
```dart
/// Formats the date for display (e.g., "Jan 15, 2024").
String get displayFormat => app_date_utils.DateUtils.formatDisplay(this);

/// Returns true if this date is the same day as another date.
bool isSameDayAs(DateTime other) => app_date_utils.DateUtils.isSameDay(this, other);
```

## Function Design

**Size:** Small, focused functions with single responsibility. Complex logic broken into helper methods (often private).

**Parameters:**
- Required parameters not wrapped in curly braces unless explicitly optional
- Named parameters used for clarity in multi-parameter functions
- Example: `Future<void> exportData()` vs `Future<List<LogEntry>> getByDate(String userId, DateTime date)`

**Return Values:**
- Async operations return `Future<T>` (repositories/services)
- UI providers return `AsyncValue<T>` (auto-wrapped by Riverpod)
- Extensions return computed properties via getters: `String get displayFormat`
- Null-safe with explicit Optional types: `String?` for nullable values

## Module Design

**Exports:**
- No barrel files (no `lib/features/auth/index.dart` re-exports)
- Direct imports of specific classes: `import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart'`

**Barrel Files:**
- Not used in this codebase; each import is explicit to the file

**Feature Structure:**
- `domain/` - domain models (Freezed classes), exceptions, enums
- `data/` - repositories (data access layer)
- `application/` - services (business logic layer)
- `presentation/` - UI (screens, widgets, providers)

**Repository & Service Pattern:**
- Repository class + Riverpod provider in same file (provider at end)
- Service class + Riverpod provider in same file (provider at end)
- Naming: `<Feature><Layer>.dart` (e.g., `settings_repository.dart`, `home_service.dart`)

**Example file structure:**
```dart
// settings_repository.dart
class SettingsRepository { /* implementation */ }

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) { /* provider */ }
```

## Freezed & JSON Serialization

**Pattern:**
- All domain models use `@freezed` annotation
- Abstract classes with `= _ClassName` factory syntax
- Include `fromJson()` and `toJson()` methods
- Custom `JsonConverter` for non-standard enum serialization

**Example from `user_preferences.dart`:**
```dart
@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @ThemeModeConverter() @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(false) bool healthSyncEnabled,
  }) = _UserPreferences;
  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
}

class ThemeModeConverter implements JsonConverter<ThemeMode, String?> {
  const ThemeModeConverter();
  @override
  ThemeMode fromJson(String? json) {
    return switch (json) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  @override
  String toJson(ThemeMode object) => /* reverse mapping */;
}
```

## Riverpod Patterns

**Annotations:**
- `@Riverpod(keepAlive: true)` for repositories and services (app-wide state)
- `@riverpod` (auto-dispose) for UI providers that are feature-specific
- Generated providers via `riverpod_generator` (code generation required)

**Naming:**
- Notifiers use `StateNotifier` suffix: class `HomeStateNotifier` generates `homeStateProvider`
- Regular providers use lowercase name: `settingsRepository()` generates `settingsRepositoryProvider`

**References:**
- See `lib/features/settings/application/settings_service.dart` for service provider
- See `lib/features/settings/data/settings_repository.dart` for repository provider

---

*Convention analysis: 2026-02-02*
