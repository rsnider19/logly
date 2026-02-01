import 'dart:io';

import 'package:health/health.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/health_integration/domain/health_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_repository.g.dart';

/// Repository for interacting with the device health platform.
class HealthRepository {
  HealthRepository(this._logger);

  final LoggerService _logger;
  final Health _health = Health();

  /// The health data types needed for workout sync.
  List<HealthDataType> get _workoutTypes => [
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

  /// Configures the health plugin. Must be called before other operations.
  Future<void> configure() async {
    await _health.configure();
  }

  /// Checks if the required WORKOUT permissions have been granted.
  Future<bool> hasPermissions() async {
    try {
      await configure();
      final result = await _health.hasPermissions(_workoutTypes);
      return result ?? false;
    } catch (e, st) {
      _logger.e('Failed to check health permissions', e, st);
      return false;
    }
  }

  /// Requests permissions for WORKOUT and platform-specific health data types.
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    try {
      await configure();
      final granted = await _health.requestAuthorization(_workoutTypes);
      _logger.i('Health permissions ${granted ? 'granted' : 'denied'}');
      return granted;
    } catch (e, st) {
      _logger.e('Failed to request health permissions', e, st);
      throw HealthPlatformUnavailableException(e.toString());
    }
  }

  /// Fetches raw health data from the health platform within the given date range.
  Future<List<HealthDataPoint>> fetchHealthData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      await configure();

      final data = await _health.getHealthDataFromTypes(
        types: _workoutTypes,
        startTime: startDate,
        endTime: endDate,
      );

      _logger.i('Fetched ${data.length} health records from health platform');

      return data;
    } catch (e, st) {
      _logger.e('Failed to fetch health data from health platform', e, st);
      throw FetchWorkoutsException(e.toString());
    }
  }
}

/// Provides the health repository instance.
@Riverpod(keepAlive: true)
HealthRepository healthRepository(Ref ref) {
  return HealthRepository(ref.watch(loggerProvider));
}
