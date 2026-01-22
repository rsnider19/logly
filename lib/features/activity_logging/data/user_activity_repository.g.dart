// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the user activity repository instance.

@ProviderFor(userActivityRepository)
final userActivityRepositoryProvider = UserActivityRepositoryProvider._();

/// Provides the user activity repository instance.

final class UserActivityRepositoryProvider
    extends
        $FunctionalProvider<
          UserActivityRepository,
          UserActivityRepository,
          UserActivityRepository
        >
    with $Provider<UserActivityRepository> {
  /// Provides the user activity repository instance.
  UserActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userActivityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userActivityRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserActivityRepository create(Ref ref) {
    return userActivityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserActivityRepository>(value),
    );
  }
}

String _$userActivityRepositoryHash() =>
    r'e8e2e5f6523bca6b248b00554af45023e53579db';
