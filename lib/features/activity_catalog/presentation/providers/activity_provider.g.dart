// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides activity summaries for a specific category (lightweight, for chips/lists).

@ProviderFor(activitiesByCategorySummary)
final activitiesByCategorySummaryProvider =
    ActivitiesByCategorySummaryFamily._();

/// Provides activity summaries for a specific category (lightweight, for chips/lists).

final class ActivitiesByCategorySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivitySummary>>,
          List<ActivitySummary>,
          FutureOr<List<ActivitySummary>>
        >
    with
        $FutureModifier<List<ActivitySummary>>,
        $FutureProvider<List<ActivitySummary>> {
  /// Provides activity summaries for a specific category (lightweight, for chips/lists).
  ActivitiesByCategorySummaryProvider._({
    required ActivitiesByCategorySummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activitiesByCategorySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activitiesByCategorySummaryHash();

  @override
  String toString() {
    return r'activitiesByCategorySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ActivitySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivitySummary>> create(Ref ref) {
    final argument = this.argument as String;
    return activitiesByCategorySummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitiesByCategorySummaryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activitiesByCategorySummaryHash() =>
    r'aa1faa966e9cf5bb0242a95eb9f0024fb2125d71';

/// Provides activity summaries for a specific category (lightweight, for chips/lists).

final class ActivitiesByCategorySummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ActivitySummary>>, String> {
  ActivitiesByCategorySummaryFamily._()
    : super(
        retry: null,
        name: r'activitiesByCategorySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides activity summaries for a specific category (lightweight, for chips/lists).

  ActivitiesByCategorySummaryProvider call(String categoryId) =>
      ActivitiesByCategorySummaryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'activitiesByCategorySummaryProvider';
}

/// Provides a single activity by ID with full details (for log/edit screens).

@ProviderFor(activityById)
final activityByIdProvider = ActivityByIdFamily._();

/// Provides a single activity by ID with full details (for log/edit screens).

final class ActivityByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Activity>, Activity, FutureOr<Activity>>
    with $FutureModifier<Activity>, $FutureProvider<Activity> {
  /// Provides a single activity by ID with full details (for log/edit screens).
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

/// Provides a single activity by ID with full details (for log/edit screens).

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

  /// Provides a single activity by ID with full details (for log/edit screens).

  ActivityByIdProvider call(String activityId) =>
      ActivityByIdProvider._(argument: activityId, from: this);

  @override
  String toString() => r'activityByIdProvider';
}

/// Provides popular activity summaries for onboarding.

@ProviderFor(popularActivitiesSummary)
final popularActivitiesSummaryProvider = PopularActivitiesSummaryProvider._();

/// Provides popular activity summaries for onboarding.

final class PopularActivitiesSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivitySummary>>,
          List<ActivitySummary>,
          FutureOr<List<ActivitySummary>>
        >
    with
        $FutureModifier<List<ActivitySummary>>,
        $FutureProvider<List<ActivitySummary>> {
  /// Provides popular activity summaries for onboarding.
  PopularActivitiesSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularActivitiesSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularActivitiesSummaryHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivitySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivitySummary>> create(Ref ref) {
    return popularActivitiesSummary(ref);
  }
}

String _$popularActivitiesSummaryHash() =>
    r'a4c51aa83633ff4b4d0a753589ddff1b2015eb18';

/// Provides suggested favorite activity summaries.

@ProviderFor(suggestedFavoritesSummary)
final suggestedFavoritesSummaryProvider = SuggestedFavoritesSummaryProvider._();

/// Provides suggested favorite activity summaries.

final class SuggestedFavoritesSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivitySummary>>,
          List<ActivitySummary>,
          FutureOr<List<ActivitySummary>>
        >
    with
        $FutureModifier<List<ActivitySummary>>,
        $FutureProvider<List<ActivitySummary>> {
  /// Provides suggested favorite activity summaries.
  SuggestedFavoritesSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestedFavoritesSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestedFavoritesSummaryHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivitySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivitySummary>> create(Ref ref) {
    return suggestedFavoritesSummary(ref);
  }
}

String _$suggestedFavoritesSummaryHash() =>
    r'5cf345b50037df68036497ed4259b98e9c7a8e26';

/// Provides suggested favorite activity summaries for a specific category.

@ProviderFor(suggestedFavoritesByCategorySummary)
final suggestedFavoritesByCategorySummaryProvider =
    SuggestedFavoritesByCategorySummaryFamily._();

/// Provides suggested favorite activity summaries for a specific category.

final class SuggestedFavoritesByCategorySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivitySummary>>,
          List<ActivitySummary>,
          FutureOr<List<ActivitySummary>>
        >
    with
        $FutureModifier<List<ActivitySummary>>,
        $FutureProvider<List<ActivitySummary>> {
  /// Provides suggested favorite activity summaries for a specific category.
  SuggestedFavoritesByCategorySummaryProvider._({
    required SuggestedFavoritesByCategorySummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'suggestedFavoritesByCategorySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$suggestedFavoritesByCategorySummaryHash();

  @override
  String toString() {
    return r'suggestedFavoritesByCategorySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ActivitySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivitySummary>> create(Ref ref) {
    final argument = this.argument as String;
    return suggestedFavoritesByCategorySummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SuggestedFavoritesByCategorySummaryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suggestedFavoritesByCategorySummaryHash() =>
    r'da7c494100fbdac3fa5b104734fea5a610ade523';

/// Provides suggested favorite activity summaries for a specific category.

final class SuggestedFavoritesByCategorySummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ActivitySummary>>, String> {
  SuggestedFavoritesByCategorySummaryFamily._()
    : super(
        retry: null,
        name: r'suggestedFavoritesByCategorySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides suggested favorite activity summaries for a specific category.

  SuggestedFavoritesByCategorySummaryProvider call(String categoryId) =>
      SuggestedFavoritesByCategorySummaryProvider._(
        argument: categoryId,
        from: this,
      );

  @override
  String toString() => r'suggestedFavoritesByCategorySummaryProvider';
}
