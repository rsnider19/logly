import 'package:logly/app/database/drift_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Provides the app database instance for local storage operations.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();
