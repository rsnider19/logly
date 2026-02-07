import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/health_integration/application/health_sync_service.dart';
import 'package:logly/features/health_integration/domain/health_exception.dart';
import 'package:logly/features/health_integration/domain/sync_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_sync_provider.freezed.dart';
part 'health_sync_provider.g.dart';

/// State for health sync operations.
@freezed
abstract class HealthSyncState with _$HealthSyncState {
  const factory HealthSyncState({
    /// Whether a sync is currently in progress.
    @Default(false) bool isSyncing,

    /// Result of the last sync operation, if any.
    SyncResult? lastSyncResult,

    /// The last successful sync date.
    DateTime? lastSyncDate,

    /// Error message from the last failed sync, if any.
    String? errorMessage,

    /// Current month being synced (1-indexed).
    @Default(0) int currentMonth,

    /// Total number of months to sync.
    @Default(0) int totalMonths,
  }) = _HealthSyncState;

  const HealthSyncState._();

  /// Whether to show progress (more than 1 month to sync).
  bool get showProgress => totalMonths > 1;

  /// Progress value between 0.0 and 1.0.
  double get progress => totalMonths > 0 ? currentMonth / totalMonths : 0.0;
}

/// Notifier for managing health sync state.
@Riverpod(keepAlive: true)
class HealthSyncStateNotifier extends _$HealthSyncStateNotifier {
  @override
  HealthSyncState build() {
    // Load last sync date on initialization
    Future.microtask(_loadLastSyncDate);
    return const HealthSyncState();
  }

  Future<void> _loadLastSyncDate() async {
    try {
      final service = ref.read(healthSyncServiceProvider);
      final lastSyncDate = await service.getLastSyncDate();
      state = state.copyWith(lastSyncDate: lastSyncDate);
    } catch (e) {
      // Silently ignore - this is just initialization
    }
  }

  /// Triggers a manual sync of health data.
  ///
  /// [fromDate] is required for first-time sync (when lastSyncDate is null).
  /// For subsequent syncs, it's ignored as the service uses the stored last sync date.
  Future<void> sync({DateTime? fromDate}) async {
    if (state.isSyncing) return;

    final stopwatch = Stopwatch()..start();
    final platform = Platform.isIOS ? 'apple_health' : 'google_fit';
    ref.read(analyticsServiceProvider).trackHealthSyncStarted(platform: platform);

    state = state.copyWith(
      isSyncing: true,
      errorMessage: null,
      lastSyncResult: null,
      currentMonth: 0,
      totalMonths: 0,
    );

    try {
      final service = ref.read(healthSyncServiceProvider);
      final result = await service.syncWorkouts(
        fromDate: fromDate,
        onProgress: (currentMonth, totalMonths) {
          state = state.copyWith(
            currentMonth: currentMonth,
            totalMonths: totalMonths,
          );
        },
      );

      state = state.copyWith(
        isSyncing: false,
        lastSyncResult: result,
        lastSyncDate: DateTime.now(),
        currentMonth: 0,
        totalMonths: 0,
      );
      ref.read(analyticsServiceProvider).trackHealthSyncCompleted(
        platform: platform,
        activitiesSyncedCount: result.created,
        durationSeconds: stopwatch.elapsed.inSeconds,
      );
    } on HealthException catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: e.message,
        currentMonth: 0,
        totalMonths: 0,
      );
      ref.read(analyticsServiceProvider).trackHealthSyncFailed(
        platform: platform,
        errorType: e.runtimeType.toString(),
      );
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: 'An unexpected error occurred. Please try again.',
        currentMonth: 0,
        totalMonths: 0,
      );
      ref.read(analyticsServiceProvider).trackHealthSyncFailed(
        platform: platform,
        errorType: e.runtimeType.toString(),
      );
    }
  }

  /// Whether this is the first sync (no previous sync date).
  bool get isFirstSync => state.lastSyncDate == null;

  /// Clears the last sync result and error.
  void clearResult() {
    state = state.copyWith(
      lastSyncResult: null,
      errorMessage: null,
    );
  }
}
