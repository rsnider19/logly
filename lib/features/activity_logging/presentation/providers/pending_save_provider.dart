import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logly/core/providers/scaffold_messenger_provider.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/update_user_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/home/presentation/providers/daily_activities_provider.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/contribution_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/features/profile/presentation/providers/summary_provider.dart';
import 'package:logly/features/profile/presentation/providers/weekly_radar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'pending_save_provider.g.dart';

/// Holds the data needed to perform an optimistic save in the background.
@immutable
class PendingSaveRequest {
  const PendingSaveRequest({
    required this.activity,
    required this.createUserActivity,
    required this.userId,
    this.selectedSubActivities = const [],
  });

  final Activity activity;
  final CreateUserActivity createUserActivity;
  final String userId;
  final List<SubActivity> selectedSubActivities;
}

/// Holds the data needed to perform an optimistic update in the background.
@immutable
class PendingUpdateRequest {
  const PendingUpdateRequest({
    required this.updateUserActivity,
    required this.originalEntry,
    required this.optimisticEntry,
  });

  final UpdateUserActivity updateUserActivity;
  final UserActivity originalEntry;
  final UserActivity optimisticEntry;
}

/// Orchestrates optimistic background saving for single-day activity creation.
@Riverpod(keepAlive: true)
class PendingSaveStateNotifier extends _$PendingSaveStateNotifier {
  static const _uuid = Uuid();

  @override
  void build() {
    // No state needed; this notifier is purely for side effects.
  }

  /// Adds an optimistic entry to the home screen and fires the real save
  /// in the background.
  void submitOptimistic(PendingSaveRequest request) {
    final tempId = 'optimistic_${_uuid.v4()}';

    // Build the placeholder UserActivity
    final optimisticEntry = UserActivity(
      userActivityId: tempId,
      userId: request.userId,
      activityId: request.activity.activityId,
      activityTimestamp: request.createUserActivity.activityTimestamp,
      createdAt: DateTime.now(),
      comments: request.createUserActivity.comments,
      activityNameOverride: request.createUserActivity.activityNameOverride,
      activity: request.activity,
      subActivity: request.selectedSubActivities,
    );

    // Optimistically add to home screen
    ref.read(dailyActivitiesStateProvider.notifier).addOptimisticEntry(optimisticEntry);

    // Fire background save (intentionally not awaited)
    unawaited(_performSave(request, tempId));
  }

  Future<void> _performSave(PendingSaveRequest request, String tempId) async {
    try {
      final service = ref.read(activityLoggingServiceProvider);
      await service.logActivity(request.createUserActivity);

      // Refresh all activity providers with the real data
      await _refreshActivityProviders();
    } catch (e) {
      // Remove the optimistic entry on failure
      ref.read(dailyActivitiesStateProvider.notifier).removeOptimisticEntry(tempId);

      // Show error snackbar with retry
      final messengerKey = ref.read(scaffoldMessengerKeyProviderProvider);
      final messengerState = messengerKey.currentState;
      if (messengerState != null) {
        messengerState.showSnackBar(
          SnackBar(
            content: const Text('Failed to save activity'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => submitOptimistic(request),
            ),
          ),
        );
      }
    }
  }

  /// Replaces an existing entry with an optimistic version and fires the real
  /// update in the background.
  void submitOptimisticUpdate(PendingUpdateRequest request) {
    final tempId = 'optimistic_${request.originalEntry.userActivityId}';

    // Build the optimistic entry with a temp ID
    final optimisticEntry = request.optimisticEntry.copyWith(userActivityId: tempId);

    // Replace the original entry on the home screen
    ref
        .read(dailyActivitiesStateProvider.notifier)
        .replaceWithOptimisticEntry(
          request.originalEntry.userActivityId,
          optimisticEntry,
        );

    // Fire background update (intentionally not awaited)
    unawaited(_performUpdate(request, tempId));
  }

  Future<void> _performUpdate(PendingUpdateRequest request, String tempId) async {
    try {
      final service = ref.read(activityLoggingServiceProvider);
      await service.updateActivity(request.updateUserActivity);

      // Refresh all activity providers with the real data
      await _refreshActivityProviders();
    } catch (e) {
      // Revert to the original entry on failure
      ref
          .read(dailyActivitiesStateProvider.notifier)
          .revertOptimisticUpdate(
            tempId,
            request.originalEntry,
          );

      // Show error snackbar with retry
      final messengerKey = ref.read(scaffoldMessengerKeyProviderProvider);
      final messengerState = messengerKey.currentState;
      if (messengerState != null) {
        messengerState.showSnackBar(
          SnackBar(
            content: const Text('Failed to update activity'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => submitOptimisticUpdate(request),
            ),
          ),
        );
      }
    }
  }

  /// Mirrors `_refreshActivityProviders` from `activity_form_provider.dart`.
  Future<void> _refreshActivityProviders() async {
    await Future.wait([
      ref.refresh(dailyActivitiesStateProvider.future),
      ref.refresh(userStatsProvider.future),
      ref.refresh(periodCategoryCountsProvider.future),
      ref.refresh(dailyCategoryCountsProvider.future),
      ref.refresh(dowCategoryCountsProvider.future),
    ]);

    await Future.wait([
      ref.refresh(categorySummaryProvider.future),
      ref.refresh(contributionDataProvider.future),
      ref.refresh(normalizedRadarDataProvider.future),
      ref.refresh(filteredMonthlyChartDataProvider.future),
    ]);
  }
}
