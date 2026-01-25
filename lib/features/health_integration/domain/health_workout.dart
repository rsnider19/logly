import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:health/health.dart';

part 'health_workout.freezed.dart';
part 'health_workout.g.dart';

/// Represents a workout parsed from the health platform.
@freezed
abstract class HealthWorkout with _$HealthWorkout {
  const factory HealthWorkout({
    /// Unique identifier from the health platform source.
    required String sourceId,

    /// The workout activity type (e.g., RUNNING, CYCLING).
    required String workoutActivityType,

    /// When the workout started.
    required DateTime dateFrom,

    /// When the workout ended.
    required DateTime dateTo,

    /// Total distance in meters (if available).
    double? totalDistance,

    /// Unit of distance measurement from the source.
    String? totalDistanceUnit,

    /// Total energy burned in kcal (if available).
    double? totalEnergyBurned,

    /// Unit of energy measurement from the source.
    String? totalEnergyUnit,
  }) = _HealthWorkout;

  const HealthWorkout._();

  factory HealthWorkout.fromJson(Map<String, dynamic> json) => _$HealthWorkoutFromJson(json);

  /// Creates a HealthWorkout from a HealthDataPoint.
  factory HealthWorkout.fromHealthDataPoint(HealthDataPoint point) {
    // Extract workout data from the value
    var workoutType = 'OTHER';
    double? distance;
    String? distanceUnit;
    double? energyBurned;
    String? energyUnit;

    if (point.value is WorkoutHealthValue) {
      final workoutValue = point.value as WorkoutHealthValue;
      workoutType = workoutValue.workoutActivityType.name;

      // Get distance and energy from WorkoutHealthValue
      if (workoutValue.totalDistance != null) {
        distance = workoutValue.totalDistance!.toDouble();
        distanceUnit = workoutValue.totalDistanceUnit?.name ?? 'METER';
      }

      if (workoutValue.totalEnergyBurned != null) {
        energyBurned = workoutValue.totalEnergyBurned!.toDouble();
        energyUnit = workoutValue.totalEnergyBurnedUnit?.name ?? 'KILOCALORIE';
      }
    }

    return HealthWorkout(
      sourceId: point.uuid,
      workoutActivityType: workoutType,
      dateFrom: point.dateFrom,
      dateTo: point.dateTo,
      totalDistance: distance,
      totalDistanceUnit: distanceUnit,
      totalEnergyBurned: energyBurned,
      totalEnergyUnit: energyUnit,
    );
  }

  /// Converts this workout to the JSON format expected by the database trigger.
  ///
  /// The trigger expects:
  /// ```json
  /// {
  ///   "type": "WORKOUT",
  ///   "dateFrom": "ISO8601",
  ///   "dateTo": "ISO8601",
  ///   "value": { "workoutActivityType": "RUNNING", "totalDistanceUnit": "METER" },
  ///   "workoutSummary": { "totalDistance": 5000.0 }
  /// }
  /// ```
  Map<String, dynamic> toExternalDataJson() {
    return {
      'type': 'WORKOUT',
      'dateFrom': dateFrom.toUtc().toIso8601String(),
      'dateTo': dateTo.toUtc().toIso8601String(),
      'value': {
        'workoutActivityType': workoutActivityType,
        if (totalDistanceUnit != null) 'totalDistanceUnit': totalDistanceUnit,
        if (totalEnergyUnit != null) 'totalEnergyUnit': totalEnergyUnit,
      },
      'workoutSummary': {
        if (totalDistance != null) 'totalDistance': totalDistance,
        if (totalEnergyBurned != null) 'totalEnergyBurned': totalEnergyBurned,
      },
    };
  }

  /// Returns the duration of the workout.
  Duration get duration => dateTo.difference(dateFrom);
}
