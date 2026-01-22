// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_logging_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the activity logging service instance.

@ProviderFor(activityLoggingService)
final activityLoggingServiceProvider = ActivityLoggingServiceProvider._();

/// Provides the activity logging service instance.

final class ActivityLoggingServiceProvider
    extends
        $FunctionalProvider<
          ActivityLoggingService,
          ActivityLoggingService,
          ActivityLoggingService
        >
    with $Provider<ActivityLoggingService> {
  /// Provides the activity logging service instance.
  ActivityLoggingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityLoggingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityLoggingServiceHash();

  @$internal
  @override
  $ProviderElement<ActivityLoggingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityLoggingService create(Ref ref) {
    return activityLoggingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityLoggingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityLoggingService>(value),
    );
  }
}

String _$activityLoggingServiceHash() =>
    r'd9b30c047e33e33d82e172e8b973c9e97b8fce6c';
