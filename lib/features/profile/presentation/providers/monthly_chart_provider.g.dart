// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for selected category filters on the monthly chart.

@ProviderFor(SelectedCategoryFiltersStateNotifier)
final selectedCategoryFiltersStateProvider =
    SelectedCategoryFiltersStateNotifierProvider._();

/// Notifier for selected category filters on the monthly chart.
final class SelectedCategoryFiltersStateNotifierProvider
    extends
        $NotifierProvider<SelectedCategoryFiltersStateNotifier, Set<String>> {
  /// Notifier for selected category filters on the monthly chart.
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
    r'ea8e4ca27a06bf6a11a637ec731f98e927a84489';

/// Notifier for selected category filters on the monthly chart.

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

/// Provides monthly chart data for all categories.

@ProviderFor(monthlyChartData)
final monthlyChartDataProvider = MonthlyChartDataProvider._();

/// Provides monthly chart data for all categories.

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

String _$monthlyChartDataHash() => r'687540b3f695dc954a49d7eb6dd4cd9185ba8cda';

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
    r'204e82fb71fcc7696fc14805ae6535c99cfe173d';
