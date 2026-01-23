import 'dart:async';

import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_favorites_provider.g.dart';

/// State notifier for managing selected favorites during onboarding.
@riverpod
class OnboardingFavoritesStateNotifier extends _$OnboardingFavoritesStateNotifier {
  @override
  FutureOr<Set<String>> build() async {
    // Load existing favorites from the server
    final service = ref.read(onboardingServiceProvider);
    final existingIds = await service.getExistingFavoriteIds();
    return existingIds.toSet();
  }

  /// Toggles the selection state of an activity.
  void toggle(String activityId) {
    final current = state;
    if (current is! AsyncData<Set<String>>) return;

    final ids = {...current.value};
    if (ids.contains(activityId)) {
      ids.remove(activityId);
    } else {
      ids.add(activityId);
    }
    state = AsyncValue.data(ids);
  }

  /// Checks if an activity is currently selected.
  bool isSelected(String activityId) {
    final current = state;
    if (current is! AsyncData<Set<String>>) return false;
    return current.value.contains(activityId);
  }

  /// Gets the current selection count.
  int get selectionCount {
    final current = state;
    if (current is! AsyncData<Set<String>>) return 0;
    return current.value.length;
  }

  /// Saves the selected favorites to the server.
  Future<void> saveFavorites() async {
    final current = state;
    if (current is! AsyncData<Set<String>>) return;

    final service = ref.read(onboardingServiceProvider);
    await service.saveFavorites(current.value.toList());
  }
}
