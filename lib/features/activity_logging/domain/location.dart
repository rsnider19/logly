import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

/// Represents a place from Google Places API.
///
/// Locations are globally shared across all users, using Google's place_id
/// as the unique identifier for deduplication.
@freezed
abstract class Location with _$Location {
  const factory Location({
    /// Google place_id - unique identifier for the location.
    required String locationId,

    /// Longitude coordinate.
    required double lng,

    /// Latitude coordinate.
    required double lat,

    /// Primary name of the place (e.g., "Central Park").
    required String name,

    /// Full formatted address from Google Places.
    required String address,

    /// When this location record was created.
    DateTime? createdAt,
  }) = _Location;

  const Location._();

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(_parseLocationJson(json));

  /// Display string combining name and address.
  String get displayText => '$name, $address';

  /// Short display showing just name and city/region.
  String get shortDisplayText {
    // Try to extract just the city/state from the address
    final parts = address.split(', ');
    if (parts.length >= 2) {
      return '$name \u00b7 ${parts[0]}';
    }
    return name;
  }
}

/// Parses location JSON, handling PostGIS geography format.
Map<String, dynamic> _parseLocationJson(Map<String, dynamic> json) {
  final result = Map<String, dynamic>.from(json);

  // Parse lng_lat from PostGIS format if present
  final lngLat = json['lng_lat'];
  if (lngLat != null) {
    if (lngLat is Map) {
      // GeoJSON format: {"type": "Point", "coordinates": [lng, lat]}
      final coords = lngLat['coordinates'] as List?;
      if (coords != null && coords.length >= 2) {
        result['lng'] = (coords[0] as num).toDouble();
        result['lat'] = (coords[1] as num).toDouble();
      }
    } else if (lngLat is String) {
      // WKT format: "POINT(lng lat)" or "SRID=4326;POINT(lng lat)"
      final match = RegExp(r'POINT\(([^ ]+) ([^)]+)\)').firstMatch(lngLat);
      if (match != null) {
        result['lng'] = double.parse(match.group(1)!);
        result['lat'] = double.parse(match.group(2)!);
      }
    }
  }

  return result;
}
