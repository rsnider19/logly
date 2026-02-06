// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flag_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the feature flag initializer instance.

@ProviderFor(featureFlagInitializer)
final featureFlagInitializerProvider = FeatureFlagInitializerProvider._();

/// Provides the feature flag initializer instance.

final class FeatureFlagInitializerProvider
    extends
        $FunctionalProvider<
          FeatureFlagInitializer,
          FeatureFlagInitializer,
          FeatureFlagInitializer
        >
    with $Provider<FeatureFlagInitializer> {
  /// Provides the feature flag initializer instance.
  FeatureFlagInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagInitializerHash();

  @$internal
  @override
  $ProviderElement<FeatureFlagInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeatureFlagInitializer create(Ref ref) {
    return featureFlagInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureFlagInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureFlagInitializer>(value),
    );
  }
}

String _$featureFlagInitializerHash() =>
    r'2c6088d1bbbda3b491178f52f1d9fbcc054f9af0';
