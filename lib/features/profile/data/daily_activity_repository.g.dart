// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activity_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the daily activity repository instance.

@ProviderFor(dailyActivityRepository)
final dailyActivityRepositoryProvider = DailyActivityRepositoryProvider._();

/// Provides the daily activity repository instance.

final class DailyActivityRepositoryProvider
    extends
        $FunctionalProvider<
          DailyActivityRepository,
          DailyActivityRepository,
          DailyActivityRepository
        >
    with $Provider<DailyActivityRepository> {
  /// Provides the daily activity repository instance.
  DailyActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyActivityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyActivityRepositoryHash();

  @$internal
  @override
  $ProviderElement<DailyActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DailyActivityRepository create(Ref ref) {
    return dailyActivityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyActivityRepository>(value),
    );
  }
}

String _$dailyActivityRepositoryHash() =>
    r'0d6be518419575671687daf0dee0bb4853725bb1';
