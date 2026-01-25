// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the subscription initializer instance.

@ProviderFor(subscriptionInitializer)
final subscriptionInitializerProvider = SubscriptionInitializerProvider._();

/// Provides the subscription initializer instance.

final class SubscriptionInitializerProvider
    extends
        $FunctionalProvider<
          SubscriptionInitializer,
          SubscriptionInitializer,
          SubscriptionInitializer
        >
    with $Provider<SubscriptionInitializer> {
  /// Provides the subscription initializer instance.
  SubscriptionInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionInitializerHash();

  @$internal
  @override
  $ProviderElement<SubscriptionInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionInitializer create(Ref ref) {
    return subscriptionInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionInitializer>(value),
    );
  }
}

String _$subscriptionInitializerHash() =>
    r'2882c973f6f12290348c031db5e632b0a16aeaf6';
