// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global filter state notifier for the profile screen.
///
/// Manages time period and category selection that affects
/// Summary, Contribution, Weekly Radar, and Monthly Chart sections.
/// StreakCard is intentionally unaffected.

@ProviderFor(ProfileFilterStateNotifier)
final profileFilterStateProvider = ProfileFilterStateNotifierProvider._();

/// Global filter state notifier for the profile screen.
///
/// Manages time period and category selection that affects
/// Summary, Contribution, Weekly Radar, and Monthly Chart sections.
/// StreakCard is intentionally unaffected.
final class ProfileFilterStateNotifierProvider
    extends $NotifierProvider<ProfileFilterStateNotifier, ProfileFilterState> {
  /// Global filter state notifier for the profile screen.
  ///
  /// Manages time period and category selection that affects
  /// Summary, Contribution, Weekly Radar, and Monthly Chart sections.
  /// StreakCard is intentionally unaffected.
  ProfileFilterStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileFilterStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileFilterStateNotifierHash();

  @$internal
  @override
  ProfileFilterStateNotifier create() => ProfileFilterStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileFilterState>(value),
    );
  }
}

String _$profileFilterStateNotifierHash() =>
    r'e3bf4b45ef91f7d9cc4b324211fe991328140325';

/// Global filter state notifier for the profile screen.
///
/// Manages time period and category selection that affects
/// Summary, Contribution, Weekly Radar, and Monthly Chart sections.
/// StreakCard is intentionally unaffected.

abstract class _$ProfileFilterStateNotifier
    extends $Notifier<ProfileFilterState> {
  ProfileFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ProfileFilterState, ProfileFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ProfileFilterState, ProfileFilterState>,
              ProfileFilterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provides the effective set of selected category IDs.
///
/// When raw state is empty, returns all category IDs (all selected by default).
/// Otherwise returns the raw selection.

@ProviderFor(effectiveGlobalCategoryFilters)
final effectiveGlobalCategoryFiltersProvider =
    EffectiveGlobalCategoryFiltersProvider._();

/// Provides the effective set of selected category IDs.
///
/// When raw state is empty, returns all category IDs (all selected by default).
/// Otherwise returns the raw selection.

final class EffectiveGlobalCategoryFiltersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Provides the effective set of selected category IDs.
  ///
  /// When raw state is empty, returns all category IDs (all selected by default).
  /// Otherwise returns the raw selection.
  EffectiveGlobalCategoryFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveGlobalCategoryFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveGlobalCategoryFiltersHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return effectiveGlobalCategoryFilters(ref);
  }
}

String _$effectiveGlobalCategoryFiltersHash() =>
    r'f2e2e4e13f1a70fd37fa300cd90155b585db6a58';

/// Convenience provider for the global time period selection.

@ProviderFor(globalTimePeriod)
final globalTimePeriodProvider = GlobalTimePeriodProvider._();

/// Convenience provider for the global time period selection.

final class GlobalTimePeriodProvider
    extends $FunctionalProvider<TimePeriod, TimePeriod, TimePeriod>
    with $Provider<TimePeriod> {
  /// Convenience provider for the global time period selection.
  GlobalTimePeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalTimePeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalTimePeriodHash();

  @$internal
  @override
  $ProviderElement<TimePeriod> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TimePeriod create(Ref ref) {
    return globalTimePeriod(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimePeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimePeriod>(value),
    );
  }
}

String _$globalTimePeriodHash() => r'da1c434ffe2173250a913a344cc3321e6c6a0ee6';

/// Provides activity categories sorted by filter toggle frequency.
///
/// Reads frequency data from SharedPreferences and sorts categories by
/// descending frequency. Categories with no recorded taps fall back to
/// their default [ActivityCategory.sortOrder].
///
/// Kept alive because categories are preloaded before the profile screen.

@ProviderFor(frequencySortedCategories)
final frequencySortedCategoriesProvider = FrequencySortedCategoriesProvider._();

/// Provides activity categories sorted by filter toggle frequency.
///
/// Reads frequency data from SharedPreferences and sorts categories by
/// descending frequency. Categories with no recorded taps fall back to
/// their default [ActivityCategory.sortOrder].
///
/// Kept alive because categories are preloaded before the profile screen.

final class FrequencySortedCategoriesProvider
    extends
        $FunctionalProvider<
          List<ActivityCategory>,
          List<ActivityCategory>,
          List<ActivityCategory>
        >
    with $Provider<List<ActivityCategory>> {
  /// Provides activity categories sorted by filter toggle frequency.
  ///
  /// Reads frequency data from SharedPreferences and sorts categories by
  /// descending frequency. Categories with no recorded taps fall back to
  /// their default [ActivityCategory.sortOrder].
  ///
  /// Kept alive because categories are preloaded before the profile screen.
  FrequencySortedCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frequencySortedCategoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frequencySortedCategoriesHash();

  @$internal
  @override
  $ProviderElement<List<ActivityCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ActivityCategory> create(Ref ref) {
    return frequencySortedCategories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ActivityCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ActivityCategory>>(value),
    );
  }
}

String _$frequencySortedCategoriesHash() =>
    r'1a0a9a321912b6d1636a4e36b6e76dccfaeba3fb';
