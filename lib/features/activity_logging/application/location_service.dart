import 'package:geolocator/geolocator.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/activity_logging/data/google_places_repository.dart';
import 'package:logly/features/activity_logging/data/location_repository.dart';
import 'package:logly/features/activity_logging/domain/gps_coordinates.dart';
import 'package:logly/features/activity_logging/domain/location.dart';
import 'package:logly/features/activity_logging/domain/location_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Permission status for location services.
enum LocationPermissionStatus {
  /// Permission granted (either whileInUse or always).
  granted,

  /// Permission explicitly denied by user.
  denied,

  /// Permission permanently denied (user selected "Don't ask again").
  deniedForever,

  /// Location services are disabled on the device.
  serviceDisabled,
}

/// Service for coordinating location operations.
///
/// Handles permission management, GPS coordinate fetching, and
/// Google Places API interactions.
class LocationService {
  LocationService(
    this._locationRepository,
    this._placesRepository,
    this._logger,
  );

  final LocationRepository _locationRepository;
  final GooglePlacesRepository _placesRepository;
  final LoggerService _logger;

  // ==================== Permission Management ====================

  /// Checks the current location permission status.
  ///
  /// Also verifies that location services are enabled on the device.
  Future<LocationPermissionStatus> checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    final permission = await Geolocator.checkPermission();
    return _mapPermissionStatus(permission);
  }

  /// Requests location permission from the user.
  ///
  /// Returns the resulting permission status after the request.
  Future<LocationPermissionStatus> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    final permission = await Geolocator.requestPermission();
    _logger.i('Location permission result: $permission');
    return _mapPermissionStatus(permission);
  }

  LocationPermissionStatus _mapPermissionStatus(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse => LocationPermissionStatus.granted,
      LocationPermission.deniedForever => LocationPermissionStatus.deniedForever,
      _ => LocationPermissionStatus.denied,
    };
  }

  // ==================== GPS Operations ====================

  /// Gets the current GPS coordinates.
  ///
  /// Throws [LocationPermissionDeniedException] if permission not granted.
  /// Throws [LocationServicesDisabledException] if services are disabled.
  /// Throws [GpsLocationException] if location fetch fails.
  Future<GpsCoordinates> getCurrentLocation() async {
    try {
      final permission = await checkPermission();

      if (permission == LocationPermissionStatus.serviceDisabled) {
        throw const LocationServicesDisabledException();
      }

      if (permission != LocationPermissionStatus.granted) {
        throw const LocationPermissionDeniedException();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return GpsCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on LocationException {
      rethrow;
    } catch (e, st) {
      _logger.e('Failed to get current location', e, st);
      throw GpsLocationException(e.toString());
    }
  }

  /// Gets current GPS coordinates if permission is granted.
  ///
  /// Returns null if permission is denied or location is unavailable.
  /// This method never throws - it fails silently and returns null.
  Future<GpsCoordinates?> getCurrentLocationIfPermitted() async {
    try {
      final permission = await checkPermission();
      if (permission != LocationPermissionStatus.granted) {
        return null;
      }
      return await getCurrentLocation();
    } catch (e) {
      _logger.w('Could not get location silently: $e');
      return null;
    }
  }

  // ==================== Places Operations ====================

  /// Searches for places using Google Places autocomplete.
  ///
  /// Automatically biases results toward current GPS if permission is granted.
  Future<List<PlacePrediction>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    // Try to get current location for bias (fail silently)
    final bias = await getCurrentLocationIfPermitted();

    return _placesRepository.searchPlaces(query, biasLocation: bias);
  }

  /// Gets place details and saves to the database.
  ///
  /// Fetches full details from Google Places API, then upserts to our
  /// database (shared globally). Returns the Location with all fields populated.
  Future<Location> selectPlace(String placeId) async {
    // Fetch full details from Places API
    final location = await _placesRepository.getPlaceDetails(placeId);

    // Upsert to our database (shared globally)
    return _locationRepository.upsert(location);
  }

  /// Fetches current location and reverse geocodes to a place.
  ///
  /// Returns the nearest Google Place to the user's current GPS coordinates.
  /// Returns null if permission is denied or no place is found nearby.
  Future<Location?> fetchCurrentPlace() async {
    final coords = await getCurrentLocation();

    // Reverse geocode to find nearest place
    final location = await _placesRepository.reverseGeocode(coords);

    if (location != null) {
      // Save to database
      return _locationRepository.upsert(location);
    }

    return null;
  }

  /// Gets a location by ID from the database.
  ///
  /// Returns null if the location doesn't exist.
  Future<Location?> getLocationById(String locationId) async {
    return _locationRepository.getById(locationId);
  }
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) {
  return LocationService(
    ref.watch(locationRepositoryProvider),
    ref.watch(googlePlacesRepositoryProvider),
    ref.watch(loggerProvider),
  );
}
