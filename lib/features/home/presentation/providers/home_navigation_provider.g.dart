// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
