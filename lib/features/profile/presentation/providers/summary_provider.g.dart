// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for the selected time period filter.

@ProviderFor(SelectedTimePeriodStateNotifier)
final selectedTimePeriodStateProvider =
    SelectedTimePeriodStateNotifierProvider._();

/// Notifier for the selected time period filter.
final class SelectedTimePeriodStateNotifierProvider
    extends $NotifierProvider<SelectedTimePeriodStateNotifier, TimePeriod> {
  /// Notifier for the selected time period filter.
  SelectedTimePeriodStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTimePeriodStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTimePeriodStateNotifierHash();

  @$internal
  @override
  SelectedTimePeriodStateNotifier create() => SelectedTimePeriodStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimePeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimePeriod>(value),
    );
  }
}

String _$selectedTimePeriodStateNotifierHash() =>
    r'8b38943f187adba7e7e5c408d6bcaaf5293377f5';

/// Notifier for the selected time period filter.

abstract class _$SelectedTimePeriodStateNotifier extends $Notifier<TimePeriod> {
  TimePeriod build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimePeriod, TimePeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimePeriod, TimePeriod>,
              TimePeriod,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

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

/// Provides category summary data for the selected time period.
/// Uses cached data from allPeriodSummaries.

@ProviderFor(categorySummary)
final categorySummaryProvider = CategorySummaryProvider._();

/// Provides category summary data for the selected time period.
/// Uses cached data from allPeriodSummaries.

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
  /// Provides category summary data for the selected time period.
  /// Uses cached data from allPeriodSummaries.
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

String _$categorySummaryHash() => r'79799c34c256abe507c7767367f07837f474e06f';
