// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the trending repository instance.

@ProviderFor(trendingRepository)
final trendingRepositoryProvider = TrendingRepositoryProvider._();

/// Provides the trending repository instance.

final class TrendingRepositoryProvider
    extends
        $FunctionalProvider<
          TrendingRepository,
          TrendingRepository,
          TrendingRepository
        >
    with $Provider<TrendingRepository> {
  /// Provides the trending repository instance.
  TrendingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trendingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trendingRepositoryHash();

  @$internal
  @override
  $ProviderElement<TrendingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrendingRepository create(Ref ref) {
    return trendingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrendingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrendingRepository>(value),
    );
  }
}

String _$trendingRepositoryHash() =>
    r'6ab3cb7db4e1e9f795a2ba7a1b1fa2863a519b19';
