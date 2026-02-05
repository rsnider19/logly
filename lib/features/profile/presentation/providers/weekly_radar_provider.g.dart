// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_radar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from [dowCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Extracts the appropriate column and converts
/// Postgres dow (0=Sun) to ISO 8601 (1=Mon, 7=Sun).

@ProviderFor(weeklyRadarData)
final weeklyRadarDataProvider = WeeklyRadarDataProvider._();

/// Provides weekly radar data aggregated by day of week and category.
///
/// Derives from [dowCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Extracts the appropriate column and converts
/// Postgres dow (0=Sun) to ISO 8601 (1=Mon, 7=Sun).

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
  /// Derives from [dowCategoryCountsProvider] which contains pre-aggregated
  /// counts for all time periods. Extracts the appropriate column and converts
  /// Postgres dow (0=Sun) to ISO 8601 (1=Mon, 7=Sun).
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

String _$weeklyRadarDataHash() => r'0fc6a2d103f02faac220d107b47ebe4701c4b457';

/// Provides filtered weekly radar data based on global category filters.

@ProviderFor(filteredWeeklyRadarData)
final filteredWeeklyRadarDataProvider = FilteredWeeklyRadarDataProvider._();

/// Provides filtered weekly radar data based on global category filters.

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
  /// Provides filtered weekly radar data based on global category filters.
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
    r'04a628248ca4aaf492e37d7458ed48d9411022db';

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
