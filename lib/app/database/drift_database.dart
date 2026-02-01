import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:logly/app/database/tables/cached_data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

/// The local SQLite database for offline caching.
@DriftDatabase(tables: [CachedData])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for testing with a custom query executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migration logic here as schema evolves
      },
    );
  }

  // MARK: - CachedData operations

  /// Inserts or updates cached data.
  Future<void> upsertCachedData({
    required String id,
    required String type,
    required String data,
    DateTime? expiresAt,
  }) async {
    await into(cachedData).insertOnConflictUpdate(
      CachedDataCompanion.insert(
        id: id,
        type: type,
        data: data,
        expiresAt: Value(expiresAt),
      ),
    );
  }

  /// Gets cached data by id and type.
  Future<CachedDataData?> getCachedData(String id, String type) async {
    return (select(cachedData)..where((t) => t.id.equals(id) & t.type.equals(type))).getSingleOrNull();
  }

  /// Gets all cached data of a specific type.
  Future<List<CachedDataData>> getCachedDataByType(String type) async {
    return (select(cachedData)..where((t) => t.type.equals(type))).get();
  }

  /// Deletes cached data by id and type.
  Future<int> deleteCachedData(String id, String type) async {
    return (delete(cachedData)..where((t) => t.id.equals(id) & t.type.equals(type))).go();
  }

  /// Deletes all cached data of a specific type.
  Future<int> deleteCachedDataByType(String type) async {
    return (delete(cachedData)..where((t) => t.type.equals(type))).go();
  }

  /// Deletes all expired cached data.
  Future<int> deleteExpiredCache() async {
    return (delete(cachedData)..where((t) => t.expiresAt.isSmallerOrEqualValue(DateTime.now()))).go();
  }

  /// Clears all cached data.
  Future<int> clearAllCache() async {
    return delete(cachedData).go();
  }
}

/// Opens the database connection.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'logly.sqlite'));

    if (kDebugMode) {
      debugPrint('Database path: ${file.path}');
    }

    return NativeDatabase.createInBackground(file);
  });
}
