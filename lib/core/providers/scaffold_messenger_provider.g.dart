// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scaffold_messenger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ScaffoldMessengerState] for showing snackbars from anywhere.

@ProviderFor(scaffoldMessengerKeyProvider)
final scaffoldMessengerKeyProviderProvider = ScaffoldMessengerKeyProviderProvider._();

/// Provides the [ScaffoldMessengerState] for showing snackbars from anywhere.

final class ScaffoldMessengerKeyProviderProvider
    extends
        $FunctionalProvider<
          GlobalKey<ScaffoldMessengerState>,
          GlobalKey<ScaffoldMessengerState>,
          GlobalKey<ScaffoldMessengerState>
        >
    with $Provider<GlobalKey<ScaffoldMessengerState>> {
  /// Provides the [ScaffoldMessengerState] for showing snackbars from anywhere.
  ScaffoldMessengerKeyProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scaffoldMessengerKeyProviderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scaffoldMessengerKeyProviderHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<ScaffoldMessengerState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalKey<ScaffoldMessengerState> create(Ref ref) {
    return scaffoldMessengerKeyProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<ScaffoldMessengerState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<ScaffoldMessengerState>>(
        value,
      ),
    );
  }
}

String _$scaffoldMessengerKeyProviderHash() => r'cd84ccfd70b6d5391902cf3372b15633b2456640';
