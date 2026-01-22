import 'package:drift/drift.dart';

/// Placeholder table for caching arbitrary data.
///
/// This is a generic cache table that can be used by features to store
/// offline data. Features may also define their own specific tables.
class CachedData extends Table {
  /// Unique identifier for the cached item.
  TextColumn get id => text()();

  /// The type/category of cached data (e.g., 'activity', 'category').
  TextColumn get type => text()();

  /// The cached data as JSON.
  TextColumn get data => text()();

  /// When the data was cached.
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  /// When the cached data expires (null means never).
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id, type};
}
