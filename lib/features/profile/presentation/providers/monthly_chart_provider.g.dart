// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for selected category filters on the monthly chart.
///
/// An empty set means "all categories selected" (default state).
/// When user deselects a category, we populate with all except that one.

@ProviderFor(SelectedCategoryFiltersStateNotifier)
final selectedCategoryFiltersStateProvider =
    SelectedCategoryFiltersStateNotifierProvider._();

/// Notifier for selected category filters on the monthly chart.
///
/// An empty set means "all categories selected" (default state).
/// When user deselects a category, we populate with all except that one.
final class SelectedCategoryFiltersStateNotifierProvider
    extends
        $NotifierProvider<SelectedCategoryFiltersStateNotifier, Set<String>> {
  /// Notifier for selected category filters on the monthly chart.
  ///
  /// An empty set means "all categories selected" (default state).
  /// When user deselects a category, we populate with all except that one.
  SelectedCategoryFiltersStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryFiltersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$selectedCategoryFiltersStateNotifierHash();

  @$internal
  @override
  SelectedCategoryFiltersStateNotifier create() =>
      SelectedCategoryFiltersStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$selectedCategoryFiltersStateNotifierHash() =>
    r'708634fc0aaf72c1ee0b68cb21504df309a488ee';

/// Notifier for selected category filters on the monthly chart.
///
/// An empty set means "all categories selected" (default state).
/// When user deselects a category, we populate with all except that one.

abstract class _$SelectedCategoryFiltersStateNotifier
    extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
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

@ProviderFor(effectiveSelectedFilters)
final effectiveSelectedFiltersProvider = EffectiveSelectedFiltersProvider._();

/// Provides the effective set of selected category IDs.
///
/// When raw state is empty, returns all category IDs (all selected by default).
/// Otherwise returns the raw selection.

final class EffectiveSelectedFiltersProvider
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
  EffectiveSelectedFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveSelectedFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveSelectedFiltersHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return effectiveSelectedFilters(ref);
  }
}

String _$effectiveSelectedFiltersHash() =>
    r'6b0fe4947b992276a0d853c212d26aedf44de3f0';

/// Provides monthly chart data for all categories.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by month + category for the last 12 months.

@ProviderFor(monthlyChartData)
final monthlyChartDataProvider = MonthlyChartDataProvider._();

/// Provides monthly chart data for all categories.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by month + category for the last 12 months.

final class MonthlyChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlyCategoryData>>,
          List<MonthlyCategoryData>,
          FutureOr<List<MonthlyCategoryData>>
        >
    with
        $FutureModifier<List<MonthlyCategoryData>>,
        $FutureProvider<List<MonthlyCategoryData>> {
  /// Provides monthly chart data for all categories.
  ///
  /// Derives from the single source [activityCountsByDateProvider] and
  /// aggregates by month + category for the last 12 months.
  MonthlyChartDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyChartDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyChartDataHash();

  @$internal
  @override
  $FutureProviderElement<List<MonthlyCategoryData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlyCategoryData>> create(Ref ref) {
    return monthlyChartData(ref);
  }
}

String _$monthlyChartDataHash() => r'b0a547e18af712cb11a240d2914f6aae1d0b2441';

/// Provides filtered monthly chart data based on selected category filters.

@ProviderFor(filteredMonthlyChartData)
final filteredMonthlyChartDataProvider = FilteredMonthlyChartDataProvider._();

/// Provides filtered monthly chart data based on selected category filters.

final class FilteredMonthlyChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlyCategoryData>>,
          List<MonthlyCategoryData>,
          FutureOr<List<MonthlyCategoryData>>
        >
    with
        $FutureModifier<List<MonthlyCategoryData>>,
        $FutureProvider<List<MonthlyCategoryData>> {
  /// Provides filtered monthly chart data based on selected category filters.
  FilteredMonthlyChartDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMonthlyChartDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMonthlyChartDataHash();

  @$internal
  @override
  $FutureProviderElement<List<MonthlyCategoryData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlyCategoryData>> create(Ref ref) {
    return filteredMonthlyChartData(ref);
  }
}

String _$filteredMonthlyChartDataHash() =>
    r'5f1d1eb541353259c23517ae8651186123c65ed1';
