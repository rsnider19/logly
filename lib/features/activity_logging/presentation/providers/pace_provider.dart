import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pace_provider.g.dart';

/// Result of a pace calculation.
class PaceResult {
  const PaceResult({
    required this.paceValue,
    required this.paceUnit,
    required this.formattedPace,
  });

  /// The pace value (e.g., 8.5 for 8:30 min/mile).
  final double paceValue;

  /// The unit description (e.g., "min/mile", "min/km").
  final String paceUnit;

  /// Human-readable formatted pace (e.g., "8:30 min/mile").
  final String formattedPace;
}

/// Calculates pace based on duration and distance.
///
/// Parameters:
/// - [durationInSeconds]: Total duration in seconds
/// - [distanceInMeters]: Total distance in meters
/// - [paceType]: The type of pace calculation to perform
/// - [isMetric]: Whether to use metric units (km) or imperial (miles)
@riverpod
PaceResult? calculatePace(
  Ref ref, {
  required int? durationInSeconds,
  required double? distanceInMeters,
  required PaceType? paceType,
  required bool isMetric,
}) {
  if (paceType == null) return null;

  final paceUnit = _paceUnit(paceType, isMetric: isMetric);

  // Show zero pace when either input is missing or zero
  if (durationInSeconds == null ||
      durationInSeconds <= 0 ||
      distanceInMeters == null ||
      distanceInMeters <= 0) {
    final formatted = paceType == PaceType.floorsPerMinute
        ? '0.0 $paceUnit'
        : '${_formatMinutes(0)} $paceUnit';
    return PaceResult(
      paceValue: 0,
      paceUnit: paceUnit,
      formattedPace: formatted,
    );
  }

  final durationMinutes = durationInSeconds / 60.0;

  switch (paceType) {
    case PaceType.minutesPerUom:
      // Standard pace: min/mile or min/km
      final distanceInUnits = isMetric ? distanceInMeters / 1000.0 : distanceInMeters / 1609.344;

      final paceValue = durationMinutes / distanceInUnits;

      return PaceResult(
        paceValue: paceValue,
        paceUnit: paceUnit,
        formattedPace: '${_formatMinutes(paceValue)} $paceUnit',
      );

    case PaceType.minutesPer100Uom:
      // Swimming pace: min/100m or min/100yd
      final distancePer100 = isMetric ? distanceInMeters / 100.0 : distanceInMeters / 91.44; // 100 yards in meters

      final paceValue = durationMinutes / distancePer100;

      return PaceResult(
        paceValue: paceValue,
        paceUnit: paceUnit,
        formattedPace: '${_formatMinutes(paceValue)} $paceUnit',
      );

    case PaceType.minutesPer500m:
      // Rowing pace: min/500m (always metric)
      final distancePer500 = distanceInMeters / 500.0;

      final paceValue = durationMinutes / distancePer500;

      return PaceResult(
        paceValue: paceValue,
        paceUnit: paceUnit,
        formattedPace: '${_formatMinutes(paceValue)} $paceUnit',
      );

    case PaceType.floorsPerMinute:
      // Stair climbing: floors/min (distance represents floors)
      final paceValue = distanceInMeters / durationMinutes; // distance is floors in this context

      return PaceResult(
        paceValue: paceValue,
        paceUnit: paceUnit,
        formattedPace: '${paceValue.toStringAsFixed(1)} $paceUnit',
      );
  }
}

/// Returns the display unit string for a given [PaceType].
String _paceUnit(PaceType paceType, {required bool isMetric}) {
  return switch (paceType) {
    PaceType.minutesPerUom => isMetric ? 'min/km' : 'min/mile',
    PaceType.minutesPer100Uom => isMetric ? 'min/100m' : 'min/100yd',
    PaceType.minutesPer500m => 'min/500m',
    PaceType.floorsPerMinute => 'floors/min',
  };
}

/// Formats minutes as MM:SS string.
String _formatMinutes(double minutes) {
  final totalSeconds = (minutes * 60).round();
  final mins = totalSeconds ~/ 60;
  final secs = totalSeconds % 60;
  return '$mins:${secs.toString().padLeft(2, '0')}';
}

/// Calculates speed based on duration and distance.
///
/// Returns speed in km/h or mph depending on [isMetric].
@riverpod
double? calculateSpeed(
  Ref ref, {
  required int? durationInSeconds,
  required double? distanceInMeters,
  required bool isMetric,
}) {
  if (durationInSeconds == null || durationInSeconds <= 0 || distanceInMeters == null || distanceInMeters <= 0) {
    return null;
  }

  final durationHours = durationInSeconds / 3600.0;
  final distanceInUnits = isMetric ? distanceInMeters / 1000.0 : distanceInMeters / 1609.344;

  return distanceInUnits / durationHours;
}
