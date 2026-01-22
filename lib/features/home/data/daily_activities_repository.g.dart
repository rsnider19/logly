// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activities_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the daily activities repository instance.

@ProviderFor(dailyActivitiesRepository)
final dailyActivitiesRepositoryProvider = DailyActivitiesRepositoryProvider._();

/// Provides the daily activities repository instance.

final class DailyActivitiesRepositoryProvider
    extends
        $FunctionalProvider<
          DailyActivitiesRepository,
          DailyActivitiesRepository,
          DailyActivitiesRepository
        >
    with $Provider<DailyActivitiesRepository> {
  /// Provides the daily activities repository instance.
  DailyActivitiesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyActivitiesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyActivitiesRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyActivitiesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyActivitiesRepository create(Ref ref) {
    return dailyActivitiesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyActivitiesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyActivitiesRepository>(value),
    );
  }
}

String _$dailyActivitiesRepositoryHash() =>
    r'529b34210a8be5f155c3c5c1a8aa7499ba32ea43';
