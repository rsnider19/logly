// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growthbook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the GrowthBook SDK instance.
///
/// This provider must be overridden in the ProviderScope during app bootstrap
/// with an initialized GrowthBook SDK instance.

@ProviderFor(growthBook)
final growthBookProvider = GrowthBookProvider._();

/// Provides the GrowthBook SDK instance.
///
/// This provider must be overridden in the ProviderScope during app bootstrap
/// with an initialized GrowthBook SDK instance.

final class GrowthBookProvider
    extends $FunctionalProvider<GrowthBookSDK, GrowthBookSDK, GrowthBookSDK>
    with $Provider<GrowthBookSDK> {
  /// Provides the GrowthBook SDK instance.
  ///
  /// This provider must be overridden in the ProviderScope during app bootstrap
  /// with an initialized GrowthBook SDK instance.
  GrowthBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'growthBookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$growthBookHash();

  @$internal
  @override
  $ProviderElement<GrowthBookSDK> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GrowthBookSDK create(Ref ref) {
    return growthBook(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrowthBookSDK value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GrowthBookSDK>(value),
    );
  }
}

String _$growthBookHash() => r'ca7f2ed3b418755aece8f201d3370329da062775';
