// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_counts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Raw activity counts by date - single source of truth.
///
/// All derived providers (monthly chart, weekly radar, contribution graph)
/// watch this provider. Invalidating this provider refreshes all dependents.

@ProviderFor(activityCountsByDate)
final activityCountsByDateProvider = ActivityCountsByDateProvider._();

/// Raw activity counts by date - single source of truth.
///
/// All derived providers (monthly chart, weekly radar, contribution graph)
/// watch this provider. Invalidating this provider refreshes all dependents.

final class ActivityCountsByDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityCountByDate>>,
          List<ActivityCountByDate>,
          FutureOr<List<ActivityCountByDate>>
        >
    with
        $FutureModifier<List<ActivityCountByDate>>,
        $FutureProvider<List<ActivityCountByDate>> {
  /// Raw activity counts by date - single source of truth.
  ///
  /// All derived providers (monthly chart, weekly radar, contribution graph)
  /// watch this provider. Invalidating this provider refreshes all dependents.
  ActivityCountsByDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityCountsByDateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityCountsByDateHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivityCountByDate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityCountByDate>> create(Ref ref) {
    return activityCountsByDate(ref);
  }
}

String _$activityCountsByDateHash() =>
    r'7b994428e47fe9a85f7319e1bfa4594f51b58c0f';
