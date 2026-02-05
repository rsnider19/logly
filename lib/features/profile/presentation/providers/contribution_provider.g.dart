// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides contribution data (activity counts by day) for the last year,
/// filtered by the global category selection.
///
/// Derives from [dailyCategoryCountsProvider] single source of truth.

@ProviderFor(contributionData)
final contributionDataProvider = ContributionDataProvider._();

/// Provides contribution data (activity counts by day) for the last year,
/// filtered by the global category selection.
///
/// Derives from [dailyCategoryCountsProvider] single source of truth.

final class ContributionDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, int>>,
          Map<DateTime, int>,
          FutureOr<Map<DateTime, int>>
        >
    with
        $FutureModifier<Map<DateTime, int>>,
        $FutureProvider<Map<DateTime, int>> {
  /// Provides contribution data (activity counts by day) for the last year,
  /// filtered by the global category selection.
  ///
  /// Derives from [dailyCategoryCountsProvider] single source of truth.
  ContributionDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contributionDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contributionDataHash();

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, int>> create(Ref ref) {
    return contributionData(ref);
  }
}

String _$contributionDataHash() => r'e52abb2c8589fb447feeb7c2f4ad5dee11c30bac';
