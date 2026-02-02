import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/data/favorite_repository.dart';
import 'package:logly/features/activity_logging/data/user_activity_repository.dart';
import 'package:logly/features/activity_logging/domain/activity_logging_exception.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
import 'package:logly/features/activity_logging/domain/log_multi_day_result.dart';
import 'package:logly/features/activity_logging/domain/update_user_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_logging_service.g.dart';

/// Service for coordinating activity logging operations.
///
/// Handles validation, business logic, and orchestrates repositories.
class ActivityLoggingService {
  ActivityLoggingService(this._userActivityRepository, this._favoriteRepository, this._logger);

  final UserActivityRepository _userActivityRepository;
  final FavoriteRepository _favoriteRepository;
  final LoggerService _logger;

  // ==================== User Activities ====================

  /// Fetches a single user activity by ID.
  Future<UserActivity> getUserActivityById(String userActivityId) async {
    if (userActivityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }
    return _userActivityRepository.getById(userActivityId);
  }

  /// Fetches user activities for a specific date.
  Future<List<UserActivity>> getUserActivitiesByDate(DateTime date) async {
    return _userActivityRepository.getByDate(date);
  }

  /// Fetches user activities for a date range.
  Future<List<UserActivity>> getUserActivitiesByDateRange(DateTime startDate, DateTime endDate) async {
    if (endDate.isBefore(startDate)) {
      throw const ActivityLoggingValidationException('End date must be after start date');
    }
    return _userActivityRepository.getByDateRange(startDate, endDate);
  }

  /// Fetches user activities for a specific activity within a date range.
  Future<List<UserActivity>> getUserActivitiesByActivityIdAndDateRange(
    String activityId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }
    if (endDate.isBefore(startDate)) {
      throw const ActivityLoggingValidationException('End date must be after start date');
    }
    return _userActivityRepository.getByActivityIdAndDateRange(activityId, startDate, endDate);
  }

  /// Fetches user activities for a specific activity type.
  Future<List<UserActivity>> getUserActivitiesByActivityId(String activityId) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }
    return _userActivityRepository.getByActivityId(activityId);
  }

  /// Fetches recent user activities.
  Future<List<UserActivity>> getRecentUserActivities({int limit = 20}) async {
    return _userActivityRepository.getRecent(limit: limit);
  }

  /// Logs a new activity for a single day.
  ///
  /// Validates the input and creates the activity via the repository.
  /// Returns the created UserActivity.
  Future<UserActivity> logActivity(CreateUserActivity activity) async {
    _logger.d('=== SERVICE: logActivity ===');
    _logger.d('activityId: ${activity.activityId}');
    _logger.d('activityTimestamp: ${activity.activityTimestamp}');
    _logger.d('activityDate: ${activity.activityDate}');
    _logger.d('comments: ${activity.comments}');
    _logger.d('activityNameOverride: ${activity.activityNameOverride}');
    _logger.d('subActivityIds: ${activity.subActivityIds}');
    _logger.d('details count: ${activity.details.length}');

    // Validation
    if (activity.activityId.isEmpty) {
      _logger.e('Validation failed: Activity must be selected');
      throw const ActivityLoggingValidationException('Activity must be selected');
    }

    _logger.d('Validation passed, calling repository.create()...');

    try {
      final result = await _userActivityRepository.create(activity);
      _logger.d('=== SERVICE: logActivity SUCCESS ===');
      _logger.d('Created UserActivity ID: ${result.userActivityId}');
      return result;
    } catch (e, st) {
      _logger.e('=== SERVICE: logActivity FAILED ===');
      _logger.e('Error: $e', e, st);
      rethrow;
    }
  }

  /// Logs an activity across multiple days.
  ///
  /// Creates one activity per day in the date range. Uses fail-fast approach:
  /// if a day fails, already successful days are kept, but remaining days
  /// are not attempted.
  ///
  /// Returns a [LogMultiDayResult] containing successes and failures.
  Future<LogMultiDayResult> logMultiDayActivity({
    required String activityId,
    required DateTime startDate,
    required DateTime endDate,
    String? comments,
    String? activityNameOverride,
    List<String> subActivityIds = const [],
    List<CreateUserActivityDetail> details = const [],
  }) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity must be selected');
    }

    if (endDate.isBefore(startDate)) {
      throw const ActivityLoggingValidationException('End date must be after start date');
    }

    final successes = <UserActivity>[];
    final failures = <FailedDay>[];

    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);

    while (!currentDate.isAfter(endDateOnly)) {
      try {
        final activity = CreateUserActivity(
          activityId: activityId,
          activityTimestamp: currentDate,
          activityDate: currentDate,
          comments: comments,
          activityNameOverride: activityNameOverride,
          subActivityIds: subActivityIds,
          details: details,
        );

        final result = await _userActivityRepository.create(activity);
        successes.add(result);
      } catch (e) {
        _logger.e('Failed to log activity for date $currentDate', e, StackTrace.current);
        failures.add(FailedDay(date: currentDate, errorMessage: e.toString()));
        // Continue to next day instead of fail-fast to maximize successes
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    _logger.d(
      'Multi-day logging complete: ${successes.length} successes, ${failures.length} failures',
    );

    return LogMultiDayResult(successes: successes, failures: failures);
  }

  /// Convenience method to log a single-day activity from UI parameters.
  Future<UserActivity> logSingleDayActivity({
    required String activityId,
    required DateTime activityTimestamp,
    String? comments,
    String? activityNameOverride,
    List<String> subActivityIds = const [],
    List<CreateUserActivityDetailInput> details = const [],
  }) async {
    final activityDate = DateTime(
      activityTimestamp.year,
      activityTimestamp.month,
      activityTimestamp.day,
    );

    final activity = CreateUserActivity(
      activityId: activityId,
      activityTimestamp: activityTimestamp,
      activityDate: activityDate,
      comments: comments,
      activityNameOverride: activityNameOverride,
      subActivityIds: subActivityIds,
      details: details.map((d) => d.toCreateUserActivityDetail()).toList(),
    );

    return logActivity(activity);
  }

  /// Updates an existing activity log.
  ///
  /// Returns the updated UserActivity.
  Future<UserActivity> updateActivity(UpdateUserActivity activity) async {
    if (activity.userActivityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity log ID cannot be empty');
    }

    _logger.d('Updating activity ${activity.userActivityId}');

    return _userActivityRepository.update(activity);
  }

  /// Deletes an activity log.
  Future<void> deleteActivity(String userActivityId) async {
    if (userActivityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity log ID cannot be empty');
    }

    _logger.d('Deleting activity $userActivityId');

    await _userActivityRepository.delete(userActivityId);
  }

  // ==================== Sub-Activity Frequency ====================

  /// Returns sub-activities ordered by usage frequency for the given activity.
  ///
  /// Frequently used sub-activities appear first, followed by unused ones
  /// in their original order. Falls back to original order if no history.
  Future<List<SubActivity>> getSubActivitiesOrderedByFrequency(
    String activityId,
    List<SubActivity> allSubActivities,
  ) async {
    if (activityId.isEmpty || allSubActivities.isEmpty) {
      return allSubActivities;
    }

    try {
      final frequencyOrder = await _userActivityRepository.getSubActivityFrequency(activityId);

      if (frequencyOrder.isEmpty) {
        return allSubActivities;
      }

      final subActivityMap = {for (final sa in allSubActivities) sa.subActivityId: sa};
      final ordered = <SubActivity>[];
      final usedIds = <String>{};

      // Add frequently used ones first (in frequency order)
      for (final id in frequencyOrder) {
        final sa = subActivityMap[id];
        if (sa != null) {
          ordered.add(sa);
          usedIds.add(id);
        }
      }

      // Add remaining in original order
      for (final sa in allSubActivities) {
        if (!usedIds.contains(sa.subActivityId)) {
          ordered.add(sa);
        }
      }

      return ordered;
    } catch (e) {
      _logger.e('Failed to get sub-activity frequency, using original order', e, StackTrace.current);
      return allSubActivities;
    }
  }

  // ==================== Favorites ====================

  /// Fetches all favorite activities for the current user.
  Future<List<FavoriteActivity>> getFavorites() async {
    return _favoriteRepository.getAll();
  }

  /// Fetches the set of favorited activity IDs.
  Future<Set<String>> getFavoriteIds() async {
    return _favoriteRepository.getFavoriteIds();
  }

  /// Checks if an activity is favorited.
  Future<bool> isFavorite(String activityId) async {
    if (activityId.isEmpty) {
      return false;
    }
    return _favoriteRepository.isFavorite(activityId);
  }

  /// Toggles the favorite status of an activity.
  /// Returns the new favorite status.
  Future<bool> toggleFavorite(String activityId) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }

    _logger.d('Toggling favorite for activity $activityId');

    return _favoriteRepository.toggle(activityId);
  }

  /// Adds an activity to favorites.
  Future<void> addFavorite(String activityId) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }
    await _favoriteRepository.add(activityId);
  }

  /// Removes an activity from favorites.
  Future<void> removeFavorite(String activityId) async {
    if (activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity ID cannot be empty');
    }
    await _favoriteRepository.remove(activityId);
  }
}

/// Provides the activity logging service instance.
@Riverpod(keepAlive: true)
ActivityLoggingService activityLoggingService(Ref ref) {
  return ActivityLoggingService(
    ref.watch(userActivityRepositoryProvider),
    ref.watch(favoriteRepositoryProvider),
    ref.watch(loggerProvider),
  );
}

/// Helper class for building activity detail input.
///
/// This provides a cleaner API for building detail values in the service layer.
class CreateUserActivityDetailInput {
  CreateUserActivityDetailInput({
    required this.activityDetailId,
    required this.activityDetailType,
    this.textValue,
    this.environmentValue,
    this.numericValue,
    this.durationInSec,
    this.distanceInMeters,
    this.liquidVolumeInLiters,
    this.weightInKilograms,
    this.latLng,
  });

  final String activityDetailId;
  final ActivityDetailType activityDetailType;
  final String? textValue;
  final String? environmentValue;
  final double? numericValue;
  final int? durationInSec;
  final double? distanceInMeters;
  final double? liquidVolumeInLiters;
  final double? weightInKilograms;
  final String? latLng;

  /// Converts to the domain model.
  CreateUserActivityDetail toCreateUserActivityDetail() {
    return CreateUserActivityDetail(
      activityDetailId: activityDetailId,
      activityDetailType: activityDetailType,
      textValue: textValue,
      environmentValue: environmentValue != null ? EnvironmentType.values.byName(environmentValue!) : null,
      numericValue: numericValue,
      durationInSec: durationInSec,
      distanceInMeters: distanceInMeters,
      liquidVolumeInLiters: liquidVolumeInLiters,
      weightInKilograms: weightInKilograms,
      latLng: latLng,
    );
  }
}
