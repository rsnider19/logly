// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_answers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing in-memory onboarding question answers.

@ProviderFor(OnboardingAnswersStateNotifier)
final onboardingAnswersStateProvider =
    OnboardingAnswersStateNotifierProvider._();

/// State notifier for managing in-memory onboarding question answers.
final class OnboardingAnswersStateNotifierProvider
    extends
        $NotifierProvider<OnboardingAnswersStateNotifier, OnboardingAnswers> {
  /// State notifier for managing in-memory onboarding question answers.
  OnboardingAnswersStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingAnswersStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingAnswersStateNotifierHash();

  @$internal
  @override
  OnboardingAnswersStateNotifier create() => OnboardingAnswersStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingAnswers value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingAnswers>(value),
    );
  }
}

String _$onboardingAnswersStateNotifierHash() =>
    r'2939c61590363d3bd6cba2c8737dce0ecd18018b';

/// State notifier for managing in-memory onboarding question answers.

abstract class _$OnboardingAnswersStateNotifier
    extends $Notifier<OnboardingAnswers> {
  OnboardingAnswers build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnboardingAnswers, OnboardingAnswers>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingAnswers, OnboardingAnswers>,
              OnboardingAnswers,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
