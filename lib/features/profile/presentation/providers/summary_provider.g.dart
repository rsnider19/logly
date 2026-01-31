// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches and caches category summary data for all time periods.

@ProviderFor(allPeriodSummaries)
final allPeriodSummariesProvider = AllPeriodSummariesProvider._();

/// Fetches and caches category summary data for all time periods.

final class AllPeriodSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AllPeriodSummaries>,
          AllPeriodSummaries,
          FutureOr<AllPeriodSummaries>
        >
    with
        $FutureModifier<AllPeriodSummaries>,
        $FutureProvider<AllPeriodSummaries> {
  /// Fetches and caches category summary data for all time periods.
  AllPeriodSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPeriodSummariesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPeriodSummariesHash();

  @$internal
  @override
  $FutureProviderElement<AllPeriodSummaries> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AllPeriodSummaries> create(Ref ref) {
    return allPeriodSummaries(ref);
  }
}

String _$allPeriodSummariesHash() =>
    r'3cb9323f336666de8c37929f4253865ad6212bc2';

/// Provides category summary data for the global time period,
/// filtered by the global category selection.

@ProviderFor(categorySummary)
final categorySummaryProvider = CategorySummaryProvider._();

/// Provides category summary data for the global time period,
/// filtered by the global category selection.

final class CategorySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategorySummary>>,
          List<CategorySummary>,
          FutureOr<List<CategorySummary>>
        >
    with
        $FutureModifier<List<CategorySummary>>,
        $FutureProvider<List<CategorySummary>> {
  /// Provides category summary data for the global time period,
  /// filtered by the global category selection.
  CategorySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorySummaryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorySummaryHash();

  @$internal
  @override
  $FutureProviderElement<List<CategorySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategorySummary>> create(Ref ref) {
    return categorySummary(ref);
  }
}

String _$categorySummaryHash() => r'eea8b996fef3e666885fa926ed595dab205a0fe3';
