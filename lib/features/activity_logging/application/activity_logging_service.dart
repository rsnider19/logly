import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/data/favorite_repository.dart';
import 'package:logly/features/activity_logging/data/user_activity_repository.dart';
import 'package:logly/features/activity_logging/domain/activity_logging_exception.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity.dart';
import 'package:logly/features/activity_logging/domain/create_user_activity_detail.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
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

  /// Logs a new activity.
  ///
  /// Validates the input and creates the activity via the repository.
  /// Supports multi-day logging when start and end dates differ.
  Future<void> logActivity(CreateUserActivity activity) async {
    // Validation
    if (activity.activityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity must be selected');
    }

    if (activity.activityEndDate.isBefore(activity.activityStartDate)) {
      throw const ActivityLoggingValidationException('End date must be after start date');
    }

    _logger.d(
      'Logging activity ${activity.activityId} '
      'from ${activity.activityStartDate} to ${activity.activityEndDate}',
    );

    await _userActivityRepository.create(activity);
  }

  /// Logs an activity for multiple days.
  ///
  /// Convenience method that creates a CreateUserActivity with a date range.
  Future<void> logMultiDayActivity({
    required String activityId,
    required DateTime startDate,
    required DateTime endDate,
    String? comments,
    String? activityNameOverride,
    List<String> subActivityIds = const [],
    List<CreateUserActivityDetailInput> details = const [],
  }) async {
    final activity = CreateUserActivity(
      activityId: activityId,
      activityStartDate: startDate,
      activityEndDate: endDate,
      comments: comments,
      activityNameOverride: activityNameOverride,
      subActivityIds: subActivityIds,
      details: details.map((d) => d.toCreateUserActivityDetail()).toList(),
    );

    await logActivity(activity);
  }

  /// Updates an existing activity log.
  Future<void> updateActivity(UpdateUserActivity activity) async {
    if (activity.userActivityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity log ID cannot be empty');
    }

    _logger.d('Updating activity ${activity.userActivityId}');

    await _userActivityRepository.update(activity);
  }

  /// Deletes an activity log.
  Future<void> deleteActivity(String userActivityId) async {
    if (userActivityId.isEmpty) {
      throw const ActivityLoggingValidationException('Activity log ID cannot be empty');
    }

    _logger.d('Deleting activity $userActivityId');

    await _userActivityRepository.delete(userActivityId);
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
