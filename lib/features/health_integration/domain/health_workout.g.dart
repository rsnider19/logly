// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthWorkout _$HealthWorkoutFromJson(Map<String, dynamic> json) =>
    _HealthWorkout(
      sourceId: json['source_id'] as String,
      workoutActivityType: json['workout_activity_type'] as String,
      dateFrom: DateTime.parse(json['date_from'] as String),
      dateTo: DateTime.parse(json['date_to'] as String),
      totalDistance: (json['total_distance'] as num?)?.toDouble(),
      totalDistanceUnit: json['total_distance_unit'] as String?,
      totalEnergyBurned: (json['total_energy_burned'] as num?)?.toDouble(),
      totalEnergyUnit: json['total_energy_unit'] as String?,
    );

Map<String, dynamic> _$HealthWorkoutToJson(_HealthWorkout instance) =>
    <String, dynamic>{
      'source_id': instance.sourceId,
      'workout_activity_type': instance.workoutActivityType,
      'date_from': instance.dateFrom.toIso8601String(),
      'date_to': instance.dateTo.toIso8601String(),
      'total_distance': instance.totalDistance,
      'total_distance_unit': instance.totalDistanceUnit,
      'total_energy_burned': instance.totalEnergyBurned,
      'total_energy_unit': instance.totalEnergyUnit,
    };
