import 'dart:io';

import 'package:health/health.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/onboarding/data/onboarding_repository.dart';
import 'package:logly/features/onboarding/domain/onboarding_exception.dart';
import 'package:logly/features/onboarding/domain/profile_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_service.g.dart';

/// Service for onboarding business logic.
class OnboardingService {
  OnboardingService(this._repository, this._logger);

  final OnboardingRepository _repository;
  final LoggerService _logger;

  /// Fetches the current user's profile.
  Future<ProfileData> getProfile() async {
    return _repository.getProfile();
  }

  /// Checks if the current user has completed onboarding.
  Future<bool> hasCompletedOnboarding() async {
    return _repository.hasCompletedOnboarding();
  }

  /// Checks if this is a returning user (has existing favorites).
  /// Returning users should skip the intro pager.
  Future<bool> isReturningUser() async {
    final favoriteIds = await _repository.getExistingFavoriteIds();
    return favoriteIds.isNotEmpty;
  }

  /// Gets the user's existing favorite activity IDs.
  Future<List<String>> getExistingFavoriteIds() async {
    return _repository.getExistingFavoriteIds();
  }

  /// Saves the selected favorite activities.
  Future<void> saveFavorites(List<String> activityIds) async {
    await _repository.saveFavorites(activityIds);
  }

  /// Marks onboarding as completed.
  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding();
  }

  /// Requests health platform permissions.
  /// Returns true if permissions were granted, false otherwise.
  Future<bool> requestHealthPermissions() async {
    try {
      final health = Health();

      // Configure the health plugin
      await health.configure();

      // Define the data types we want to access
      final types = <HealthDataType>[
        HealthDataType.WORKOUT,
        if (Platform.isAndroid) ...[
          HealthDataType.DISTANCE_DELTA,
          HealthDataType.TOTAL_CALORIES_BURNED,
        ],
        if (Platform.isIOS) ...[
          HealthDataType.DISTANCE_WALKING_RUNNING,
          HealthDataType.ACTIVE_ENERGY_BURNED,
        ],
      ];

      // Request authorization
      final granted = await health.requestAuthorization(types);

      _logger.i('Health permissions ${granted ? 'granted' : 'denied'}');
      return granted;
    } catch (e, st) {
      _logger.e('Failed to request health permissions', e, st);
      throw HealthPermissionException(e.toString());
    }
  }

  /// Checks if health permissions have been granted.
  Future<bool> hasHealthPermissions() async {
    try {
      final health = Health();
      await health.configure();

      final types = <HealthDataType>[
        HealthDataType.WORKOUT,
      ];

      final result = await health.hasPermissions(types);
      return result ?? false;
    } catch (e, st) {
      _logger.e('Failed to check health permissions', e, st);
      return false;
    }
  }
}

/// Provides the onboarding service instance.
@Riverpod(keepAlive: true)
OnboardingService onboardingService(Ref ref) {
  return OnboardingService(
    ref.watch(onboardingRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
