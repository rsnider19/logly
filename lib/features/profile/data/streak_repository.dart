import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/profile/domain/profile_exception.dart';
import 'package:logly/features/profile/domain/streak_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'streak_repository.g.dart';

/// Repository for fetching user activity streak data.
class StreakRepository {
  StreakRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches the current user's streak data.
  Future<StreakData> getStreak() async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>('user_activity_streak');

      if (response == null) {
        return const StreakData(
          currentStreak: 0,
          longestStreak: 0,
          workoutDaysThisWeek: 0,
        );
      }

      return StreakData.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch streak data', e, st);
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
