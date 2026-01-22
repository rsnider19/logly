import 'dart:async';

import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_provider.g.dart';

/// Provides all favorite activities for the current user.
@riverpod
Future<List<FavoriteActivity>> favoriteActivities(Ref ref) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getFavorites();
}

/// Provides the set of favorited activity IDs for efficient lookup.
@riverpod
Future<Set<String>> favoriteActivityIds(Ref ref) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.getFavoriteIds();
}

/// Provides whether a specific activity is favorited.
@riverpod
Future<bool> isActivityFavorited(Ref ref, String activityId) async {
  final service = ref.watch(activityLoggingServiceProvider);
  return service.isFavorite(activityId);
}

/// State notifier for managing favorite actions with optimistic updates.
@riverpod
class FavoriteStateNotifier extends _$FavoriteStateNotifier {
  @override
  AsyncValue<Set<String>> build() {
    // Load initial favorites
    unawaited(_loadFavorites());
    return const AsyncValue.loading();
  }

  Future<void> _loadFavorites() async {
    try {
      final service = ref.read(activityLoggingServiceProvider);
      final ids = await service.getFavoriteIds();
      state = AsyncValue.data(ids);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggles the favorite status with optimistic update.
  Future<void> toggle(String activityId) async {
    final currentState = state;
    if (currentState is! AsyncData<Set<String>>) return;

    final currentIds = currentState.value;
    final isFavorited = currentIds.contains(activityId);

    // Optimistic update
    if (isFavorited) {
      state = AsyncValue.data({...currentIds}..remove(activityId));
    } else {
      state = AsyncValue.data({...currentIds, activityId});
    }

    try {
      final service = ref.read(activityLoggingServiceProvider);
      await service.toggleFavorite(activityId);

      // Invalidate related providers
      ref
        ..invalidate(favoriteActivitiesProvider)
        ..invalidate(favoriteActivityIdsProvider);
    } catch (e) {
      // Revert on failure
      state = currentState;
      rethrow;
    }
  }

  /// Refreshes the favorites list from the server.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadFavorites();
  }

  /// Checks if an activity is favorited (synchronous check from current state).
  bool isFavorited(String activityId) {
    final currentState = state;
    if (currentState is AsyncData<Set<String>>) {
      return currentState.value.contains(activityId);
    }
    return false;
  }
}
