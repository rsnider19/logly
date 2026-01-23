// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the contribution repository instance.

@ProviderFor(contributionRepository)
final contributionRepositoryProvider = ContributionRepositoryProvider._();

/// Provides the contribution repository instance.

final class ContributionRepositoryProvider
    extends
        $FunctionalProvider<
          ContributionRepository,
          ContributionRepository,
          ContributionRepository
        >
    with $Provider<ContributionRepository> {
  /// Provides the contribution repository instance.
  ContributionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contributionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contributionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContributionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContributionRepository create(Ref ref) {
    return contributionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContributionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContributionRepository>(value),
    );
  }
}

String _$contributionRepositoryHash() =>
    r'a958f7c50ac6588406f8d4c0f50d5c87624f1ba2';
