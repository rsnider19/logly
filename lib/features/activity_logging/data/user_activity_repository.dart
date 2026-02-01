import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/domain/activity_logging_exception.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/update_user_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_activity_repository.g.dart';

/// Repository for managing user activity logs via Supabase.
class UserActivityRepository {
  UserActivityRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// The select statement for fetching user activities with related data.
  static const String _selectWithRelations = '''
    *,
    activity:activity(*,
      activity_category:activity_category(*),
      activity_detail:activity_detail(*),
      sub_activity:sub_activity(*)
    ),
    user_activity_detail:user_activity_detail(*,
      activity_detail:activity_detail(*)
    ),
    sub_activity:user_activity_sub_activity(
      ...sub_activity(*)
    )
  ''';

  /// Fetches a single user activity by ID with all related data.
  Future<UserActivity> getById(String userActivityId) async {
    try {
      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .eq('user_activity_id', userActivityId)
          .single();

      return UserActivity.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to fetch user activity $userActivityId', e, st);
      throw UserActivityNotFoundException(e.toString());
    }
  }

  /// Fetches user activities for a specific date.
  Future<List<UserActivity>> getByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .gte('activity_timestamp', startOfDay.toIso8601String())
          .lt('activity_timestamp', endOfDay.toIso8601String())
          .order('activity_timestamp', ascending: false);

      return (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch user activities for date $date', e, st);
      throw FetchUserActivitiesException(e.toString());
    }
  }

  /// Fetches user activities for a date range.
  Future<List<UserActivity>> getByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day).add(const Duration(days: 1));

      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .gte('activity_timestamp', start.toIso8601String())
          .lt('activity_timestamp', end.toIso8601String())
          .order('activity_timestamp', ascending: false);

      return (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch user activities for range $startDate - $endDate', e, st);
      throw FetchUserActivitiesException(e.toString());
    }
  }

  /// Fetches user activities for a specific activity within a date range.
  Future<List<UserActivity>> getByActivityIdAndDateRange(
    String activityId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day).add(const Duration(days: 1));

      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .eq('activity_id', activityId)
          .gte('activity_timestamp', start.toIso8601String())
          .lt('activity_timestamp', end.toIso8601String())
          .order('activity_timestamp', ascending: false);

      return (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch user activities for activity $activityId in range $startDate - $endDate', e, st);
      throw FetchUserActivitiesException(e.toString());
    }
  }

  /// Fetches user activities for a specific activity.
  Future<List<UserActivity>> getByActivityId(String activityId) async {
    try {
      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .eq('activity_id', activityId)
          .order('activity_timestamp', ascending: false);

      return (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch user activities for activity $activityId', e, st);
      throw FetchUserActivitiesException(e.toString());
    }
  }

  /// Fetches recent user activities with a limit.
  Future<List<UserActivity>> getRecent({int limit = 20}) async {
    try {
      final response = await _supabase
          .from('user_activity')
          .select(_selectWithRelations)
          .order('activity_timestamp', ascending: false)
          .limit(limit);

      return (response as List).map((e) => UserActivity.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e, st) {
      _logger.e('Failed to fetch recent user activities', e, st);
      throw FetchUserActivitiesException(e.toString());
    }
  }

  /// Creates a new user activity using the create_user_activity RPC.
  ///
  /// This handles creating the activity and its details atomically.
  /// For single day only - multi-day logging is handled by the service layer.
  Future<UserActivity> create(CreateUserActivity activity) async {
    try {
      final userActivityJson = activity.toUserActivityJson();
      final detailsJson = activity.details
          .where((d) => d.hasValue)
          .map(
            (d) => {
              'activity_detail_id': d.activityDetailId,
              'activity_detail_type': d.activityDetailType.name,
              'text_value': d.textValue,
              'environment_value': d.environmentValue?.name,
              'numeric_value': d.numericValue,
              'duration_in_sec': d.durationInSec,
              'distance_in_meters': d.distanceInMeters,
              'liquid_volume_in_liters': d.liquidVolumeInLiters,
              'weight_in_kilograms': d.weightInKilograms,
            },
          )
          .toList();

      _logger.d('=== CREATE USER ACTIVITY RPC ===');
      _logger.d('p_user_activity: $userActivityJson');
      _logger.d('p_details: $detailsJson');
      _logger.d('p_sub_activity_ids: ${activity.subActivityIds}');

      final response = await _supabase
          .rpc(
            'create_user_activity',
            params: {
              'p_user_activity': userActivityJson,
              'p_details': detailsJson,
              'p_sub_activity_ids': activity.subActivityIds,
            },
          )
          .select(_selectWithRelations)
          .single();

      _logger.d('=== RPC RESPONSE ===');
      _logger.d('Response: $response');

      final userActivity = UserActivity.fromJson(response);
      _logger.d('Parsed UserActivity ID: ${userActivity.userActivityId}');

      return userActivity;
    } catch (e, st) {
      _logger.e('=== CREATE USER ACTIVITY FAILED ===');
      _logger.e('Error type: ${e.runtimeType}');
      _logger.e('Error: $e');
      _logger.e('Failed to create user activity', e, st);
      throw LogActivityException(e.toString());
    }
  }

  /// Updates an existing user activity using the update_user_activity RPC.
  Future<UserActivity> update(UpdateUserActivity activity) async {
    try {
      final detailsJson = activity.details
          .where((d) => d.hasValue)
          .map(
            (d) => {
              'activity_detail_id': d.activityDetailId,
              'activity_detail_type': d.activityDetailType.name,
              'text_value': d.textValue,
              'environment_value': d.environmentValue?.name,
              'numeric_value': d.numericValue,
              'duration_in_sec': d.durationInSec,
              'distance_in_meters': d.distanceInMeters,
              'liquid_volume_in_liters': d.liquidVolumeInLiters,
              'weight_in_kilograms': d.weightInKilograms,
            },
          )
          .toList();

      final response = await _supabase
          .rpc(
            'update_user_activity',
            params: {
              'p_user_activity': activity.toUserActivityJson(),
              'p_details': detailsJson,
              'p_sub_activity_ids': activity.subActivityIds,
            },
          )
          .select(_selectWithRelations)
          .single();

      return UserActivity.fromJson(response);
    } catch (e, st) {
      _logger.e('Failed to update user activity ${activity.userActivityId}', e, st);
      throw UpdateActivityException(e.toString());
    }
  }

  /// Deletes a user activity by ID.
  Future<void> delete(String userActivityId) async {
    try {
      await _supabase.from('user_activity').delete().eq('user_activity_id', userActivityId);
    } catch (e, st) {
      _logger.e('Failed to delete user activity $userActivityId', e, st);
      throw DeleteActivityException(e.toString());
    }
  }
}

/// Provides the user activity repository instance.
@Riverpod(keepAlive: true)
UserActivityRepository userActivityRepository(Ref ref) {
  return UserActivityRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
