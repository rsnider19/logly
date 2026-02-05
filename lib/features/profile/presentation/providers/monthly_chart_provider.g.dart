// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_chart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides chart data aggregated by the global time period.
///
/// - `1W`: 7 day-level entries (last 7 days)
/// - `1M`: 4-5 week-level entries (last 30 days grouped by week-start Monday)
/// - `1Y` / `All`: 12 month-level entries (last 12 months)
///
/// Reuses [MonthlyCategoryData] model — `activityMonth` represents the period start date.

@ProviderFor(monthlyChartData)
final monthlyChartDataProvider = MonthlyChartDataProvider._();

/// Provides chart data aggregated by the global time period.
///
/// - `1W`: 7 day-level entries (last 7 days)
/// - `1M`: 4-5 week-level entries (last 30 days grouped by week-start Monday)
/// - `1Y` / `All`: 12 month-level entries (last 12 months)
///
/// Reuses [MonthlyCategoryData] model — `activityMonth` represents the period start date.

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
  /// Provides chart data aggregated by the global time period.
  ///
  /// - `1W`: 7 day-level entries (last 7 days)
  /// - `1M`: 4-5 week-level entries (last 30 days grouped by week-start Monday)
  /// - `1Y` / `All`: 12 month-level entries (last 12 months)
  ///
  /// Reuses [MonthlyCategoryData] model — `activityMonth` represents the period start date.
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

String _$monthlyChartDataHash() => r'eecbdd0b51bee9aa93344f864c5412f87b7d6f70';

/// Provides filtered chart data based on global category filters.

@ProviderFor(filteredMonthlyChartData)
final filteredMonthlyChartDataProvider = FilteredMonthlyChartDataProvider._();

/// Provides filtered chart data based on global category filters.

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
  /// Provides filtered chart data based on global category filters.
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
    r'0cb7ceac830615a0b6919bd9e488c3306c152747';
