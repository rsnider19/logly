// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trigger counter that increments when the home tab icon is tapped.
/// HomeScreen listens to this to scroll back to the top.

@ProviderFor(HomeScrollToTopTriggerNotifier)
final homeScrollToTopTriggerProvider =
    HomeScrollToTopTriggerNotifierProvider._();

/// Trigger counter that increments when the home tab icon is tapped.
/// HomeScreen listens to this to scroll back to the top.
final class HomeScrollToTopTriggerNotifierProvider
    extends $NotifierProvider<HomeScrollToTopTriggerNotifier, int> {
  /// Trigger counter that increments when the home tab icon is tapped.
  /// HomeScreen listens to this to scroll back to the top.
  HomeScrollToTopTriggerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeScrollToTopTriggerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeScrollToTopTriggerNotifierHash();

  @$internal
  @override
  HomeScrollToTopTriggerNotifier create() => HomeScrollToTopTriggerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$homeScrollToTopTriggerNotifierHash() =>
    r'068a0514548345677eb0aff7661e9ce9675cfa13';

/// Trigger counter that increments when the home tab icon is tapped.
/// HomeScreen listens to this to scroll back to the top.

abstract class _$HomeScrollToTopTriggerNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Notifier for managing the bottom navigation state.

@ProviderFor(HomeNavigationStateNotifier)
final homeNavigationStateProvider = HomeNavigationStateNotifierProvider._();

/// Notifier for managing the bottom navigation state.
final class HomeNavigationStateNotifierProvider
    extends $NotifierProvider<HomeNavigationStateNotifier, int> {
  /// Notifier for managing the bottom navigation state.
  HomeNavigationStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeNavigationStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNavigationStateNotifierHash();

  @$internal
  @override
  HomeNavigationStateNotifier create() => HomeNavigationStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$homeNavigationStateNotifierHash() =>
    r'7e287df667a89abed27101769793431a5945bdda';

/// Notifier for managing the bottom navigation state.

abstract class _$HomeNavigationStateNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
