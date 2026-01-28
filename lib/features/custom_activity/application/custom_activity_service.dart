import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/custom_activity/data/custom_activity_repository.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:logly/features/custom_activity/domain/custom_activity_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_activity_service.g.dart';

/// Service for coordinating custom activity creation.
///
/// Handles validation, business logic, and orchestrates repositories.
class CustomActivityService {
  CustomActivityService(this._repository, this._logger);

  final CustomActivityRepository _repository;
  final LoggerService _logger;

  /// Creates a new custom activity.
  ///
  /// Validates the input before creating the activity.
  /// Returns the created [Activity].
  Future<Activity> createCustomActivity({
    required String categoryId,
    required String name,
    required List<ActivityDetailConfig> details,
  }) async {
    // Validate category
    if (categoryId.isEmpty) {
      throw const CustomActivityValidationException('Category is required');
    }

    // Validate name
    final trimmedName = name.trim();
    if (trimmedName.length < 2) {
      throw const CustomActivityValidationException('Name must be at least 2 characters');
    }
    if (trimmedName.length > 50) {
      throw const CustomActivityValidationException('Name must be 50 characters or less');
    }

    // Validate name uniqueness
    final isUnique = await _repository.isNameUnique(trimmedName);
    if (!isUnique) {
      throw ActivityNameTakenException(trimmedName);
    }

    // Validate details count
    if (details.length > 10) {
      throw const CustomActivityValidationException('Maximum 10 details allowed');
    }

    // Validate detail labels
    for (final detail in details) {
      if (detail.requiresLabel) {
        final label = switch (detail) {
          NumberDetailConfig(:final label) => label,
          DurationDetailConfig(:final label) => label,
          DistanceDetailConfig(:final label) => label,
          EnvironmentDetailConfig(:final label) => label,
          PaceDetailConfig() => '',
        };

        if (label.trim().isEmpty) {
          throw CustomActivityValidationException('${detail.typeName} detail requires a label');
        }
      }
    }

    // Validate pace dependencies
    final hasPace = details.any((d) => d is PaceDetailConfig);
    if (hasPace) {
      final hasDurationForPace = details.any((d) => d is DurationDetailConfig && d.useForPace);
      final hasDistanceForPace = details.any((d) => d is DistanceDetailConfig && d.useForPace);

      if (!hasDurationForPace || !hasDistanceForPace) {
        throw const CustomActivityValidationException(
          'Pace requires a Duration and Distance marked for pace calculation',
        );
      }
    }

    _logger.d('Creating custom activity: $trimmedName with ${details.length} details');

    return _repository.createCustomActivity(
      categoryId: categoryId,
      name: trimmedName,
      details: details,
    );
  }

  /// Checks if an activity name is available.
  Future<bool> isNameAvailable(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.length < 2) {
      return true; // Too short to check
    }
    return _repository.isNameUnique(trimmedName);
  }
}

/// Provides the custom activity service instance.
@Riverpod(keepAlive: true)
CustomActivityService customActivityService(Ref ref) {
  return CustomActivityService(
    ref.watch(customActivityRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
