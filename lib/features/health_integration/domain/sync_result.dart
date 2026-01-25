import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_result.freezed.dart';
part 'sync_result.g.dart';

/// Result of a health sync operation.
@freezed
abstract class SyncResult with _$SyncResult {
  const factory SyncResult({
    /// Number of health records processed.
    @Default(0) int created,
  }) = _SyncResult;

  const SyncResult._();

  factory SyncResult.fromJson(Map<String, dynamic> json) => _$SyncResultFromJson(json);

  /// Total number of records processed.
  int get total => created;

  /// Whether any records were synced.
  bool get hasNewWorkouts => created > 0;

  /// Human-readable summary of the sync result.
  String get summary {
    if (created == 0) {
      return 'No new workouts to sync';
    }
    return '$created workouts synced';
  }
}
