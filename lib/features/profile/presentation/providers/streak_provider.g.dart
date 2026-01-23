// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the user's streak data.

@ProviderFor(streak)
final streakProvider = StreakProvider._();

/// Provides the user's streak data.

final class StreakProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakData>,
          StreakData,
          FutureOr<StreakData>
        >
    with $FutureModifier<StreakData>, $FutureProvider<StreakData> {
  /// Provides the user's streak data.
  StreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakHash();

  @$internal
  @override
  $FutureProviderElement<StreakData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<StreakData> create(Ref ref) {
    return streak(ref);
  }
}

String _$streakHash() => r'9ba57e550e2f08c039f452901256b6f53e08c2fd';
