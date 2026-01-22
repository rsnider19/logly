// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides user activities for a specific date.

@ProviderFor(userActivitiesByDate)
final userActivitiesByDateProvider = UserActivitiesByDateFamily._();

/// Provides user activities for a specific date.

final class UserActivitiesByDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides user activities for a specific date.
  UserActivitiesByDateProvider._({
    required UserActivitiesByDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'userActivitiesByDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userActivitiesByDateHash();

  @override
  String toString() {
    return r'userActivitiesByDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserActivity>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return userActivitiesByDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserActivitiesByDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userActivitiesByDateHash() =>
    r'3ff5d05c8cfd8853c080e01dfae3680bca844867';

/// Provides user activities for a specific date.

final class UserActivitiesByDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserActivity>>, DateTime> {
  UserActivitiesByDateFamily._()
    : super(
        retry: null,
        name: r'userActivitiesByDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides user activities for a specific date.

  UserActivitiesByDateProvider call(DateTime date) =>
      UserActivitiesByDateProvider._(argument: date, from: this);

  @override
  String toString() => r'userActivitiesByDateProvider';
}

/// Provides user activities for a date range.

@ProviderFor(userActivitiesByDateRange)
final userActivitiesByDateRangeProvider = UserActivitiesByDateRangeFamily._();

/// Provides user activities for a date range.

final class UserActivitiesByDateRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides user activities for a date range.
  UserActivitiesByDateRangeProvider._({
    required UserActivitiesByDateRangeFamily super.from,
    required (DateTime, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'userActivitiesByDateRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userActivitiesByDateRangeHash();

  @override
  String toString() {
    return r'userActivitiesByDateRangeProvider'
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
    final argument = this.argument as (DateTime, DateTime);
    return userActivitiesByDateRange(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is UserActivitiesByDateRangeProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userActivitiesByDateRangeHash() =>
    r'7604313dfc51c9c177723e93706cef34a7d547a0';

/// Provides user activities for a date range.

final class UserActivitiesByDateRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<UserActivity>>,
          (DateTime, DateTime)
        > {
  UserActivitiesByDateRangeFamily._()
    : super(
        retry: null,
        name: r'userActivitiesByDateRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides user activities for a date range.

  UserActivitiesByDateRangeProvider call(
    DateTime startDate,
    DateTime endDate,
  ) => UserActivitiesByDateRangeProvider._(
    argument: (startDate, endDate),
    from: this,
  );

  @override
  String toString() => r'userActivitiesByDateRangeProvider';
}

/// Provides user activities for a specific activity type.

@ProviderFor(userActivitiesByActivityId)
final userActivitiesByActivityIdProvider = UserActivitiesByActivityIdFamily._();

/// Provides user activities for a specific activity type.

final class UserActivitiesByActivityIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides user activities for a specific activity type.
  UserActivitiesByActivityIdProvider._({
    required UserActivitiesByActivityIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userActivitiesByActivityIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userActivitiesByActivityIdHash();

  @override
  String toString() {
    return r'userActivitiesByActivityIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserActivity>> create(Ref ref) {
    final argument = this.argument as String;
    return userActivitiesByActivityId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserActivitiesByActivityIdProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userActivitiesByActivityIdHash() =>
    r'470e7978cf92459420c63efe4ed29b3a768584c1';

/// Provides user activities for a specific activity type.

final class UserActivitiesByActivityIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserActivity>>, String> {
  UserActivitiesByActivityIdFamily._()
    : super(
        retry: null,
        name: r'userActivitiesByActivityIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides user activities for a specific activity type.

  UserActivitiesByActivityIdProvider call(String activityId) =>
      UserActivitiesByActivityIdProvider._(argument: activityId, from: this);

  @override
  String toString() => r'userActivitiesByActivityIdProvider';
}

/// Provides a single user activity by ID.

@ProviderFor(userActivityById)
final userActivityByIdProvider = UserActivityByIdFamily._();

/// Provides a single user activity by ID.

final class UserActivityByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserActivity>,
          UserActivity,
          FutureOr<UserActivity>
        >
    with $FutureModifier<UserActivity>, $FutureProvider<UserActivity> {
  /// Provides a single user activity by ID.
  UserActivityByIdProvider._({
    required UserActivityByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userActivityByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userActivityByIdHash();

  @override
  String toString() {
    return r'userActivityByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserActivity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserActivity> create(Ref ref) {
    final argument = this.argument as String;
    return userActivityById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserActivityByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userActivityByIdHash() => r'1d3609ac2205baf475ff318616d0bbd704614b13';

/// Provides a single user activity by ID.

final class UserActivityByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserActivity>, String> {
  UserActivityByIdFamily._()
    : super(
        retry: null,
        name: r'userActivityByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a single user activity by ID.

  UserActivityByIdProvider call(String userActivityId) =>
      UserActivityByIdProvider._(argument: userActivityId, from: this);

  @override
  String toString() => r'userActivityByIdProvider';
}

/// Provides recent user activities.

@ProviderFor(recentUserActivities)
final recentUserActivitiesProvider = RecentUserActivitiesFamily._();

/// Provides recent user activities.

final class RecentUserActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides recent user activities.
  RecentUserActivitiesProvider._({
    required RecentUserActivitiesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'recentUserActivitiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recentUserActivitiesHash();

  @override
  String toString() {
    return r'recentUserActivitiesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserActivity>> create(Ref ref) {
    final argument = this.argument as int;
    return recentUserActivities(ref, limit: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentUserActivitiesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recentUserActivitiesHash() =>
    r'1381cc2b4cef1fb88c3f80db22ca47962a5db998';

/// Provides recent user activities.

final class RecentUserActivitiesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserActivity>>, int> {
  RecentUserActivitiesFamily._()
    : super(
        retry: null,
        name: r'recentUserActivitiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides recent user activities.

  RecentUserActivitiesProvider call({int limit = 20}) =>
      RecentUserActivitiesProvider._(argument: limit, from: this);

  @override
  String toString() => r'recentUserActivitiesProvider';
}

/// Provides user activities for today.

@ProviderFor(todaysActivities)
final todaysActivitiesProvider = TodaysActivitiesProvider._();

/// Provides user activities for today.

final class TodaysActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides user activities for today.
  TodaysActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysActivitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysActivitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<UserActivity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserActivity>> create(Ref ref) {
    return todaysActivities(ref);
  }
}

String _$todaysActivitiesHash() => r'274136973cd27df8f7cc1d58e5aa7d65df5773fb';
