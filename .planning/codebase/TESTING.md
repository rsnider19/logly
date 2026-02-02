# Testing Patterns

**Analysis Date:** 2026-02-02

## Test Framework

**Runner:**
- `flutter_test` (built-in Flutter testing)
- Custom test runner via `very_good test --coverage --test-randomize-ordering-seed random`
- Config: `pubspec.yaml` (no separate test config file)

**Assertion Library:**
- `flutter_test` (package:flutter_test) provides `expect()`, `testWidgets()`, `group()`
- Custom matchers: `findsOneWidget`, `findsNothing`, `findsWidgets`, `isTrue`, `isA<T>()`

**Run Commands:**
```bash
very_good test --coverage --test-randomize-ordering-seed random              # Run all tests with coverage
fvm flutter test test/path/to/test_file.dart                                # Run single test file
very_good test --coverage --test-randomize-ordering-seed random --watch     # Watch mode (if supported)
```

## Test File Organization

**Location:**
- Co-located with source in `test/` directory mirroring `lib/` structure
- Pattern: `lib/features/auth/presentation/screens/sign_in_screen.dart` → `test/features/auth/presentation/screens/sign_in_screen_test.dart`
- Shared helpers per feature: `test/features/<feature>/helpers/<feature>_test_helpers.dart`
- Global helpers: `test/helpers/` (e.g., `test_helpers.dart`, `pump_app.dart`, `mocks/mock_logger.dart`)

**Naming:**
- Test files: `<component>_test.dart` (e.g., `sign_in_screen_test.dart`, `home_service_test.dart`)
- Test helper files: `<feature>_test_helpers.dart` (e.g., `home_test_helpers.dart`, `auth_test_helpers.dart`)

**Structure:**
```
test/
├── core/
│   ├── utils/
│   │   ├── date_utils_test.dart
│   │   └── extensions_test.dart
│   ├── services/
│   │   ├── logger_service_test.dart
│   │   └── env_service_test.dart
│   └── exceptions/
│       └── app_exception_test.dart
├── app/
│   ├── database/
│   │   └── drift_database_test.dart
│   └── router/
│       └── app_router_test.dart
├── features/
│   ├── auth/
│   │   ├── helpers/
│   │   │   └── auth_test_helpers.dart
│   │   ├── domain/
│   │   │   └── auth_exception_test.dart
│   │   ├── integration/
│   │   │   └── auth_integration_test.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_service_provider_test.dart
│   │       └── screens/
│   │           └── sign_in_screen_test.dart
│   └── home/
│       ├── helpers/
│       │   └── home_test_helpers.dart
│       ├── application/
│       │   └── home_service_test.dart
│       └── presentation/
│           ├── providers/
│           │   ├── daily_activities_provider_test.dart
│           │   └── daily_activities_pagination_test.dart
└── helpers/
    ├── mocks/
    │   ├── mock_logger.dart
    │   └── mock_auth_repository.dart
    ├── test_helpers.dart
    └── pump_app.dart
```

## Test Structure

**Suite Organization:**
- Use `group()` for logical test organization
- Use `setUp()` for per-test initialization (runs before each test)
- Use `tearDown()` for per-test cleanup (runs after each test)
- Nested groups for related test categories

**Example from `home_service_test.dart`:**
```dart
void main() {
  late HomeService service;
  late MockDailyActivitiesRepository mockDailyActivitiesRepository;
  late MockLoggerService mockLogger;

  setUp(() {
    mockDailyActivitiesRepository = MockDailyActivitiesRepository();
    mockLogger = MockLoggerService();
    setupMockLogger(mockLogger);
    service = HomeService(mockDailyActivitiesRepository, mockLogger);
  });

  group('HomeService', () {
    group('fillDateRange', () {
      test('generates correct number of days for a 30-day range', () {
        // Arrange
        final endDate = DateTime(2025, 1, 22);
        final startDate = DateTime(2024, 12, 24);
        // Act
        final result = service.fillDateRange(startDate: startDate, endDate: endDate, summaries: []);
        // Assert
        expect(result.length, equals(30));
      });
    });
  });
}
```

**Patterns:**
- **Arrange-Act-Assert (AAA):** Clear comment delineation for test logic flow
- **Setup/Teardown:** Mocks initialized in `setUp()`, disposed in `tearDown()`
- **Group Organization:** Logical test grouping by function/method name

## Mocking

**Framework:** `mocktail` (v1.0.4)
- Drop-in replacement for `mockito`, uses `Mock` class and `when()`, `verify()`
- No code generation required

**Patterns:**
- Define mock classes extending `Mock` and implementing interface:
  ```dart
  class MockDailyActivitiesRepository extends Mock implements DailyActivitiesRepository {}
  class MockLoggerService extends Mock implements LoggerService {}
  ```
- Use `when()` for behavior stubbing:
  ```dart
  when(() => mockRepository.getByDateRange(any(), any())).thenAnswer((_) async => summaries);
  ```
- Use `verify()` for method call assertions:
  ```dart
  verify(() => mockDailyActivitiesRepository.getByDateRange(startDate, endDate)).called(1);
  ```
- Special matchers: `any()` for wildcard arguments, `any(that: isA<DateTime>())` for type-specific

**Location:** Mocks defined in test files or dedicated mock files:
- Local mocks: inline in test file (e.g., `sign_in_screen_test.dart` defines `MockAuthService`)
- Shared mocks: in feature helpers (e.g., `test/features/home/helpers/home_test_helpers.dart`)
- Global mocks: in `test/helpers/mocks/` directory

**Example from `auth_integration_test.dart`:**
```dart
class MockAuthRepository extends Mock implements AuthRepository {}
class MockLoggerService extends Mock implements LoggerService {}

// In test
when(() => mockRepository.signInWithGoogle()).thenAnswer((_) async => mockResponse);
// Verify call
verify(() => mockRepository.signInWithGoogle()).called(1);
```

## Fixtures and Factories

**Test Data:**
- Factory functions for creating domain objects with sensible defaults
- Named parameters to override specific fields
- Located in feature-specific helpers

**Pattern from `home_test_helpers.dart`:**
```dart
DailyActivitySummary fakeDailyActivitySummary({
  DateTime? activityDate,
  int? activityCount,
}) {
  return DailyActivitySummary(
    activityDate: activityDate ?? DateTime.now(),
    activityCount: activityCount ?? 0,
  );
}

// Usage in test
final summaries = [
  fakeDailyActivitySummary(activityDate: DateTime(2025, 1, 5), activityCount: 3),
];
```

**Bulk Data Generators:**
```dart
List<DailyActivitySummary> generateSummariesForDateRange({
  required DateTime startDate,
  required DateTime endDate,
  int activityCount = 1,
}) {
  final summaries = <DailyActivitySummary>[];
  var current = DateTime(startDate.year, startDate.month, startDate.day);
  final end = DateTime(endDate.year, endDate.month, endDate.day);
  while (!current.isAfter(end)) {
    summaries.add(DailyActivitySummary(activityDate: current, activityCount: activityCount));
    current = DateTime(current.year, current.month, current.day + 1);
  }
  return summaries;
}
```

**Location:**
- `test/features/<feature>/helpers/<feature>_test_helpers.dart` - feature-specific factories
- `test/helpers/test_helpers.dart` - global test utilities (env setup)

**Mock Setup Helpers:**
```dart
void setupMockLogger(MockLoggerService mockLogger) {
  when(() => mockLogger.i(any())).thenReturn(null);
  when(() => mockLogger.d(any())).thenReturn(null);
  when(() => mockLogger.w(any(), any(), any())).thenReturn(null);
  when(() => mockLogger.e(any(), any(), any())).thenReturn(null);
}
```

## Coverage

**Requirements:** Not enforced (no minimum threshold detected)

**View Coverage:**
```bash
very_good test --coverage --test-randomize-ordering-seed random
# Coverage reports generated to coverage/lcov.info (LCOV format)
```

**Coverage Generation:**
- Generated automatically with `very_good test --coverage` command
- Tool: `lcov` format (standard coverage reporting)
- No HTML/interactive coverage viewer configured

## Test Types

**Unit Tests:**
- Scope: Individual functions, classes, or small units
- Approach: Mock all dependencies, test pure logic
- Example: `home_service_test.dart` tests `fillDateRange()` method with mocked repositories
- Assertion style: Direct `expect()` on return values and state

**Integration Tests:**
- Scope: Multiple components working together (service + repository, provider integration)
- Approach: Use real providers via `ProviderContainer`, mock external dependencies (Supabase, database)
- Example: `auth_integration_test.dart` tests full auth flow with mocked repositories
- ProviderContainer pattern:
  ```dart
  container = createAuthServiceTestContainer(
    mockRepository: mockRepository,
    mockLogger: mockLogger,
    mockDatabase: mockDatabase,
  );
  final authService = container.read(authServiceProvider);
  ```

**Widget/UI Tests:**
- Scope: Individual screens or components
- Approach: Use `testWidgets()` and `WidgetTester`, mock Riverpod providers via `ProviderScope` overrides
- Example: `sign_in_screen_test.dart` tests screen rendering with mocked `AuthService`
- Pattern:
  ```dart
  Widget createTestWidget({AuthService? authService}) {
    return ProviderScope(
      overrides: [
        if (authService != null) authServiceProvider.overrideWithValue(authService),
      ],
      child: const MaterialApp(home: SignInScreen()),
    );
  }
  testWidgets('renders app branding', (tester) async {
    await tester.pumpWidget(createTestWidget(authService: mockAuthService));
    expect(find.text('Logly'), findsOneWidget);
  });
  ```

**E2E Tests:**
- Not used in this codebase currently

## Common Patterns

**Async Testing:**
- Use `async`/`await` in test functions
- Use `thenAnswer()` for async mocks:
  ```dart
  when(() => mockRepository.getByDateRange(any(), any()))
    .thenAnswer((_) async => summaries);
  ```
- Use `await tester.pumpWidget()` and `await tester.pumpAndSettle()` for widget tests

**Error Testing:**
- Throw exceptions from mocked methods:
  ```dart
  when(() => mockRepository.signInWithGoogle())
    .thenThrow(const AuthSignInCancelledException());
  ```
- Assert exception thrown:
  ```dart
  expect(
    authService.signInWithGoogle,
    throwsA(isA<AuthSignInCancelledException>()),
  );
  ```
- Use `.having()` for exception property assertions:
  ```dart
  expect(
    authService.signInWithApple,
    throwsA(
      isA<AuthProviderException>()
        .having((e) => e.message, 'message', 'Apple sign-in failed'),
    ),
  );
  ```

**Date/Time Testing:**
- Use explicit `DateTime` constructors to avoid timezone issues:
  ```dart
  final endDate = DateTime(2025, 1, 22);  // Local time
  final startDate = DateTime(2024, 12, 24);
  ```
- Helper functions for date validation:
  ```dart
  bool areDatesContiguous(List<DateTime> dates) { /* checks for gaps */ }
  List<DateTime> findGaps(List<DateTime> dates) { /* returns missing dates */ }
  ```

**State Management Testing:**
- Use `ProviderContainer` to test Riverpod providers in isolation
- Override dependencies:
  ```dart
  final container = ProviderContainer(
    overrides: [
      supabaseProvider.overrideWithValue(mockSupabase),
    ],
  );
  ```
- Dispose container after test:
  ```dart
  tearDown(() {
    container.dispose();
  });
  ```

**Widget Finder Assertions:**
- `find.text('...')` - find by text
- `find.byIcon(Icons.x)` - find by icon
- `findsOneWidget` - expects exactly one match
- `findsNothing` - expects no matches
- Conditional assertions for platform-specific code:
  ```dart
  if (Platform.isIOS || Platform.isMacOS) {
    expect(find.text('Sign in with Apple'), findsOneWidget);
  } else {
    expect(find.text('Sign in with Apple'), findsNothing);
  }
  ```

## Environment Configuration in Tests

**Pattern from `test_helpers.dart`:**
```dart
void setUpTestEnv({
  String? supabaseUrl,
  String? supabaseAnonKey,
  String? googleWebClientId,
  String? googleIosClientId,
}) {
  dotenv.loadFromString(
    envString: '''
SUPABASE_URL=${supabaseUrl ?? 'https://test.supabase.co'}
SUPABASE_ANON_KEY=${supabaseAnonKey ?? 'test-anon-key'}
GOOGLE_WEB_CLIENT_ID=${googleWebClientId ?? 'test-web-client-id.apps.googleusercontent.com'}
GOOGLE_IOS_CLIENT_ID=${googleIosClientId ?? 'test-ios-client-id.apps.googleusercontent.com'}
''',
  );
}

void clearTestEnv() {
  dotenv.clean();
}
```

**Usage in tests:**
```dart
setUp(() {
  setUpTestEnv();
});

tearDown(() {
  clearTestEnv();
});
```

---

*Testing analysis: 2026-02-02*
