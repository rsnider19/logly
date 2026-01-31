// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentry_initializer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Sentry initializer instance.

@ProviderFor(sentryInitializer)
final sentryInitializerProvider = SentryInitializerProvider._();

/// Provides the Sentry initializer instance.

final class SentryInitializerProvider
    extends
        $FunctionalProvider<
          SentryInitializer,
          SentryInitializer,
          SentryInitializer
        >
    with $Provider<SentryInitializer> {
  /// Provides the Sentry initializer instance.
  SentryInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sentryInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sentryInitializerHash();

  @$internal
  @override
  $ProviderElement<SentryInitializer> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SentryInitializer create(Ref ref) {
    return sentryInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SentryInitializer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SentryInitializer>(value),
    );
  }
}

String _$sentryInitializerHash() => r'6c7517ff85d9d3d1e4e91311c40452e8964e8d75';
