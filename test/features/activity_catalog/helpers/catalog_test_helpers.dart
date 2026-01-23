import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/database/database_provider.dart';
import 'package:logly/app/database/drift_database.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/data/activity_repository.dart';
import 'package:logly/features/activity_catalog/data/category_repository.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// MARK: - Mocks

/// Mock for [SupabaseClient].
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock for [AppDatabase].
class MockAppDatabase extends Mock implements AppDatabase {}

/// Mock for [LoggerService].
class MockLoggerService extends Mock implements LoggerService {}

/// Mock for [CategoryRepository].
class MockCategoryRepository extends Mock implements CategoryRepository {}

/// Mock for [ActivityRepository].
class MockActivityRepository extends Mock implements ActivityRepository {}

/// Mock for [FunctionsClient].
class MockFunctionsClient extends Mock implements FunctionsClient {}

/// Mock for [FunctionResponse].
class MockFunctionResponse extends Mock implements FunctionResponse {}

// MARK: - Fake Data Factories

/// Creates a fake [ActivityCategory] with optional overrides.
ActivityCategory fakeActivityCategory({
  String? activityCategoryId,
  String? name,
  String? activityCategoryCode,
  String? description,
  String? hexColor,
  String? icon,
  int? sortOrder,
}) {
  return ActivityCategory(
    activityCategoryId: activityCategoryId ?? 'cat-${DateTime.now().microsecondsSinceEpoch}',
    name: name ?? 'Test Category',
    activityCategoryCode: activityCategoryCode ?? 'TEST',
    description: description,
    hexColor: hexColor ?? '#FF5733',
    sortOrder: sortOrder ?? 1,
  );
}

/// Creates a fake [Activity] with optional overrides.
Activity fakeActivity({
  String? activityId,
  String? activityCategoryId,
  String? name,
  String? activityCode,
  String? description,
  String? hexColor,
  String? icon,
  ActivityDateType? activityDateType,
  bool? isSuggestedFavorite,
  ActivityCategory? activityCategory,
  List<ActivityDetail>? activityDetail,
  List<SubActivity>? subActivity,
}) {
  return Activity(
    activityId: activityId ?? 'act-${DateTime.now().microsecondsSinceEpoch}',
    activityCategoryId: activityCategoryId ?? 'cat-1',
    name: name ?? 'Test Activity',
    activityCode: activityCode ?? 'TEST_ACT',
    description: description,
    activityDateType: activityDateType ?? ActivityDateType.single,
    isSuggestedFavorite: isSuggestedFavorite ?? false,
    activityCategory: activityCategory,
    activityDetail: activityDetail ?? [],
    subActivity: subActivity ?? [],
  );
}

/// Creates a fake [ActivityDetail] with optional overrides.
ActivityDetail fakeActivityDetail({
  String? activityDetailId,
  String? activityId,
  String? label,
  ActivityDetailType? activityDetailType,
  int? sortOrder,
  double? minNumeric,
  double? maxNumeric,
}) {
  return ActivityDetail(
    activityDetailId: activityDetailId ?? 'detail-${DateTime.now().microsecondsSinceEpoch}',
    activityId: activityId ?? 'act-1',
    label: label ?? 'Duration',
    activityDetailType: activityDetailType ?? ActivityDetailType.duration,
    sortOrder: sortOrder ?? 1,
    minNumeric: minNumeric,
    maxNumeric: maxNumeric,
  );
}

/// Creates a fake [SubActivity] with optional overrides.
SubActivity fakeSubActivity({
  String? subActivityId,
  String? activityId,
  String? name,
  String? subActivityCode,
  String? icon,
}) {
  return SubActivity(
    subActivityId: subActivityId ?? 'sub-${DateTime.now().microsecondsSinceEpoch}',
    activityId: activityId ?? 'act-1',
    name: name ?? 'Test Sub Activity',
    subActivityCode: subActivityCode ?? 'TEST_SUB',
  );
}

// MARK: - Test Data

/// Sample categories matching the app's actual categories.
List<ActivityCategory> get testCategories => [
      fakeActivityCategory(
        activityCategoryId: 'cat-fitness',
        name: 'Fitness',
        activityCategoryCode: 'FITNESS',
        hexColor: '#FF5733',
        icon: 'fitness_center',
        sortOrder: 1,
      ),
      fakeActivityCategory(
        activityCategoryId: 'cat-sports',
        name: 'Sports',
        activityCategoryCode: 'SPORTS',
        hexColor: '#33FF57',
        icon: 'sports_soccer',
        sortOrder: 2,
      ),
      fakeActivityCategory(
        activityCategoryId: 'cat-wellness',
        name: 'Wellness',
        activityCategoryCode: 'WELLNESS',
        hexColor: '#5733FF',
        icon: 'spa',
        sortOrder: 3,
      ),
      fakeActivityCategory(
        activityCategoryId: 'cat-lifestyle',
        name: 'Lifestyle',
        activityCategoryCode: 'LIFESTYLE',
        hexColor: '#FF33F5',
        icon: 'self_improvement',
        sortOrder: 4,
      ),
      fakeActivityCategory(
        activityCategoryId: 'cat-nutrition',
        name: 'Nutrition',
        activityCategoryCode: 'NUTRITION',
        hexColor: '#33FFF5',
        icon: 'restaurant',
        sortOrder: 5,
      ),
      fakeActivityCategory(
        activityCategoryId: 'cat-mindfulness',
        name: 'Mindfulness',
        activityCategoryCode: 'MINDFULNESS',
        hexColor: '#F5FF33',
        icon: 'psychology',
        sortOrder: 6,
      ),
    ];

/// Sample activities with nested data.
List<Activity> get testActivities => [
      fakeActivity(
        activityId: 'act-running',
        activityCategoryId: 'cat-fitness',
        name: 'Running',
        activityCode: 'RUNNING',
        activityCategory: testCategories[0],
        activityDetail: [
          fakeActivityDetail(
            activityDetailId: 'detail-duration',
            activityId: 'act-running',
            label: 'Duration',
            activityDetailType: ActivityDetailType.duration,
            sortOrder: 1,
          ),
          fakeActivityDetail(
            activityDetailId: 'detail-distance',
            activityId: 'act-running',
            label: 'Distance',
            activityDetailType: ActivityDetailType.distance,
            sortOrder: 2,
          ),
        ],
        subActivity: [
          fakeSubActivity(
            subActivityId: 'sub-interval',
            activityId: 'act-running',
            name: 'Interval Running',
            subActivityCode: 'INTERVAL',
          ),
        ],
      ),
      fakeActivity(
        activityId: 'act-yoga',
        activityCategoryId: 'cat-wellness',
        name: 'Yoga',
        activityCode: 'YOGA',
        activityCategory: testCategories[2],
        isSuggestedFavorite: true,
      ),
      fakeActivity(
        activityId: 'act-swimming',
        activityCategoryId: 'cat-fitness',
        name: 'Swimming',
        activityCode: 'SWIMMING',
        activityCategory: testCategories[0],
      ),
    ];

// MARK: - Test Container Helpers

/// Creates a [ProviderContainer] with repository-related provider overrides.
///
/// Use this for testing services that depend on repositories.
ProviderContainer createCatalogServiceTestContainer({
  required MockCategoryRepository mockCategoryRepository,
  required MockActivityRepository mockActivityRepository,
  required MockLoggerService mockLogger,
}) {
  return ProviderContainer(
    overrides: [
      categoryRepositoryProvider.overrideWithValue(mockCategoryRepository),
      activityRepositoryProvider.overrideWithValue(mockActivityRepository),
      loggerProvider.overrideWithValue(mockLogger),
    ],
  );
}

/// Creates a [ProviderContainer] with database override.
///
/// Use this for testing repositories with real database.
ProviderContainer createCatalogRepositoryTestContainer({
  required AppDatabase testDatabase,
  required MockLoggerService mockLogger,
}) {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(testDatabase),
      loggerProvider.overrideWithValue(mockLogger),
    ],
  );
}

/// Sets up default mock behavior for [MockLoggerService].
void setupMockLogger(MockLoggerService mockLogger) {
  when(() => mockLogger.i(any())).thenReturn(null);
  when(() => mockLogger.d(any())).thenReturn(null);
  when(() => mockLogger.w(any(), any(), any())).thenReturn(null);
  when(() => mockLogger.e(any(), any(), any())).thenReturn(null);
}

// MARK: - JSON Conversion Helpers

/// Converts a list of [ActivityCategory] to JSON format as returned by Supabase.
List<Map<String, dynamic>> categoriesToJson(List<ActivityCategory> categories) {
  return categories.map((c) => c.toJson()).toList();
}

/// Converts a list of [Activity] to JSON format as returned by Supabase.
List<Map<String, dynamic>> activitiesToJson(List<Activity> activities) {
  return activities.map((a) => a.toJson()).toList();
}
