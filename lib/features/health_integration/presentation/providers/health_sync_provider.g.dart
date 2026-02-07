// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing health sync state.

@ProviderFor(HealthSyncStateNotifier)
final healthSyncStateProvider = HealthSyncStateNotifierProvider._();

/// Notifier for managing health sync state.
final class HealthSyncStateNotifierProvider
    extends $NotifierProvider<HealthSyncStateNotifier, HealthSyncState> {
  /// Notifier for managing health sync state.
  HealthSyncStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSyncStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSyncStateNotifierHash();

  @$internal
  @override
  HealthSyncStateNotifier create() => HealthSyncStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthSyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthSyncState>(value),
    );
  }
}

String _$healthSyncStateNotifierHash() =>
    r'9717e5d43572f2e18a6de6ab6885f87b4b2c1eb7';

/// Notifier for managing health sync state.

abstract class _$HealthSyncStateNotifier extends $Notifier<HealthSyncState> {
  HealthSyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HealthSyncState, HealthSyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HealthSyncState, HealthSyncState>,
              HealthSyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
