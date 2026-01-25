// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages entitlement state with reactive updates from RevenueCat.
///
/// Fetches customer info immediately on init and listens for updates.
/// Automatically rebuilds dependent widgets when entitlements change.

@ProviderFor(EntitlementStateNotifier)
final entitlementStateProvider = EntitlementStateNotifierProvider._();

/// Manages entitlement state with reactive updates from RevenueCat.
///
/// Fetches customer info immediately on init and listens for updates.
/// Automatically rebuilds dependent widgets when entitlements change.
final class EntitlementStateNotifierProvider
    extends $NotifierProvider<EntitlementStateNotifier, EntitlementState> {
  /// Manages entitlement state with reactive updates from RevenueCat.
  ///
  /// Fetches customer info immediately on init and listens for updates.
  /// Automatically rebuilds dependent widgets when entitlements change.
  EntitlementStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementStateNotifierHash();

  @$internal
  @override
  EntitlementStateNotifier create() => EntitlementStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EntitlementState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EntitlementState>(value),
    );
  }
}

String _$entitlementStateNotifierHash() =>
    r'25c1780e81be1f4571ba3cbf680f8ae98d9a4cc9';

/// Manages entitlement state with reactive updates from RevenueCat.
///
/// Fetches customer info immediately on init and listens for updates.
/// Automatically rebuilds dependent widgets when entitlements change.

abstract class _$EntitlementStateNotifier extends $Notifier<EntitlementState> {
  EntitlementState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EntitlementState, EntitlementState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EntitlementState, EntitlementState>,
              EntitlementState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provides whether the user has access to a specific premium feature.
///
/// This is a convenience provider that derives from the entitlement state.

@ProviderFor(hasFeature)
final hasFeatureProvider = HasFeatureFamily._();

/// Provides whether the user has access to a specific premium feature.
///
/// This is a convenience provider that derives from the entitlement state.

final class HasFeatureProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provides whether the user has access to a specific premium feature.
  ///
  /// This is a convenience provider that derives from the entitlement state.
  HasFeatureProvider._({
    required HasFeatureFamily super.from,
    required FeatureCode super.argument,
  }) : super(
         retry: null,
         name: r'hasFeatureProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasFeatureHash();

  @override
  String toString() {
    return r'hasFeatureProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as FeatureCode;
    return hasFeature(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HasFeatureProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasFeatureHash() => r'5f0b3247611d01f4f9b5516b677285c327fde452';

/// Provides whether the user has access to a specific premium feature.
///
/// This is a convenience provider that derives from the entitlement state.

final class HasFeatureFamily extends $Family
    with $FunctionalFamilyOverride<bool, FeatureCode> {
  HasFeatureFamily._()
    : super(
        retry: null,
        name: r'hasFeatureProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides whether the user has access to a specific premium feature.
  ///
  /// This is a convenience provider that derives from the entitlement state.

  HasFeatureProvider call(FeatureCode feature) =>
      HasFeatureProvider._(argument: feature, from: this);

  @override
  String toString() => r'hasFeatureProvider';
}

/// Provides whether the user has access to AI Insights.

@ProviderFor(hasAiInsights)
final hasAiInsightsProvider = HasAiInsightsProvider._();

/// Provides whether the user has access to AI Insights.

final class HasAiInsightsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provides whether the user has access to AI Insights.
  HasAiInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasAiInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasAiInsightsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasAiInsights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasAiInsightsHash() => r'eca7bd209c37a6f9ce01fcac928d879ac53b7c2c';

/// Provides whether the user can create custom activities.

@ProviderFor(hasCreateCustomActivity)
final hasCreateCustomActivityProvider = HasCreateCustomActivityProvider._();

/// Provides whether the user can create custom activities.

final class HasCreateCustomActivityProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provides whether the user can create custom activities.
  HasCreateCustomActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasCreateCustomActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasCreateCustomActivityHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasCreateCustomActivity(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasCreateCustomActivityHash() =>
    r'33462c6662303f00fe934a0856c14e0d59d7bba8';

/// Provides whether the user can override activity names.

@ProviderFor(hasActivityNameOverride)
final hasActivityNameOverrideProvider = HasActivityNameOverrideProvider._();

/// Provides whether the user can override activity names.

final class HasActivityNameOverrideProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provides whether the user can override activity names.
  HasActivityNameOverrideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasActivityNameOverrideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasActivityNameOverrideHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasActivityNameOverride(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasActivityNameOverrideHash() =>
    r'a8fa5babfe053d1b5760f8b74a4001187a87e7c7';

/// Provides whether the user has access to location services.

@ProviderFor(hasLocationServices)
final hasLocationServicesProvider = HasLocationServicesProvider._();

/// Provides whether the user has access to location services.

final class HasLocationServicesProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Provides whether the user has access to location services.
  HasLocationServicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasLocationServicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasLocationServicesHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hasLocationServices(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasLocationServicesHash() =>
    r'2ba27c78a0797326ff1e981360b9db97d1828390';
