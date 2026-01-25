// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the health sync service instance.

@ProviderFor(healthSyncService)
final healthSyncServiceProvider = HealthSyncServiceProvider._();

/// Provides the health sync service instance.

final class HealthSyncServiceProvider
    extends
        $FunctionalProvider<
          HealthSyncService,
          HealthSyncService,
          HealthSyncService
        >
    with $Provider<HealthSyncService> {
  /// Provides the health sync service instance.
  HealthSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSyncServiceHash();

  @$internal
  @override
  $ProviderElement<HealthSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HealthSyncService create(Ref ref) {
    return healthSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthSyncService>(value),
    );
  }
}

String _$healthSyncServiceHash() => r'1d01f8bff9e9386e5d79b5c329aebc065c98df88';
