// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_activity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the custom activity service instance.

@ProviderFor(customActivityService)
final customActivityServiceProvider = CustomActivityServiceProvider._();

/// Provides the custom activity service instance.

final class CustomActivityServiceProvider
    extends
        $FunctionalProvider<
          CustomActivityService,
          CustomActivityService,
          CustomActivityService
        >
    with $Provider<CustomActivityService> {
  /// Provides the custom activity service instance.
  CustomActivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customActivityServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customActivityServiceHash();

  @$internal
  @override
  $ProviderElement<CustomActivityService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomActivityService create(Ref ref) {
    return customActivityService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomActivityService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomActivityService>(value),
    );
  }
}

String _$customActivityServiceHash() =>
    r'7474ed2ab9ac760bc9e49ca4d891138fa96bb252';
