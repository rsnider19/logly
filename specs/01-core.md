# 01 - Core Infrastructure

## Overview

The core module provides foundational infrastructure that all other features depend on. This includes Supabase client setup, environment configuration, base domain models, repository/service patterns, navigation, and local caching.

## Requirements

### Functional Requirements

- [ ] Configure Supabase client with environment-specific credentials
- [ ] Support three flavors: development, staging, production
- [ ] Establish base patterns for Freezed domain models
- [ ] Implement repository pattern for data access
- [ ] Implement service pattern for business logic
- [ ] Configure GoRouter with route guards
- [ ] Set up Drift for local SQLite caching
- [ ] Implement activity_date migration support

### Non-Functional Requirements

- [ ] Environment variables must not be committed to source control
- [ ] All sensitive data must be loaded from `.env` files
- [ ] Local cache must support offline read operations
- [ ] Navigation must support deep linking

## Architecture

### Environment Configuration

```
env/
├── .env.development
├── .env.staging
└── .env.production
```

Each environment file contains:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `REVENUECAT_API_KEY`
- `MIXPANEL_TOKEN`
- `GROWTHBOOK_CLIENT_KEY`

### Supabase Client Setup

```dart
@Riverpod(keepAlive: true)
SupabaseClient supabase(Ref ref) {
  return Supabase.instance.client;
}
```

Initialization happens in `bootstrap.dart` before `runApp()`.

### Base Domain Model Pattern

All domain models use Freezed:

```dart
@freezed
abstract class BaseModel with _$BaseModel {
  const factory BaseModel({
    required String id,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BaseModel;

  factory BaseModel.fromJson(Map<String, dynamic> json) => _$BaseModelFromJson(json);
}
```

### Repository Pattern

```dart
class ExampleRepository {
  ExampleRepository(this._supabase, this._logger);
  final SupabaseClient _supabase;
  final Logger _logger;

  Future<Model> getById(String id) async {
    try {
      final response = await _supabase.from('table').select().eq('id', id).single();
      return Model.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch', error: e, stackTrace: st);
      throw ExampleException('Could not load item', e.toString());
    }
  }
}

@Riverpod(keepAlive: true)
ExampleRepository exampleRepository(Ref ref) {
  return ExampleRepository(ref.watch(supabaseProvider), ref.watch(loggerProvider));
}
```

### Service Pattern

```dart
class ExampleService {
  ExampleService(this._repository, this._logger);
  final ExampleRepository _repository;
  final Logger _logger;

  Future<Model> doBusinessLogic(String id) async {
    // Validation
    if (id.isEmpty) throw ValidationException('ID required');

    // Coordinate repositories
    return await _repository.getById(id);
  }
}

@Riverpod(keepAlive: true)
ExampleService exampleService(Ref ref) {
  return ExampleService(ref.watch(exampleRepositoryProvider), ref.watch(loggerProvider));
}
```

### GoRouter Setup

```dart
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

final router = GoRouter(
  routes: $appRoutes,
  redirect: (context, state) {
    final isAuthenticated = // check auth
    if (!isAuthenticated && !state.matchedLocation.startsWith('/auth')) {
      return '/auth';
    }
    return null;
  },
);
```

### Drift Local Cache

```dart
@DriftDatabase(tables: [CachedActivities, CachedUserActivities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}
```

## Components

### Files to Create

```
lib/
├── core/
│   ├── services/
│   │   ├── supabase_service.dart
│   │   ├── env_service.dart
│   │   └── logger_service.dart
│   ├── providers/
│   │   ├── supabase_provider.dart
│   │   └── logger_provider.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── extensions.dart
│   └── exceptions/
│       └── app_exception.dart
├── app/
│   ├── app.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── route_guards.dart
│   └── database/
│       ├── drift_database.dart
│       └── tables/
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `EnvService` | Load and provide environment variables |
| `SupabaseService` | Initialize and configure Supabase client |
| `LoggerService` | Centralized logging with Logger package |
| `AppDatabase` | Drift database for local caching |
| `AppException` | Base exception class for all features |

## Data Operations

### Environment Loading

```dart
Future<void> loadEnv(String envPath) async {
  await dotenv.load(fileName: envPath);
}
```

### Supabase Initialization

```dart
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  authOptions: FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
  ),
);
```

## Integration Points

- **Auth Feature**: Provides Supabase client for authentication
- **All Features**: Provides repository/service patterns, logging, exceptions
- **Health Integration**: Provides Drift for caching synced data

## Testing Requirements

### Unit Tests

- [ ] EnvService loads correct environment variables
- [ ] Logger service formats messages correctly
- [ ] Date utils handle timezone conversions

### Integration Tests

- [ ] Supabase client connects successfully
- [ ] Drift database creates and migrates correctly
- [ ] GoRouter navigates between routes

## Success Criteria

- [ ] All three flavors can be built and run
- [ ] Supabase client initializes without errors
- [ ] Drift database creates schema on first launch
- [ ] GoRouter handles all defined routes
- [ ] Offline mode detected and indicated to user
- [ ] All base patterns documented and followed consistently
