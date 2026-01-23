// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing selected favorites during onboarding.

@ProviderFor(OnboardingFavoritesStateNotifier)
final onboardingFavoritesStateProvider =
    OnboardingFavoritesStateNotifierProvider._();

/// State notifier for managing selected favorites during onboarding.
final class OnboardingFavoritesStateNotifierProvider
    extends
        $AsyncNotifierProvider<OnboardingFavoritesStateNotifier, Set<String>> {
  /// State notifier for managing selected favorites during onboarding.
  OnboardingFavoritesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingFavoritesStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingFavoritesStateNotifierHash();

  @$internal
  @override
  OnboardingFavoritesStateNotifier create() =>
      OnboardingFavoritesStateNotifier();
}

String _$onboardingFavoritesStateNotifierHash() =>
    r'905fc00b45edf477aa8bb529e16a38c1119e1b63';

/// State notifier for managing selected favorites during onboarding.

abstract class _$OnboardingFavoritesStateNotifier
    extends $AsyncNotifier<Set<String>> {
  FutureOr<Set<String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Set<String>>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Set<String>>, Set<String>>,
              AsyncValue<Set<String>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
