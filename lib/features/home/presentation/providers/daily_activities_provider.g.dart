// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_activities_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing daily activities with infinite scroll pagination.

@ProviderFor(DailyActivitiesStateNotifier)
final dailyActivitiesStateProvider = DailyActivitiesStateNotifierProvider._();

/// Notifier for managing daily activities with infinite scroll pagination.
final class DailyActivitiesStateNotifierProvider
    extends
        $AsyncNotifierProvider<
          DailyActivitiesStateNotifier,
          DailyActivitiesState
        > {
  /// Notifier for managing daily activities with infinite scroll pagination.
  DailyActivitiesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyActivitiesStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyActivitiesStateNotifierHash();

  @$internal
  @override
  DailyActivitiesStateNotifier create() => DailyActivitiesStateNotifier();
}

String _$dailyActivitiesStateNotifierHash() =>
    r'b63b1748c360afadf496ba682f173ef2a6088246';

/// Notifier for managing daily activities with infinite scroll pagination.

abstract class _$DailyActivitiesStateNotifier
    extends $AsyncNotifier<DailyActivitiesState> {
  FutureOr<DailyActivitiesState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DailyActivitiesState>, DailyActivitiesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DailyActivitiesState>,
                DailyActivitiesState
              >,
              AsyncValue<DailyActivitiesState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
