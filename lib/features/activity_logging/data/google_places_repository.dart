import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/domain/gps_coordinates.dart';
import 'package:logly/features/activity_logging/domain/location.dart';
import 'package:logly/features/activity_logging/domain/location_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_places_repository.g.dart';

/// A place prediction from Google Places Autocomplete.
class PlacePrediction {
  PlacePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormat = json['structuredFormat'] as Map<String, dynamic>?;
    return PlacePrediction(
      placeId: json['placeId'] as String? ?? json['place'] as String? ?? '',
      mainText:
          structuredFormat?['mainText']?['text'] as String? ??
          json['text']?['text'] as String? ??
          '',
      secondaryText: structuredFormat?['secondaryText']?['text'] as String? ?? '',
    );
  }

  final String placeId;
  final String mainText;
  final String secondaryText;

  /// Display text combining main and secondary text with a middle dot.
  String get displayText => secondaryText.isNotEmpty ? '$mainText \u00b7 $secondaryText' : mainText;
}

/// Repository for Google Places API interactions.
///
/// Uses the Places API (New) for autocomplete and place details.
class GooglePlacesRepository {
  GooglePlacesRepository(this._logger);

  final LoggerService _logger;

  static const String _autocompleteUrl = 'https://places.googleapis.com/v1/places:autocomplete';
  static const String _placeDetailsUrl = 'https://places.googleapis.com/v1/places';
  static const String _nearbySearchUrl = 'https://places.googleapis.com/v1/places:searchNearby';

  static const Duration _timeout = Duration(seconds: 10);

  /// Searches for places using Google Places Autocomplete (New) API.
  ///
  /// [query] - The search text.
  /// [biasLocation] - Optional GPS coordinates to bias results toward.
  ///
  /// Returns up to 5 place predictions.
  Future<List<PlacePrediction>> searchPlaces(
    String query, {
    GpsCoordinates? biasLocation,
  }) async {
    if (query.trim().isEmpty) return [];

    try {
      final body = <String, dynamic>{
        'input': query,
        'languageCode': 'en',
      };

      if (biasLocation != null) {
        body['locationBias'] = {
          'circle': {
            'center': {
              'latitude': biasLocation.latitude,
              'longitude': biasLocation.longitude,
            },
            'radius': 50000.0, // 50km radius bias
          },
        };
      }

      final response = await http
          .post(
            Uri.parse(_autocompleteUrl),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': EnvService.googlePlacesApiKey,
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw PlacesSearchException('API returned ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final suggestions = data['suggestions'] as List? ?? [];

      return suggestions
          .take(5)
          .map((s) {
            final placePrediction = s['placePrediction'] as Map<String, dynamic>?;
            if (placePrediction == null) return null;
            return PlacePrediction.fromJson(placePrediction);
          })
          .whereType<PlacePrediction>()
          .toList();
    } catch (e, st) {
      _logger.e('Failed to search places for query: $query', e, st);
      if (e is PlacesSearchException) rethrow;
      throw PlacesSearchException(e.toString());
    }
  }

  /// Fetches full place details including coordinates.
  ///
  /// [placeId] - The Google place_id to fetch details for.
  Future<Location> getPlaceDetails(String placeId) async {
    try {
      final url = '$_placeDetailsUrl/$placeId';

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'X-Goog-Api-Key': EnvService.googlePlacesApiKey,
              'X-Goog-FieldMask': 'id,displayName,formattedAddress,location',
            },
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw PlacesSearchException('API returned ${response.statusCode}: ${response.body}');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final location = data['location'] as Map<String, dynamic>;
      final displayName = data['displayName'] as Map<String, dynamic>?;

      return Location(
        locationId: placeId,
        lng: (location['longitude'] as num).toDouble(),
        lat: (location['latitude'] as num).toDouble(),
        name: displayName?['text'] as String? ?? 'Unknown',
        address: data['formattedAddress'] as String? ?? '',
      );
    } catch (e, st) {
      _logger.e('Failed to get place details for: $placeId', e, st);
      if (e is PlacesSearchException) rethrow;
      throw PlacesSearchException(e.toString());
    }
  }

  /// Reverse geocodes coordinates to get the nearest place.
  ///
  /// Uses Nearby Search to find the nearest place to the given coordinates.
  /// Returns null if no place is found nearby.
  Future<Location?> reverseGeocode(GpsCoordinates coordinates) async {
    try {
      final body = {
        'locationRestriction': {
          'circle': {
            'center': {
              'latitude': coordinates.latitude,
              'longitude': coordinates.longitude,
            },
            'radius': 100.0, // 100m radius for nearby search
          },
        },
        'maxResultCount': 1,
      };

      final response = await http
          .post(
            Uri.parse(_nearbySearchUrl),
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': EnvService.googlePlacesApiKey,
              'X-Goog-FieldMask': 'places.id,places.displayName,places.formattedAddress,places.location',
            },
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        _logger.w('Reverse geocode failed: ${response.body}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final places = data['places'] as List? ?? [];

      if (places.isEmpty) return null;

      final place = places.first as Map<String, dynamic>;
      final location = place['location'] as Map<String, dynamic>;
      final displayName = place['displayName'] as Map<String, dynamic>?;

      return Location(
        locationId: place['id'] as String,
        lng: (location['longitude'] as num).toDouble(),
        lat: (location['latitude'] as num).toDouble(),
        name: displayName?['text'] as String? ?? 'Unknown',
        address: place['formattedAddress'] as String? ?? '',
      );
    } catch (e, st) {
      _logger.e('Failed to reverse geocode', e, st);
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
GooglePlacesRepository googlePlacesRepository(Ref ref) {
  return GooglePlacesRepository(ref.watch(loggerProvider));
}
