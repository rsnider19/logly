import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/onboarding/domain/onboarding_exception.dart';
import 'package:logly/features/onboarding/domain/profile_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'onboarding_repository.g.dart';

/// Repository for onboarding-related data operations.
class OnboardingRepository {
  OnboardingRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Fetches the current user's profile via the my_profile() RPC.
  Future<ProfileData> getProfile() async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>('my_profile');
      return ProfileData.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch profile', e, st);
      throw FetchProfileException(e.toString());
    }
  }

  /// Checks if the current user has completed onboarding.
  Future<bool> hasCompletedOnboarding() async {
    try {
      final profile = await getProfile();
      return profile.onboardingCompleted;
    } catch (e, st) {
      _logger.e('Failed to check onboarding status', e, st);
      throw FetchProfileException(e.toString());
    }
  }

  /// Marks onboarding as completed for the current user.
  Future<void> completeOnboarding() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const CompleteOnboardingException('User not authenticated');
      }

      await _supabase
          .from('profile')
          .update({
            'onboarding_completed': true,
          })
          .eq('user_id', userId);
    } catch (e, st) {
      _logger.e('Failed to complete onboarding', e, st);
      if (e is CompleteOnboardingException) rethrow;
      throw CompleteOnboardingException(e.toString());
    }
  }

  /// Saves favorites by replacing all existing favorites with the provided list.
  Future<void> saveFavorites(List<String> activityIds) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const SaveFavoritesException('User not authenticated');
      }

      // Delete existing favorites
      await _supabase.from('favorite_user_activity').delete().eq('user_id', userId);

      // Insert new favorites
      if (activityIds.isNotEmpty) {
        final inserts = activityIds.map((id) => {'activity_id': id, 'user_id': userId}).toList();
        await _supabase.from('favorite_user_activity').insert(inserts);
      }
    } catch (e, st) {
      _logger.e('Failed to save favorites', e, st);
      if (e is SaveFavoritesException) rethrow;
      throw SaveFavoritesException(e.toString());
    }
  }

  /// Fetches the IDs of all favorited activities for the current user.
  Future<List<String>> getExistingFavoriteIds() async {
    try {
      final response = await _supabase.from('favorite_user_activity').select('activity_id');

      return (response as List).map((e) => e['activity_id'] as String).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch favorite IDs', e, st);
      throw FetchProfileException(e.toString());
    }
  }
}

/// Provides the onboarding repository instance.
@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) {
  return OnboardingRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
