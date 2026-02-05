// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_counts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Period category counts - single source for summary chart.
///
/// All derived providers for summary chart watch this provider.
/// Invalidating this provider refreshes all dependents.

@ProviderFor(periodCategoryCounts)
final periodCategoryCountsProvider = PeriodCategoryCountsProvider._();

/// Period category counts - single source for summary chart.
///
/// All derived providers for summary chart watch this provider.
/// Invalidating this provider refreshes all dependents.

final class PeriodCategoryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PeriodCategoryCounts>>,
          List<PeriodCategoryCounts>,
          FutureOr<List<PeriodCategoryCounts>>
        >
    with
        $FutureModifier<List<PeriodCategoryCounts>>,
        $FutureProvider<List<PeriodCategoryCounts>> {
  /// Period category counts - single source for summary chart.
  ///
  /// All derived providers for summary chart watch this provider.
  /// Invalidating this provider refreshes all dependents.
  PeriodCategoryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'periodCategoryCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$periodCategoryCountsHash();

  @$internal
  @override
  $FutureProviderElement<List<PeriodCategoryCounts>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PeriodCategoryCounts>> create(Ref ref) {
    return periodCategoryCounts(ref);
  }
}

String _$periodCategoryCountsHash() =>
    r'f07e66c92ecde193f89494e15f51f63de2c0edbf';

/// Daily category counts - source for contribution graph and monthly chart.
///
/// Fetches last 365 days of data. Invalidating this provider refreshes
/// both contribution graph and monthly chart.

@ProviderFor(dailyCategoryCounts)
final dailyCategoryCountsProvider = DailyCategoryCountsProvider._();

/// Daily category counts - source for contribution graph and monthly chart.
///
/// Fetches last 365 days of data. Invalidating this provider refreshes
/// both contribution graph and monthly chart.

final class DailyCategoryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DailyCategoryCounts>>,
          List<DailyCategoryCounts>,
          FutureOr<List<DailyCategoryCounts>>
        >
    with
        $FutureModifier<List<DailyCategoryCounts>>,
        $FutureProvider<List<DailyCategoryCounts>> {
  /// Daily category counts - source for contribution graph and monthly chart.
  ///
  /// Fetches last 365 days of data. Invalidating this provider refreshes
  /// both contribution graph and monthly chart.
  DailyCategoryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyCategoryCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyCategoryCountsHash();

  @$internal
  @override
  $FutureProviderElement<List<DailyCategoryCounts>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DailyCategoryCounts>> create(Ref ref) {
    return dailyCategoryCounts(ref);
  }
}

String _$dailyCategoryCountsHash() =>
    r'b6242b7e5a2a6b463064a35d70e7a4dc50cb6d67';

/// Day-of-week category counts - source for radar chart.
///
/// Pre-aggregated by day-of-week with counts for all time periods.

@ProviderFor(dowCategoryCounts)
final dowCategoryCountsProvider = DowCategoryCountsProvider._();

/// Day-of-week category counts - source for radar chart.
///
/// Pre-aggregated by day-of-week with counts for all time periods.

final class DowCategoryCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DowCategoryCounts>>,
          List<DowCategoryCounts>,
          FutureOr<List<DowCategoryCounts>>
        >
    with
        $FutureModifier<List<DowCategoryCounts>>,
        $FutureProvider<List<DowCategoryCounts>> {
  /// Day-of-week category counts - source for radar chart.
  ///
  /// Pre-aggregated by day-of-week with counts for all time periods.
  DowCategoryCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dowCategoryCountsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dowCategoryCountsHash();

  @$internal
  @override
  $FutureProviderElement<List<DowCategoryCounts>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DowCategoryCounts>> create(Ref ref) {
    return dowCategoryCounts(ref);
  }
}

String _$dowCategoryCountsHash() => r'dafa135e6c04e981212cab249fd4fbceac583bfd';
