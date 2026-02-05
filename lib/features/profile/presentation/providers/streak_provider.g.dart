// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the user's stats (streaks + consistency).
///
/// Fetches from the user_stats view which contains current streak,
/// longest streak, and consistency percentage.

@ProviderFor(userStats)
final userStatsProvider = UserStatsProvider._();

/// Provides the user's stats (streaks + consistency).
///
/// Fetches from the user_stats view which contains current streak,
/// longest streak, and consistency percentage.

final class UserStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStats>,
          UserStats,
          FutureOr<UserStats>
        >
    with $FutureModifier<UserStats>, $FutureProvider<UserStats> {
  /// Provides the user's stats (streaks + consistency).
  ///
  /// Fetches from the user_stats view which contains current streak,
  /// longest streak, and consistency percentage.
  UserStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStatsHash();

  @$internal
  @override
  $FutureProviderElement<UserStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserStats> create(Ref ref) {
    return userStats(ref);
  }
}

String _$userStatsHash() => r'97eb5b50a87c17f6fd5c22321fd50d407e243f38';
