// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches user activities for a specific activity and month.

@ProviderFor(activityMonthUserActivities)
final activityMonthUserActivitiesProvider =
    ActivityMonthUserActivitiesFamily._();

/// Fetches user activities for a specific activity and month.

final class ActivityMonthUserActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Fetches user activities for a specific activity and month.
  ActivityMonthUserActivitiesProvider._({
    required ActivityMonthUserActivitiesFamily super.from,
    required (String, int, int) super.argument,
  }) : super(
         retry: null,
         name: r'activityMonthUserActivitiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityMonthUserActivitiesHash();

  @override
  String toString() {
    return r'activityMonthUserActivitiesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserActivity>> create(Ref ref) {
    final argument = this.argument as (String, int, int);
    return activityMonthUserActivities(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityMonthUserActivitiesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityMonthUserActivitiesHash() =>
    r'd65cbc3cfba0298534828a5a125a7d57fbf6547a';

/// Fetches user activities for a specific activity and month.

final class ActivityMonthUserActivitiesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<UserActivity>>,
          (String, int, int)
        > {
  ActivityMonthUserActivitiesFamily._()
    : super(
        retry: null,
        name: r'activityMonthUserActivitiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches user activities for a specific activity and month.

  ActivityMonthUserActivitiesProvider call(
    String activityId,
    int year,
    int month,
  ) => ActivityMonthUserActivitiesProvider._(
    argument: (activityId, year, month),
    from: this,
  );

  @override
  String toString() => r'activityMonthUserActivitiesProvider';
}

/// Derives monthly statistics from the fetched user activities.

@ProviderFor(activityMonthStatistics)
final activityMonthStatisticsProvider = ActivityMonthStatisticsFamily._();

/// Derives monthly statistics from the fetched user activities.

final class ActivityMonthStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityMonthStatistics>,
          ActivityMonthStatistics,
          FutureOr<ActivityMonthStatistics>
        >
    with
        $FutureModifier<ActivityMonthStatistics>,
        $FutureProvider<ActivityMonthStatistics> {
  /// Derives monthly statistics from the fetched user activities.
  ActivityMonthStatisticsProvider._({
    required ActivityMonthStatisticsFamily super.from,
    required (String, int, int) super.argument,
  }) : super(
         retry: null,
         name: r'activityMonthStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityMonthStatisticsHash();

  @override
  String toString() {
    return r'activityMonthStatisticsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ActivityMonthStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActivityMonthStatistics> create(Ref ref) {
    final argument = this.argument as (String, int, int);
    return activityMonthStatistics(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityMonthStatisticsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityMonthStatisticsHash() =>
    r'7ca1550674a1b744987c6e7cd679f5a7d2568923';

/// Derives monthly statistics from the fetched user activities.

final class ActivityMonthStatisticsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ActivityMonthStatistics>,
          (String, int, int)
        > {
  ActivityMonthStatisticsFamily._()
    : super(
        retry: null,
        name: r'activityMonthStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Derives monthly statistics from the fetched user activities.

  ActivityMonthStatisticsProvider call(
    String activityId,
    int year,
    int month,
  ) => ActivityMonthStatisticsProvider._(
    argument: (activityId, year, month),
    from: this,
  );

  @override
  String toString() => r'activityMonthStatisticsProvider';
}
