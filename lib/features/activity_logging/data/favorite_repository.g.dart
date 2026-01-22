// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the favorite repository instance.

@ProviderFor(favoriteRepository)
final favoriteRepositoryProvider = FavoriteRepositoryProvider._();

/// Provides the favorite repository instance.

final class FavoriteRepositoryProvider
    extends
        $FunctionalProvider<
          FavoriteRepository,
          FavoriteRepository,
          FavoriteRepository
        >
    with $Provider<FavoriteRepository> {
  /// Provides the favorite repository instance.
  FavoriteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoriteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoriteRepository create(Ref ref) {
    return favoriteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoriteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoriteRepository>(value),
    );
  }
}

String _$favoriteRepositoryHash() =>
    r'86467dd13d08956d8783e48f73368b87e34c9192';
