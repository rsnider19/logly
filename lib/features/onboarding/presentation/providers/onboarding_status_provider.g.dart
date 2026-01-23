// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current user's profile data including onboarding status.

@ProviderFor(profileData)
final profileDataProvider = ProfileDataProvider._();

/// Provides the current user's profile data including onboarding status.

final class ProfileDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileData>,
          ProfileData,
          FutureOr<ProfileData>
        >
    with $FutureModifier<ProfileData>, $FutureProvider<ProfileData> {
  /// Provides the current user's profile data including onboarding status.
  ProfileDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDataHash();

  @$internal
  @override
  $FutureProviderElement<ProfileData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileData> create(Ref ref) {
    return profileData(ref);
  }
}

String _$profileDataHash() => r'83144508f914a5f2b0b556eaf930acbcd809fb8c';

/// Provides whether the current user has completed onboarding.

@ProviderFor(onboardingCompleted)
final onboardingCompletedProvider = OnboardingCompletedProvider._();

/// Provides whether the current user has completed onboarding.

final class OnboardingCompletedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provides whether the current user has completed onboarding.
  OnboardingCompletedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompletedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompletedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return onboardingCompleted(ref);
  }
}

String _$onboardingCompletedHash() =>
    r'cd9f542aefcf7a2b70ee888ff82fb4b3c0a154bc';

/// Provides whether the current user is a returning user (has existing favorites).

@ProviderFor(isReturningUser)
final isReturningUserProvider = IsReturningUserProvider._();

/// Provides whether the current user is a returning user (has existing favorites).

final class IsReturningUserProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provides whether the current user is a returning user (has existing favorites).
  IsReturningUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isReturningUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isReturningUserHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isReturningUser(ref);
  }
}

String _$isReturningUserHash() => r'f46912f07fe8cadfa7ea96e856d2b87ece6f6d0e';
