// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing notification preferences.

@ProviderFor(NotificationPreferencesStateNotifier)
final notificationPreferencesStateProvider =
    NotificationPreferencesStateNotifierProvider._();

/// State notifier for managing notification preferences.
final class NotificationPreferencesStateNotifierProvider
    extends
        $NotifierProvider<
          NotificationPreferencesStateNotifier,
          NotificationPreferences
        > {
  /// State notifier for managing notification preferences.
  NotificationPreferencesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationPreferencesStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$notificationPreferencesStateNotifierHash();

  @$internal
  @override
  NotificationPreferencesStateNotifier create() =>
      NotificationPreferencesStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationPreferences>(value),
    );
  }
}

String _$notificationPreferencesStateNotifierHash() =>
    r'7aa2e9cbc049cc6ded7b804fcf9d1c549215c411';

/// State notifier for managing notification preferences.

abstract class _$NotificationPreferencesStateNotifier
    extends $Notifier<NotificationPreferences> {
  NotificationPreferences build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<NotificationPreferences, NotificationPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationPreferences, NotificationPreferences>,
              NotificationPreferences,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
