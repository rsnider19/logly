// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'already_logged_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides activities already logged for a specific date, sorted by creation time.

@ProviderFor(alreadyLoggedActivities)
final alreadyLoggedActivitiesProvider = AlreadyLoggedActivitiesFamily._();

/// Provides activities already logged for a specific date, sorted by creation time.

final class AlreadyLoggedActivitiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserActivity>>,
          List<UserActivity>,
          FutureOr<List<UserActivity>>
        >
    with
        $FutureModifier<List<UserActivity>>,
        $FutureProvider<List<UserActivity>> {
  /// Provides activities already logged for a specific date, sorted by creation time.
  AlreadyLoggedActivitiesProvider._({
    required AlreadyLoggedActivitiesFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'alreadyLoggedActivitiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alreadyLoggedActivitiesHash();

  @override
  String toString() {
    return r'alreadyLoggedActivitiesProvider'
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
    return alreadyLoggedActivities(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlreadyLoggedActivitiesProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alreadyLoggedActivitiesHash() =>
    r'f3ee43c33c75edbb7c1eb02549d0fd401145bc69';

/// Provides activities already logged for a specific date, sorted by creation time.

final class AlreadyLoggedActivitiesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserActivity>>, DateTime> {
  AlreadyLoggedActivitiesFamily._()
    : super(
        retry: null,
        name: r'alreadyLoggedActivitiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides activities already logged for a specific date, sorted by creation time.

  AlreadyLoggedActivitiesProvider call(DateTime date) =>
      AlreadyLoggedActivitiesProvider._(argument: date, from: this);

  @override
  String toString() => r'alreadyLoggedActivitiesProvider';
}
