// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the catalog service instance.

@ProviderFor(catalogService)
final catalogServiceProvider = CatalogServiceProvider._();

/// Provides the catalog service instance.

final class CatalogServiceProvider
    extends $FunctionalProvider<CatalogService, CatalogService, CatalogService>
    with $Provider<CatalogService> {
  /// Provides the catalog service instance.
  CatalogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogServiceHash();

  @$internal
  @override
  $ProviderElement<CatalogService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CatalogService create(Ref ref) {
    return catalogService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogService>(value),
    );
  }
}

String _$catalogServiceHash() => r'38930609fdcfa9868fb5d815db915bd03f534772';
