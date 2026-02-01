// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app router instance with auth-based redirects.
///
/// Uses [ref.listen] + [refreshListenable] so the GoRouter is created once
/// and redirect logic is re-evaluated when auth/onboarding state changes,
/// without recreating the router (which would reset navigation state).

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Provides the app router instance with auth-based redirects.
///
/// Uses [ref.listen] + [refreshListenable] so the GoRouter is created once
/// and redirect logic is re-evaluated when auth/onboarding state changes,
/// without recreating the router (which would reset navigation state).

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Provides the app router instance with auth-based redirects.
  ///
  /// Uses [ref.listen] + [refreshListenable] so the GoRouter is created once
  /// and redirect logic is re-evaluated when auth/onboarding state changes,
  /// without recreating the router (which would reset navigation state).
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'f64231db4be253e8169991e0eb1806c1777bc915';
