// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the subscription service instance.

@ProviderFor(subscriptionService)
final subscriptionServiceProvider = SubscriptionServiceProvider._();

/// Provides the subscription service instance.

final class SubscriptionServiceProvider
    extends
        $FunctionalProvider<
          SubscriptionService,
          SubscriptionService,
          SubscriptionService
        >
    with $Provider<SubscriptionService> {
  /// Provides the subscription service instance.
  SubscriptionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionServiceHash();

  @$internal
  @override
  $ProviderElement<SubscriptionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionService create(Ref ref) {
    return subscriptionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionService>(value),
    );
  }
}

String _$subscriptionServiceHash() =>
    r'1f41f8e9f20e0308edab18442f4759ac664e5846';
