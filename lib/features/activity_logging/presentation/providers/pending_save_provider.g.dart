// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_save_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestrates optimistic background saving for single-day activity creation.

@ProviderFor(PendingSaveStateNotifier)
final pendingSaveStateProvider = PendingSaveStateNotifierProvider._();

/// Orchestrates optimistic background saving for single-day activity creation.
final class PendingSaveStateNotifierProvider
    extends $NotifierProvider<PendingSaveStateNotifier, void> {
  /// Orchestrates optimistic background saving for single-day activity creation.
  PendingSaveStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSaveStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSaveStateNotifierHash();

  @$internal
  @override
  PendingSaveStateNotifier create() => PendingSaveStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pendingSaveStateNotifierHash() =>
    r'bfd4d853e8bd3f1a9dfecb3b6993a7dc951d6d15';

/// Orchestrates optimistic background saving for single-day activity creation.

abstract class _$PendingSaveStateNotifier extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
