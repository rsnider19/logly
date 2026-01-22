import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logly/app/database/drift_database.dart';

void main() {
  group('AppDatabase', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() async {
      await db.close();
    });

    group('upsertCachedData', () {
      test('inserts new cached data', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{"name": "Test"}',
        );

        final result = await db.getCachedData('test-id', 'activity');

        expect(result, isNotNull);
        expect(result!.id, 'test-id');
        expect(result.type, 'activity');
        expect(result.data, '{"name": "Test"}');
      });

      test('updates existing cached data with same id and type', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{"name": "Original"}',
        );

        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{"name": "Updated"}',
        );

        final result = await db.getCachedData('test-id', 'activity');

        expect(result!.data, '{"name": "Updated"}');
      });

      test('stores different items with same id but different type', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{"type": "activity"}',
        );

        await db.upsertCachedData(
          id: 'test-id',
          type: 'category',
          data: '{"type": "category"}',
        );

        final activity = await db.getCachedData('test-id', 'activity');
        final category = await db.getCachedData('test-id', 'category');

        expect(activity!.data, '{"type": "activity"}');
        expect(category!.data, '{"type": "category"}');
      });

      test('stores expiresAt when provided', () async {
        final expiresAt = DateTime.now().add(const Duration(hours: 1));

        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{}',
          expiresAt: expiresAt,
        );

        final result = await db.getCachedData('test-id', 'activity');

        expect(result!.expiresAt, isNotNull);
        expect(
          result.expiresAt!.difference(expiresAt).inSeconds.abs(),
          lessThan(2),
        );
      });
    });

    group('getCachedData', () {
      test('returns null for missing data', () async {
        final result = await db.getCachedData('nonexistent', 'activity');

        expect(result, isNull);
      });

      test('returns null when id exists but type does not match', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{}',
        );

        final result = await db.getCachedData('test-id', 'category');

        expect(result, isNull);
      });

      test('returns correct data for existing entry', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{"key": "value"}',
        );

        final result = await db.getCachedData('test-id', 'activity');

        expect(result, isNotNull);
        expect(result!.data, '{"key": "value"}');
      });
    });

    group('getCachedDataByType', () {
      test('returns empty list when no data of type exists', () async {
        final result = await db.getCachedDataByType('activity');

        expect(result, isEmpty);
      });

      test('returns all data of specified type', () async {
        await db.upsertCachedData(
          id: 'activity-1',
          type: 'activity',
          data: '{"id": 1}',
        );
        await db.upsertCachedData(
          id: 'activity-2',
          type: 'activity',
          data: '{"id": 2}',
        );
        await db.upsertCachedData(
          id: 'category-1',
          type: 'category',
          data: '{"id": 3}',
        );

        final result = await db.getCachedDataByType('activity');

        expect(result.length, 2);
        expect(result.map((e) => e.id), containsAll(['activity-1', 'activity-2']));
      });

      test('does not return data of other types', () async {
        await db.upsertCachedData(
          id: 'category-1',
          type: 'category',
          data: '{}',
        );

        final result = await db.getCachedDataByType('activity');

        expect(result, isEmpty);
      });
    });

    group('deleteCachedData', () {
      test('deletes specific cached data', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{}',
        );

        final deleted = await db.deleteCachedData('test-id', 'activity');
        final result = await db.getCachedData('test-id', 'activity');

        expect(deleted, 1);
        expect(result, isNull);
      });

      test('returns 0 when data does not exist', () async {
        final deleted = await db.deleteCachedData('nonexistent', 'activity');

        expect(deleted, 0);
      });

      test('does not delete data with same id but different type', () async {
        await db.upsertCachedData(
          id: 'test-id',
          type: 'activity',
          data: '{}',
        );
        await db.upsertCachedData(
          id: 'test-id',
          type: 'category',
          data: '{}',
        );

        await db.deleteCachedData('test-id', 'activity');

        final activity = await db.getCachedData('test-id', 'activity');
        final category = await db.getCachedData('test-id', 'category');

        expect(activity, isNull);
        expect(category, isNotNull);
      });
    });

    group('deleteCachedDataByType', () {
      test('deletes all data of specified type', () async {
        await db.upsertCachedData(
          id: 'activity-1',
          type: 'activity',
          data: '{}',
        );
        await db.upsertCachedData(
          id: 'activity-2',
          type: 'activity',
          data: '{}',
        );
        await db.upsertCachedData(
          id: 'category-1',
          type: 'category',
          data: '{}',
        );

        final deleted = await db.deleteCachedDataByType('activity');

        expect(deleted, 2);
        expect(await db.getCachedDataByType('activity'), isEmpty);
        expect(await db.getCachedDataByType('category'), hasLength(1));
      });

      test('returns 0 when no data of type exists', () async {
        final deleted = await db.deleteCachedDataByType('nonexistent');

        expect(deleted, 0);
      });
    });

    group('deleteExpiredCache', () {
      test('deletes expired data', () async {
        final pastExpiry = DateTime.now().subtract(const Duration(hours: 1));

        await db.upsertCachedData(
          id: 'expired',
          type: 'activity',
          data: '{}',
          expiresAt: pastExpiry,
        );

        final deleted = await db.deleteExpiredCache();
        final result = await db.getCachedData('expired', 'activity');

        expect(deleted, 1);
        expect(result, isNull);
      });

      test('keeps non-expired data', () async {
        final futureExpiry = DateTime.now().add(const Duration(hours: 1));

        await db.upsertCachedData(
          id: 'valid',
          type: 'activity',
          data: '{}',
          expiresAt: futureExpiry,
        );

        await db.deleteExpiredCache();
        final result = await db.getCachedData('valid', 'activity');

        expect(result, isNotNull);
      });

      test('keeps data with no expiry', () async {
        await db.upsertCachedData(
          id: 'no-expiry',
          type: 'activity',
          data: '{}',
        );

        await db.deleteExpiredCache();
        final result = await db.getCachedData('no-expiry', 'activity');

        expect(result, isNotNull);
      });

      test('deletes only expired data among mixed entries', () async {
        final pastExpiry = DateTime.now().subtract(const Duration(hours: 1));
        final futureExpiry = DateTime.now().add(const Duration(hours: 1));

        await db.upsertCachedData(
          id: 'expired',
          type: 'activity',
          data: '{}',
          expiresAt: pastExpiry,
        );
        await db.upsertCachedData(
          id: 'valid',
          type: 'activity',
          data: '{}',
          expiresAt: futureExpiry,
        );
        await db.upsertCachedData(
          id: 'no-expiry',
          type: 'activity',
          data: '{}',
        );

        final deleted = await db.deleteExpiredCache();

        expect(deleted, 1);
        expect(await db.getCachedData('expired', 'activity'), isNull);
        expect(await db.getCachedData('valid', 'activity'), isNotNull);
        expect(await db.getCachedData('no-expiry', 'activity'), isNotNull);
      });
    });

    group('clearAllCache', () {
      test('removes all cached data', () async {
        await db.upsertCachedData(
          id: 'activity-1',
          type: 'activity',
          data: '{}',
        );
        await db.upsertCachedData(
          id: 'category-1',
          type: 'category',
          data: '{}',
        );
        await db.upsertCachedData(
          id: 'other-1',
          type: 'other',
          data: '{}',
        );

        final deleted = await db.clearAllCache();

        expect(deleted, 3);
        expect(await db.getCachedDataByType('activity'), isEmpty);
        expect(await db.getCachedDataByType('category'), isEmpty);
        expect(await db.getCachedDataByType('other'), isEmpty);
      });

      test('returns 0 when cache is already empty', () async {
        final deleted = await db.clearAllCache();

        expect(deleted, 0);
      });
    });
  });
}
