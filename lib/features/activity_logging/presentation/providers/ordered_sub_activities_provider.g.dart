// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordered_sub_activities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides sub-activities ordered by usage frequency for the current activity.
///
/// Returns the frequency-ordered list from [ActivityLoggingService], or the
/// original order while loading / if no activity is selected.

@ProviderFor(orderedSubActivities)
final orderedSubActivitiesProvider = OrderedSubActivitiesProvider._();

/// Provides sub-activities ordered by usage frequency for the current activity.
///
/// Returns the frequency-ordered list from [ActivityLoggingService], or the
/// original order while loading / if no activity is selected.

final class OrderedSubActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SubActivity>>,
          List<SubActivity>,
          FutureOr<List<SubActivity>>
        >
    with
        $FutureModifier<List<SubActivity>>,
        $FutureProvider<List<SubActivity>> {
  /// Provides sub-activities ordered by usage frequency for the current activity.
  ///
  /// Returns the frequency-ordered list from [ActivityLoggingService], or the
  /// original order while loading / if no activity is selected.
  OrderedSubActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderedSubActivitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderedSubActivitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<SubActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SubActivity>> create(Ref ref) {
    return orderedSubActivities(ref);
  }
}

String _$orderedSubActivitiesHash() =>
    r'ea6048b9b558df81f82c5508f19beec2b9e57a39';
