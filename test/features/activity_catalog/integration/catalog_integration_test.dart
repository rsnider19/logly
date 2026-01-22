import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/data/activity_repository.dart';
import 'package:logly/features/activity_catalog/data/category_repository.dart';
import 'package:logly/features/activity_catalog/domain/catalog_exception.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/catalog_test_helpers.dart';

void main() {
  group('Catalog Integration Tests', () {
    late ProviderContainer container;
    late MockCategoryRepository mockCategoryRepository;
    late MockActivityRepository mockActivityRepository;
    late MockLoggerService mockLogger;

    setUp(() {
      mockCategoryRepository = MockCategoryRepository();
      mockActivityRepository = MockActivityRepository();
      mockLogger = MockLoggerService();

      setupMockLogger(mockLogger);

      container = ProviderContainer(
        overrides: [
          categoryRepositoryProvider.overrideWithValue(mockCategoryRepository),
          activityRepositoryProvider.overrideWithValue(mockActivityRepository),
          loggerProvider.overrideWithValue(mockLogger),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Full catalog load flow', () {
      test('loads categories through service -> repository', () async {
        // Arrange
        final categories = testCategories.take(3).toList();

        when(() => mockCategoryRepository.getAll()).thenAnswer((_) async => categories);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getCategories();

        // Assert
        expect(result, hasLength(3));
        expect(result[0].name, categories[0].name);
        verify(() => mockCategoryRepository.getAll()).called(1);
      });

      test('loads activities by category through full stack', () async {
        // Arrange
        final activities = testActivities.where((a) => a.activityCategoryId == 'cat-fitness').toList();

        when(() => mockActivityRepository.getByCategory('cat-fitness'))
            .thenAnswer((_) async => activities);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getActivitiesByCategory('cat-fitness');

        // Assert
        expect(result, isNotEmpty);
        expect(result.every((a) => a.activityCategoryId == 'cat-fitness'), isTrue);
        verify(() => mockActivityRepository.getByCategory('cat-fitness')).called(1);
      });

      test('loads single category by ID', () async {
        // Arrange
        final category = testCategories.first;

        when(() => mockCategoryRepository.getById(category.activityCategoryId))
            .thenAnswer((_) async => category);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getCategoryById(category.activityCategoryId);

        // Assert
        expect(result.activityCategoryId, category.activityCategoryId);
        expect(result.name, category.name);
      });

      test('loads single activity by ID', () async {
        // Arrange
        final activity = testActivities.first;

        when(() => mockActivityRepository.getById(activity.activityId))
            .thenAnswer((_) async => activity);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getActivityById(activity.activityId);

        // Assert
        expect(result.activityId, activity.activityId);
        expect(result.name, activity.name);
      });
    });

    group('Search flow', () {
      test('searches activities through service -> repository', () async {
        // Arrange
        final activities = testActivities.take(2).toList();

        when(() => mockActivityRepository.search('running'))
            .thenAnswer((_) async => activities);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.searchActivities('running');

        // Assert
        expect(result, hasLength(2));
        verify(() => mockActivityRepository.search('running')).called(1);
      });

      test('returns empty list for short queries without calling repository', () async {
        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.searchActivities('a');

        // Assert
        expect(result, isEmpty);
        verifyNever(() => mockActivityRepository.search(any()));
      });

      test('trims query before searching', () async {
        // Arrange
        when(() => mockActivityRepository.search('running'))
            .thenAnswer((_) async => []);

        // Act
        final service = container.read(catalogServiceProvider);
        await service.searchActivities('  running  ');

        // Assert
        verify(() => mockActivityRepository.search('running')).called(1);
      });
    });

    group('Popular and suggested activities', () {
      test('loads popular activities', () async {
        // Arrange
        final activities = testActivities;

        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => activities);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getPopularActivities();

        // Assert
        expect(result, hasLength(3));
        verify(() => mockActivityRepository.getPopular()).called(1);
      });

      test('loads suggested favorites', () async {
        // Arrange
        final favorites = testActivities.where((a) => a.isSuggestedFavorite).toList();

        when(() => mockActivityRepository.getSuggestedFavorites())
            .thenAnswer((_) async => favorites);

        // Act
        final service = container.read(catalogServiceProvider);
        final result = await service.getSuggestedFavorites();

        // Assert
        expect(result.every((a) => a.isSuggestedFavorite), isTrue);
        verify(() => mockActivityRepository.getSuggestedFavorites()).called(1);
      });
    });

    group('Prefetch catalog', () {
      test('prefetch loads both categories and popular activities', () async {
        // Arrange
        final categories = testCategories;
        final activities = testActivities;

        when(() => mockCategoryRepository.getAll())
            .thenAnswer((_) async => categories);
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => activities);

        // Act
        final service = container.read(catalogServiceProvider);
        await service.prefetchCatalog();

        // Assert
        verify(() => mockCategoryRepository.getAll()).called(1);
        verify(() => mockActivityRepository.getPopular()).called(1);
        verify(() => mockLogger.d('Catalog prefetch complete')).called(1);
      });

      test('prefetch does not throw when category fetch fails', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenThrow(const CategoryFetchException('Error'));
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => testActivities);

        // Act & Assert - should not throw
        final service = container.read(catalogServiceProvider);
        await expectLater(service.prefetchCatalog(), completes);
        verify(() => mockLogger.e('Catalog prefetch failed', any(), any())).called(1);
      });

      test('prefetch does not throw when activity fetch fails', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenAnswer((_) async => testCategories);
        when(() => mockActivityRepository.getPopular())
            .thenThrow(const ActivityFetchException('Error'));

        // Act & Assert - should not throw
        final service = container.read(catalogServiceProvider);
        await expectLater(service.prefetchCatalog(), completes);
        verify(() => mockLogger.e('Catalog prefetch failed', any(), any())).called(1);
      });
    });

    group('Error handling coordination', () {
      test('service validation prevents repository calls for empty category ID', () async {
        // Act
        final service = container.read(catalogServiceProvider);

        // Assert
        await expectLater(
          () => service.getCategoryById(''),
          throwsA(isA<CategoryNotFoundException>()),
        );

        verifyNever(() => mockCategoryRepository.getById(any()));
      });

      test('service validation prevents repository calls for empty activity ID', () async {
        // Act
        final service = container.read(catalogServiceProvider);

        // Assert
        await expectLater(
          () => service.getActivityById(''),
          throwsA(isA<ActivityNotFoundException>()),
        );

        verifyNever(() => mockActivityRepository.getById(any()));
      });

      test('service validation prevents repository calls for empty category filter', () async {
        // Act
        final service = container.read(catalogServiceProvider);

        // Assert
        await expectLater(
          () => service.getActivitiesByCategory(''),
          throwsA(isA<ActivityFetchException>()),
        );

        verifyNever(() => mockActivityRepository.getByCategory(any()));
      });

      test('repository errors propagate through service to caller', () async {
        // Arrange
        when(() => mockCategoryRepository.getById('nonexistent'))
            .thenThrow(const CategoryNotFoundException('Not found'));

        // Act & Assert
        final service = container.read(catalogServiceProvider);
        expect(
          () => service.getCategoryById('nonexistent'),
          throwsA(isA<CategoryNotFoundException>()),
        );
      });

      test('activity repository errors propagate through service', () async {
        // Arrange
        when(() => mockActivityRepository.getById('nonexistent'))
            .thenThrow(const ActivityNotFoundException('Not found'));

        // Act & Assert
        final service = container.read(catalogServiceProvider);
        expect(
          () => service.getActivityById('nonexistent'),
          throwsA(isA<ActivityNotFoundException>()),
        );
      });

      test('search errors propagate through service', () async {
        // Arrange
        when(() => mockActivityRepository.search('query'))
            .thenThrow(const ActivitySearchException('Search failed'));

        // Act & Assert
        final service = container.read(catalogServiceProvider);
        expect(
          () => service.searchActivities('query'),
          throwsA(isA<ActivitySearchException>()),
        );
      });
    });
  });
}
