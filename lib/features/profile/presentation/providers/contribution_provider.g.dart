// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides contribution data (activity counts by day) for the last year.

@ProviderFor(contributionData)
final contributionDataProvider = ContributionDataProvider._();

/// Provides contribution data (activity counts by day) for the last year.

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
  /// Provides contribution data (activity counts by day) for the last year.
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

String _$contributionDataHash() => r'fb881a3106f0372f77d14ce6142afc99ed6c814d';
