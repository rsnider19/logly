// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consistency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides consistency score (% of days active in last 30 days).
///
/// Derives from [activityCountsByDateProvider] single source of truth.

@ProviderFor(consistencyScore)
final consistencyScoreProvider = ConsistencyScoreProvider._();

/// Provides consistency score (% of days active in last 30 days).
///
/// Derives from [activityCountsByDateProvider] single source of truth.

final class ConsistencyScoreProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Provides consistency score (% of days active in last 30 days).
  ///
  /// Derives from [activityCountsByDateProvider] single source of truth.
  ConsistencyScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consistencyScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consistencyScoreHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return consistencyScore(ref);
  }
}

String _$consistencyScoreHash() => r'7e0c9f2188a83b1c7765d932e064e1a7c83def46';
