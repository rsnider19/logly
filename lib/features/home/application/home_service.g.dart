// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the home service instance.

@ProviderFor(homeService)
final homeServiceProvider = HomeServiceProvider._();

/// Provides the home service instance.

final class HomeServiceProvider
    extends $FunctionalProvider<HomeService, HomeService, HomeService>
    with $Provider<HomeService> {
  /// Provides the home service instance.
  HomeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeServiceHash();

  @$internal
  @override
  $ProviderElement<HomeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HomeService create(Ref ref) {
    return homeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HomeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HomeService>(value),
    );
  }
}

String _$homeServiceHash() => r'e87b66a69004bd9c93a29ed0982d651733f6f92e';
