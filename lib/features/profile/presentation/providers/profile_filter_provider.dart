import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_filter_provider.g.dart';

/// State for global profile filters (time period + category selection).
class ProfileFilterState {
  const ProfileFilterState({
    this.timePeriod = TimePeriod.all,
    this.selectedCategoryIds = const {},
  });

  /// The currently selected time period.
  final TimePeriod timePeriod;

  /// Selected category IDs. Empty set means "all selected".
  final Set<String> selectedCategoryIds;

  ProfileFilterState copyWith({
    TimePeriod? timePeriod,
    Set<String>? selectedCategoryIds,
  }) {
    return ProfileFilterState(
      timePeriod: timePeriod ?? this.timePeriod,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
    );
  }
}

/// Global filter state notifier for the profile screen.
///
/// Manages time period and category selection that affects
/// Summary, Contribution, Weekly Radar, and Monthly Chart sections.
/// StreakCard is intentionally unaffected.
@Riverpod(keepAlive: true)
class ProfileFilterStateNotifier extends _$ProfileFilterStateNotifier {
  @override
  ProfileFilterState build() => const ProfileFilterState();

  /// Updates the selected time period.
  void selectTimePeriod(TimePeriod period) {
    state = state.copyWith(timePeriod: period);
  }

  /// Toggles a category filter on/off.
  ///
  /// If state is empty (all selected), first populates with all category IDs
  /// then removes the toggled one.
  void toggleCategory(String categoryId, List<String> allCategoryIds) {
    final current = state.selectedCategoryIds;
    if (current.isEmpty) {
      // Empty means all selected, so toggling means deselecting one
      state = state.copyWith(
        selectedCategoryIds: allCategoryIds.where((id) => id != categoryId).toSet(),
      );
    } else if (current.contains(categoryId)) {
      state = state.copyWith(
        selectedCategoryIds: {...current}..remove(categoryId),
      );
    } else {
      state = state.copyWith(
        selectedCategoryIds: {...current, categoryId},
      );
    }
  }

  /// Selects all categories (resets to empty set which means all selected).
  void selectAllCategories() {
    state = state.copyWith(selectedCategoryIds: {});
  }
}

/// Provides the effective set of selected category IDs.
///
/// When raw state is empty, returns all category IDs (all selected by default).
/// Otherwise returns the raw selection.
@riverpod
Future<Set<String>> effectiveGlobalCategoryFilters(Ref ref) async {
  final rawFilters = ref.watch(profileFilterStateProvider).selectedCategoryIds;
  final categoriesFuture = ref.watch(activityCategoriesProvider.future);

  if (rawFilters.isEmpty) {
    final categories = await categoriesFuture;
    return categories.map((c) => c.activityCategoryId).toSet();
  }
  return rawFilters;
}

/// Convenience provider for the global time period selection.
@riverpod
TimePeriod globalTimePeriod(Ref ref) {
  return ref.watch(profileFilterStateProvider).timePeriod;
}
