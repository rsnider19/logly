import 'package:logly/features/profile/data/streak_repository.dart';
import 'package:logly/features/profile/domain/user_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_provider.g.dart';

/// Provides the user's stats (streaks + consistency).
///
/// Fetches from the user_stats view which contains current streak,
/// longest streak, and consistency percentage.
@riverpod
Future<UserStats> userStats(Ref ref) async {
  final repository = ref.watch(streakRepositoryProvider);
  return repository.getUserStats();
}
