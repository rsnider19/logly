// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides contribution data (activity counts by day) for the last year.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by date for the contribution graph.

@ProviderFor(contributionData)
final contributionDataProvider = ContributionDataProvider._();

/// Provides contribution data (activity counts by day) for the last year.
///
/// Derives from the single source [activityCountsByDateProvider] and
/// aggregates by date for the contribution graph.

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
  ///
  /// Derives from the single source [activityCountsByDateProvider] and
  /// aggregates by date for the contribution graph.
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

String _$contributionDataHash() => r'd621c56349e19f281c8b07ba04607dfcecb39cb6';
