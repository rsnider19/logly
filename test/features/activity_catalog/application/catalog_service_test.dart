import 'package:flutter_test/flutter_test.dart';
import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/catalog_exception.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/catalog_test_helpers.dart';

void main() {
  late CatalogService service;
  late MockCategoryRepository mockCategoryRepository;
  late MockActivityRepository mockActivityRepository;
  late MockLoggerService mockLogger;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    mockActivityRepository = MockActivityRepository();
    mockLogger = MockLoggerService();

    setupMockLogger(mockLogger);

    service = CatalogService(
      mockCategoryRepository,
      mockActivityRepository,
      mockLogger,
    );
  });

  group('CatalogService', () {
    group('getCategories', () {
      test('delegates to category repository', () async {
        // Arrange
        final categories = testCategories;
        when(() => mockCategoryRepository.getAll()).thenAnswer((_) async => categories);

        // Act
        final result = await service.getCategories();

        // Assert
        expect(result, equals(categories));
        verify(() => mockCategoryRepository.getAll()).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenThrow(const CategoryFetchException('Test error'));

        // Act & Assert
        expect(
          () => service.getCategories(),
          throwsA(isA<CategoryFetchException>()),
        );
      });
    });

    group('getCategoryById', () {
      test('throws CategoryNotFoundException when ID is empty', () async {
        // Act & Assert
        expect(
          () => service.getCategoryById(''),
          throwsA(isA<CategoryNotFoundException>()),
        );
        verifyNever(() => mockCategoryRepository.getById(any()));
      });

      test('delegates to category repository when ID is valid', () async {
        // Arrange
        final category = testCategories.first;
        when(() => mockCategoryRepository.getById(category.activityCategoryId))
            .thenAnswer((_) async => category);

        // Act
        final result = await service.getCategoryById(category.activityCategoryId);

        // Assert
        expect(result, equals(category));
        verify(() => mockCategoryRepository.getById(category.activityCategoryId)).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockCategoryRepository.getById('valid-id'))
            .thenThrow(const CategoryNotFoundException('Not found'));

        // Act & Assert
        expect(
          () => service.getCategoryById('valid-id'),
          throwsA(isA<CategoryNotFoundException>()),
        );
      });
    });

    group('getActivitiesByCategory', () {
      test('throws ActivityFetchException when category ID is empty', () async {
        // Act & Assert
        expect(
          () => service.getActivitiesByCategory(''),
          throwsA(isA<ActivityFetchException>()),
        );
        verifyNever(() => mockActivityRepository.getByCategory(any()));
      });

      test('delegates to activity repository when ID is valid', () async {
        // Arrange
        final activities = testActivities;
        when(() => mockActivityRepository.getByCategory('cat-fitness'))
            .thenAnswer((_) async => activities);

        // Act
        final result = await service.getActivitiesByCategory('cat-fitness');

        // Assert
        expect(result, equals(activities));
        verify(() => mockActivityRepository.getByCategory('cat-fitness')).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockActivityRepository.getByCategory('valid-id'))
            .thenThrow(const ActivityFetchException('Fetch error'));

        // Act & Assert
        expect(
          () => service.getActivitiesByCategory('valid-id'),
          throwsA(isA<ActivityFetchException>()),
        );
      });
    });

    group('getActivityById', () {
      test('throws ActivityNotFoundException when ID is empty', () async {
        // Act & Assert
        expect(
          () => service.getActivityById(''),
          throwsA(isA<ActivityNotFoundException>()),
        );
        verifyNever(() => mockActivityRepository.getById(any()));
      });

      test('delegates to activity repository when ID is valid', () async {
        // Arrange
        final activity = testActivities.first;
        when(() => mockActivityRepository.getById(activity.activityId))
            .thenAnswer((_) async => activity);

        // Act
        final result = await service.getActivityById(activity.activityId);

        // Assert
        expect(result, equals(activity));
        verify(() => mockActivityRepository.getById(activity.activityId)).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockActivityRepository.getById('valid-id'))
            .thenThrow(const ActivityNotFoundException('Not found'));

        // Act & Assert
        expect(
          () => service.getActivityById('valid-id'),
          throwsA(isA<ActivityNotFoundException>()),
        );
      });
    });

    group('searchActivities', () {
      test('returns empty list when query is less than 2 characters', () async {
        // Act
        final resultEmpty = await service.searchActivities('');
        final resultOne = await service.searchActivities('a');
        final resultWhitespace = await service.searchActivities('  ');

        // Assert
        expect(resultEmpty, isEmpty);
        expect(resultOne, isEmpty);
        expect(resultWhitespace, isEmpty);
        verifyNever(() => mockActivityRepository.search(any()));
      });

      test('returns empty list when trimmed query is less than 2 characters', () async {
        // Act
        final result = await service.searchActivities(' a ');

        // Assert
        expect(result, isEmpty);
        verifyNever(() => mockActivityRepository.search(any()));
      });

      test('delegates to activity repository when query is valid', () async {
        // Arrange
        final activities = testActivities;
        when(() => mockActivityRepository.search('running'))
            .thenAnswer((_) async => activities);

        // Act
        final result = await service.searchActivities('running');

        // Assert
        expect(result, equals(activities));
        verify(() => mockActivityRepository.search('running')).called(1);
      });

      test('trims query before searching', () async {
        // Arrange
        when(() => mockActivityRepository.search('running'))
            .thenAnswer((_) async => []);

        // Act
        await service.searchActivities('  running  ');

        // Assert
        verify(() => mockActivityRepository.search('running')).called(1);
      });

      test('searches with exactly 2 characters', () async {
        // Arrange
        when(() => mockActivityRepository.search('ab'))
            .thenAnswer((_) async => []);

        // Act
        await service.searchActivities('ab');

        // Assert
        verify(() => mockActivityRepository.search('ab')).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockActivityRepository.search('valid'))
            .thenThrow(const ActivitySearchException('Search error'));

        // Act & Assert
        expect(
          () => service.searchActivities('valid'),
          throwsA(isA<ActivitySearchException>()),
        );
      });
    });

    group('getPopularActivities', () {
      test('delegates to activity repository', () async {
        // Arrange
        final activities = testActivities;
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => activities);

        // Act
        final result = await service.getPopularActivities();

        // Assert
        expect(result, equals(activities));
        verify(() => mockActivityRepository.getPopular()).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockActivityRepository.getPopular())
            .thenThrow(const ActivityFetchException('Fetch error'));

        // Act & Assert
        expect(
          () => service.getPopularActivities(),
          throwsA(isA<ActivityFetchException>()),
        );
      });
    });

    group('getSuggestedFavorites', () {
      test('delegates to activity repository', () async {
        // Arrange
        final favorites = testActivities.where((a) => a.isSuggestedFavorite).toList();
        when(() => mockActivityRepository.getSuggestedFavorites())
            .thenAnswer((_) async => favorites);

        // Act
        final result = await service.getSuggestedFavorites();

        // Assert
        expect(result, equals(favorites));
        verify(() => mockActivityRepository.getSuggestedFavorites()).called(1);
      });

      test('propagates exceptions from repository', () async {
        // Arrange
        when(() => mockActivityRepository.getSuggestedFavorites())
            .thenThrow(const ActivityFetchException('Fetch error'));

        // Act & Assert
        expect(
          () => service.getSuggestedFavorites(),
          throwsA(isA<ActivityFetchException>()),
        );
      });
    });

    group('prefetchCatalog', () {
      test('calls both getAll and getPopular in parallel', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenAnswer((_) async => testCategories);
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => testActivities);

        // Act
        await service.prefetchCatalog();

        // Assert
        verify(() => mockCategoryRepository.getAll()).called(1);
        verify(() => mockActivityRepository.getPopular()).called(1);
      });

      test('logs success message on completion', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenAnswer((_) async => testCategories);
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => testActivities);

        // Act
        await service.prefetchCatalog();

        // Assert
        verify(() => mockLogger.d('Catalog prefetch complete')).called(1);
      });

      test('does not throw when category fetch fails', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenThrow(const CategoryFetchException('Error'));
        when(() => mockActivityRepository.getPopular())
            .thenAnswer((_) async => testActivities);

        // Act & Assert - should not throw
        await expectLater(service.prefetchCatalog(), completes);
        verify(() => mockLogger.e('Catalog prefetch failed', any(), any())).called(1);
      });

      test('does not throw when activity fetch fails', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenAnswer((_) async => testCategories);
        when(() => mockActivityRepository.getPopular())
            .thenThrow(const ActivityFetchException('Error'));

        // Act & Assert - should not throw
        await expectLater(service.prefetchCatalog(), completes);
        verify(() => mockLogger.e('Catalog prefetch failed', any(), any())).called(1);
      });

      test('does not throw when both fetches fail', () async {
        // Arrange
        when(() => mockCategoryRepository.getAll())
            .thenThrow(const CategoryFetchException('Error'));
        when(() => mockActivityRepository.getPopular())
            .thenThrow(const ActivityFetchException('Error'));

        // Act & Assert - should not throw
        await expectLater(service.prefetchCatalog(), completes);
        verify(() => mockLogger.e('Catalog prefetch failed', any(), any())).called(1);
      });
    });
  });
}
