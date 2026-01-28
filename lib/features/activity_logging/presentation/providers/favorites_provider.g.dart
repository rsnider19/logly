// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides all favorite activities for the current user.

@ProviderFor(favoriteActivities)
final favoriteActivitiesProvider = FavoriteActivitiesProvider._();

/// Provides all favorite activities for the current user.

final class FavoriteActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FavoriteActivity>>,
          List<FavoriteActivity>,
          FutureOr<List<FavoriteActivity>>
        >
    with
        $FutureModifier<List<FavoriteActivity>>,
        $FutureProvider<List<FavoriteActivity>> {
  /// Provides all favorite activities for the current user.
  FavoriteActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteActivitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteActivitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<FavoriteActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FavoriteActivity>> create(Ref ref) {
    return favoriteActivities(ref);
  }
}

String _$favoriteActivitiesHash() =>
    r'974a2f68e7c625e8e3d09a186aac30ca07791586';

/// Provides the set of favorited activity IDs for efficient lookup.

@ProviderFor(favoriteActivityIds)
final favoriteActivityIdsProvider = FavoriteActivityIdsProvider._();

/// Provides the set of favorited activity IDs for efficient lookup.

final class FavoriteActivityIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Provides the set of favorited activity IDs for efficient lookup.
  FavoriteActivityIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteActivityIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteActivityIdsHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return favoriteActivityIds(ref);
  }
}

String _$favoriteActivityIdsHash() =>
    r'62db2964fb808318f89374d07e47db45a76a7817';

/// Provides whether a specific activity is favorited.

@ProviderFor(isActivityFavorited)
final isActivityFavoritedProvider = IsActivityFavoritedFamily._();

/// Provides whether a specific activity is favorited.

final class IsActivityFavoritedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provides whether a specific activity is favorited.
  IsActivityFavoritedProvider._({
    required IsActivityFavoritedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isActivityFavoritedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isActivityFavoritedHash();

  @override
  String toString() {
    return r'isActivityFavoritedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isActivityFavorited(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsActivityFavoritedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isActivityFavoritedHash() =>
    r'161ae5c190ac07a503535e6f22093a41a9ed0e78';

/// Provides whether a specific activity is favorited.

final class IsActivityFavoritedFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsActivityFavoritedFamily._()
    : super(
        retry: null,
        name: r'isActivityFavoritedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides whether a specific activity is favorited.

  IsActivityFavoritedProvider call(String activityId) =>
      IsActivityFavoritedProvider._(argument: activityId, from: this);

  @override
  String toString() => r'isActivityFavoritedProvider';
}

/// State notifier for managing favorite actions with optimistic updates.

@ProviderFor(FavoriteStateNotifier)
final favoriteStateProvider = FavoriteStateNotifierProvider._();

/// State notifier for managing favorite actions with optimistic updates.
final class FavoriteStateNotifierProvider
    extends $NotifierProvider<FavoriteStateNotifier, AsyncValue<Set<String>>> {
  /// State notifier for managing favorite actions with optimistic updates.
  FavoriteStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteStateNotifierHash();

  @$internal
  @override
  FavoriteStateNotifier create() => FavoriteStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Set<String>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Set<String>>>(value),
    );
  }
}

String _$favoriteStateNotifierHash() =>
    r'7e8b7b1db02f2b85c4015bcace26956c44837e79';

/// State notifier for managing favorite actions with optimistic updates.

abstract class _$FavoriteStateNotifier
    extends $Notifier<AsyncValue<Set<String>>> {
  AsyncValue<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<Set<String>>, AsyncValue<Set<String>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, AsyncValue<Set<String>>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
