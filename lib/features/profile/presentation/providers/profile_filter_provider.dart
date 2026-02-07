import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/data/category_filter_frequency_repository.dart';
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
  /// When "All" is active (empty set), tapping a category selects only that
  /// category. When individual categories are selected, tapping toggles that
  /// category. If the last category is deselected, auto-resets to "All"
  /// (empty set).
  void toggleCategory(String categoryId) {
    final current = state.selectedCategoryIds;
    if (current.isEmpty) {
      // "All" is active — select only this category
      state = state.copyWith(selectedCategoryIds: {categoryId});
    } else if (current.contains(categoryId)) {
      // Deselect this category; empty set means auto-reselect "All"
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

/// Provides activity categories sorted by filter toggle frequency.
///
/// Reads frequency data from SharedPreferences and sorts categories by
/// descending frequency. Categories with no recorded taps fall back to
/// their default [ActivityCategory.sortOrder].
///
/// Auto-dispose ensures sort order is recalculated each time the profile
/// screen is rebuilt (e.g., navigating away and back).
@riverpod
Future<List<ActivityCategory>> frequencySortedCategories(Ref ref) async {
  final categories = await ref.watch(activityCategoriesProvider.future);
  final freqRepo = ref.watch(categoryFilterFrequencyRepositoryProvider);
  final frequencies = freqRepo.getFrequencies();

  return [...categories]..sort((a, b) {
    final freqA = frequencies[a.activityCategoryId] ?? 0;
    final freqB = frequencies[b.activityCategoryId] ?? 0;
    if (freqA != freqB) return freqB.compareTo(freqA);
    return a.sortOrder.compareTo(b.sortOrder);
  });
}
