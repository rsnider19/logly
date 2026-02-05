import 'package:freezed_annotation/freezed_annotation.dart';

part 'gps_coordinates.freezed.dart';
part 'gps_coordinates.g.dart';

/// Represents GPS coordinates for location capture.
///
/// Used for silent GPS capture when logging activities and for
/// biasing Google Places search results.
@freezed
abstract class GpsCoordinates with _$GpsCoordinates {
  const factory GpsCoordinates({
    /// Latitude in decimal degrees.
    required double latitude,

    /// Longitude in decimal degrees.
    required double longitude,
  }) = _GpsCoordinates;

  const GpsCoordinates._();

  factory GpsCoordinates.fromJson(Map<String, dynamic> json) =>
      _$GpsCoordinatesFromJson(json);
}
