// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides trending activities globally.

@ProviderFor(trendingActivities)
final trendingActivitiesProvider = TrendingActivitiesProvider._();

/// Provides trending activities globally.

final class TrendingActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TrendingActivity>>,
          List<TrendingActivity>,
          FutureOr<List<TrendingActivity>>
        >
    with
        $FutureModifier<List<TrendingActivity>>,
        $FutureProvider<List<TrendingActivity>> {
  /// Provides trending activities globally.
  TrendingActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingActivitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingActivitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<TrendingActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TrendingActivity>> create(Ref ref) {
    return trendingActivities(ref);
  }
}

String _$trendingActivitiesHash() =>
    r'e14aff34a5d33b9aac1470ebc3cbe142af794942';
