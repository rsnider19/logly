// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing the activity logging form.

@ProviderFor(ActivityFormStateNotifier)
final activityFormStateProvider = ActivityFormStateNotifierProvider._();

/// State notifier for managing the activity logging form.
final class ActivityFormStateNotifierProvider
    extends $NotifierProvider<ActivityFormStateNotifier, ActivityFormState> {
  /// State notifier for managing the activity logging form.
  ActivityFormStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityFormStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityFormStateNotifierHash();

  @$internal
  @override
  ActivityFormStateNotifier create() => ActivityFormStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityFormState>(value),
    );
  }
}

String _$activityFormStateNotifierHash() =>
    r'55c46f6d77546e6bef76758f8a7fbbfe8c54c778';

/// State notifier for managing the activity logging form.

abstract class _$ActivityFormStateNotifier
    extends $Notifier<ActivityFormState> {
  ActivityFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActivityFormState, ActivityFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityFormState, ActivityFormState>,
              ActivityFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
