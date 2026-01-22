// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides activities for a specific category.

@ProviderFor(activitiesByCategory)
final activitiesByCategoryProvider = ActivitiesByCategoryFamily._();

/// Provides activities for a specific category.

final class ActivitiesByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Activity>>,
          List<Activity>,
          FutureOr<List<Activity>>
        >
    with $FutureModifier<List<Activity>>, $FutureProvider<List<Activity>> {
  /// Provides activities for a specific category.
  ActivitiesByCategoryProvider._({
    required ActivitiesByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activitiesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activitiesByCategoryHash();

  @override
  String toString() {
    return r'activitiesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Activity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Activity>> create(Ref ref) {
    final argument = this.argument as String;
    return activitiesByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitiesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activitiesByCategoryHash() =>
    r'18ee82016175ea35251eac018a49b2fb36611723';

/// Provides activities for a specific category.

final class ActivitiesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Activity>>, String> {
  ActivitiesByCategoryFamily._()
    : super(
        retry: null,
        name: r'activitiesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides activities for a specific category.

  ActivitiesByCategoryProvider call(String categoryId) =>
      ActivitiesByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'activitiesByCategoryProvider';
}

/// Provides a single activity by ID with full details.

@ProviderFor(activityById)
final activityByIdProvider = ActivityByIdFamily._();

/// Provides a single activity by ID with full details.

final class ActivityByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Activity>, Activity, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  /// Provides a single activity by ID with full details.
  ActivityByIdProvider._({
    required ActivityByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activityByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityByIdHash();

  @override
  String toString() {
    return r'activityByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Activity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Activity> create(Ref ref) {
    final argument = this.argument as String;
    return activityById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityByIdHash() => r'af2b766c1ecbf51daf4e8f5897704dadaa30513f';

/// Provides a single activity by ID with full details.

final class ActivityByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Activity>, String> {
  ActivityByIdFamily._()
    : super(
        retry: null,
        name: r'activityByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a single activity by ID with full details.

  ActivityByIdProvider call(String activityId) =>
      ActivityByIdProvider._(argument: activityId, from: this);

  @override
  String toString() => r'activityByIdProvider';
}

/// Provides popular activities for onboarding.

@ProviderFor(popularActivities)
final popularActivitiesProvider = PopularActivitiesProvider._();

/// Provides popular activities for onboarding.

final class PopularActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Activity>>,
          List<Activity>,
          FutureOr<List<Activity>>
        >
    with $FutureModifier<List<Activity>>, $FutureProvider<List<Activity>> {
  /// Provides popular activities for onboarding.
  PopularActivitiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularActivitiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularActivitiesHash();

  @$internal
  @override
  $FutureProviderElement<List<Activity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Activity>> create(Ref ref) {
    return popularActivities(ref);
  }
}

String _$popularActivitiesHash() => r'090df661a9cc5a657aa383a3d4878d3c4cd63ea8';

/// Provides suggested favorite activities.

@ProviderFor(suggestedFavorites)
final suggestedFavoritesProvider = SuggestedFavoritesProvider._();

/// Provides suggested favorite activities.

final class SuggestedFavoritesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Activity>>,
          List<Activity>,
          FutureOr<List<Activity>>
        >
    with $FutureModifier<List<Activity>>, $FutureProvider<List<Activity>> {
  /// Provides suggested favorite activities.
  SuggestedFavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestedFavoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestedFavoritesHash();

  @$internal
  @override
  $FutureProviderElement<List<Activity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Activity>> create(Ref ref) {
    return suggestedFavorites(ref);
  }
}

String _$suggestedFavoritesHash() =>
    r'40d258c9a85580f3bb14e19685b9cae3de55e5e7';
