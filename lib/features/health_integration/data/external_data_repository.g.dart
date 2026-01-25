// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_data_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the external data repository instance.

@ProviderFor(externalDataRepository)
final externalDataRepositoryProvider = ExternalDataRepositoryProvider._();

/// Provides the external data repository instance.

final class ExternalDataRepositoryProvider
    extends
        $FunctionalProvider<
          ExternalDataRepository,
          ExternalDataRepository,
          ExternalDataRepository
        >
    with $Provider<ExternalDataRepository> {
  /// Provides the external data repository instance.
  ExternalDataRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'externalDataRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$externalDataRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExternalDataRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExternalDataRepository create(Ref ref) {
    return externalDataRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExternalDataRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExternalDataRepository>(value),
    );
  }
}

String _$externalDataRepositoryHash() =>
    r'2d02d5fad6985cb89f0cdae92cfacb89e3d7dc2d';
