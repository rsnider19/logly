// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the health sync initializer instance.

@ProviderFor(healthSyncInitializer)
final healthSyncInitializerProvider = HealthSyncInitializerProvider._();

/// Provides the health sync initializer instance.

final class HealthSyncInitializerProvider
    extends
        $FunctionalProvider<
          HealthSyncInitializer,
          HealthSyncInitializer,
          HealthSyncInitializer
        >
    with $Provider<HealthSyncInitializer> {
  /// Provides the health sync initializer instance.
  HealthSyncInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSyncInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSyncInitializerHash();

  @$internal
  @override
  $ProviderElement<HealthSyncInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HealthSyncInitializer create(Ref ref) {
    return healthSyncInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthSyncInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthSyncInitializer>(value),
    );
  }
}

String _$healthSyncInitializerHash() =>
    r'ba10acbc44a674a7c137b68b754c642258340c9e';
