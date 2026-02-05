import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:logly/features/profile/domain/user_stats.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'streak_repository.g.dart';

/// Repository for fetching user activity streak data.
class StreakRepository {
  StreakRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches user stats (streaks + consistency) from user_stats view.
  Future<UserStats> getUserStats() async {
    try {
      final response = await _supabase
          .from('user_stats')
          .select('current_streak, longest_streak, consistency_pct')
          .maybeSingle();

      if (response == null) {
        return const UserStats(currentStreak: 0, longestStreak: 0, consistencyPct: 0);
      }

      return UserStats.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch user stats', e, st);
      throw FetchStreakException(e.toString());
    }
  }
}

/// Provides the streak repository instance.
@Riverpod(keepAlive: true)
StreakRepository streakRepository(Ref ref) {
  return StreakRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
