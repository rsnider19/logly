// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the profile service instance.

@ProviderFor(profileService)
final profileServiceProvider = ProfileServiceProvider._();

/// Provides the profile service instance.

final class ProfileServiceProvider
    extends $FunctionalProvider<ProfileService, ProfileService, ProfileService>
    with $Provider<ProfileService> {
  /// Provides the profile service instance.
  ProfileServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileServiceHash();

  @$internal
  @override
  $ProviderElement<ProfileService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProfileService create(Ref ref) {
    return profileService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileService>(value),
    );
  }
}

String _$profileServiceHash() => r'03b92bc8252510d05536dae52c987b2de12c3493';
