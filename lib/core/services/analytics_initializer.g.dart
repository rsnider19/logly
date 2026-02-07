// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the analytics initializer instance.

@ProviderFor(analyticsInitializer)
final analyticsInitializerProvider = AnalyticsInitializerProvider._();

/// Provides the analytics initializer instance.

final class AnalyticsInitializerProvider
    extends
        $FunctionalProvider<
          AnalyticsInitializer,
          AnalyticsInitializer,
          AnalyticsInitializer
        >
    with $Provider<AnalyticsInitializer> {
  /// Provides the analytics initializer instance.
  AnalyticsInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsInitializerHash();

  @$internal
  @override
  $ProviderElement<AnalyticsInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsInitializer create(Ref ref) {
    return analyticsInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsInitializer>(value),
    );
  }
}

String _$analyticsInitializerHash() =>
    r'557795524f12c35b915663fd973c2ba9bede23f8';
