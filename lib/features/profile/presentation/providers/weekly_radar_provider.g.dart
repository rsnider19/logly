// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_radar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Independent time period selector for radar chart (separate from SummaryCard).

@ProviderFor(SelectedRadarTimePeriodStateNotifier)
final selectedRadarTimePeriodStateProvider =
    SelectedRadarTimePeriodStateNotifierProvider._();

/// Independent time period selector for radar chart (separate from SummaryCard).
final class SelectedRadarTimePeriodStateNotifierProvider
    extends
        $NotifierProvider<SelectedRadarTimePeriodStateNotifier, TimePeriod> {
  /// Independent time period selector for radar chart (separate from SummaryCard).
  SelectedRadarTimePeriodStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRadarTimePeriodStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$selectedRadarTimePeriodStateNotifierHash();

  @$internal
  @override
  SelectedRadarTimePeriodStateNotifier create() =>
      SelectedRadarTimePeriodStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimePeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimePeriod>(value),
    );
  }
}

String _$selectedRadarTimePeriodStateNotifierHash() =>
    r'31e53ac3c11f6fec50ea50b8a064603c1a0f1181';

/// Independent time period selector for radar chart (separate from SummaryCard).

abstract class _$SelectedRadarTimePeriodStateNotifier
    extends $Notifier<TimePeriod> {
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

/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// filters by the radar's selected time period.

@ProviderFor(weeklyRadarData)
final weeklyRadarDataProvider = WeeklyRadarDataProvider._();

/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// filters by the radar's selected time period.

final class WeeklyRadarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeeklyCategoryData>>,
          List<WeeklyCategoryData>,
          FutureOr<List<WeeklyCategoryData>>
        >
    with
        $FutureModifier<List<WeeklyCategoryData>>,
        $FutureProvider<List<WeeklyCategoryData>> {
  /// Provides weekly radar data aggregated by day of week and category.
  ///
  /// Derives from the single source [activityCountsByDateProvider] and
  /// filters by the radar's selected time period.
  WeeklyRadarDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyRadarDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyRadarDataHash();

  @$internal
  @override
  $FutureProviderElement<List<WeeklyCategoryData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyCategoryData>> create(Ref ref) {
    return weeklyRadarData(ref);
  }
}

String _$weeklyRadarDataHash() => r'f47f173a0b5f6e8d551cc5fdab7e3970e2e84537';

/// Provides filtered weekly radar data based on selected category filters.
///
/// Reuses the same category filter state as the monthly chart.

@ProviderFor(filteredWeeklyRadarData)
final filteredWeeklyRadarDataProvider = FilteredWeeklyRadarDataProvider._();

/// Provides filtered weekly radar data based on selected category filters.
///
/// Reuses the same category filter state as the monthly chart.

final class FilteredWeeklyRadarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeeklyCategoryData>>,
          List<WeeklyCategoryData>,
          FutureOr<List<WeeklyCategoryData>>
        >
    with
        $FutureModifier<List<WeeklyCategoryData>>,
        $FutureProvider<List<WeeklyCategoryData>> {
  /// Provides filtered weekly radar data based on selected category filters.
  ///
  /// Reuses the same category filter state as the monthly chart.
  FilteredWeeklyRadarDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredWeeklyRadarDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredWeeklyRadarDataHash();

  @$internal
  @override
  $FutureProviderElement<List<WeeklyCategoryData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyCategoryData>> create(Ref ref) {
    return filteredWeeklyRadarData(ref);
  }
}

String _$filteredWeeklyRadarDataHash() =>
    r'afd88e792932d77067fe441f264df8ac138ae241';

/// Provides normalized radar data (0-100%) per category.
///
/// Returns a map: categoryId -> [7 values for Mon-Sun normalized to 0-100].
/// Normalization is based on the day with highest total activity across all categories.

@ProviderFor(normalizedRadarData)
final normalizedRadarDataProvider = NormalizedRadarDataProvider._();

/// Provides normalized radar data (0-100%) per category.
///
/// Returns a map: categoryId -> [7 values for Mon-Sun normalized to 0-100].
/// Normalization is based on the day with highest total activity across all categories.

final class NormalizedRadarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<double>>>,
          Map<String, List<double>>,
          FutureOr<Map<String, List<double>>>
        >
    with
        $FutureModifier<Map<String, List<double>>>,
        $FutureProvider<Map<String, List<double>>> {
  /// Provides normalized radar data (0-100%) per category.
  ///
  /// Returns a map: categoryId -> [7 values for Mon-Sun normalized to 0-100].
  /// Normalization is based on the day with highest total activity across all categories.
  NormalizedRadarDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'normalizedRadarDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$normalizedRadarDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, List<double>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, List<double>>> create(Ref ref) {
    return normalizedRadarData(ref);
  }
}

String _$normalizedRadarDataHash() =>
    r'81dabe7ddc9a6669f4f696b16f1fc55a87a4d9de';
