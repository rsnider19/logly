import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for location-related errors.
abstract class LocationException extends AppException {
  const LocationException(super.message, [super.technicalDetails]);
}

/// Thrown when GPS location fetch fails.
class GpsLocationException extends LocationException {
  const GpsLocationException([String? technicalDetails])
      : super(
          'Unable to get your current location. Please try again.',
          technicalDetails,
        );
}

/// Thrown when Google Places API search fails.
class PlacesSearchException extends LocationException {
  const PlacesSearchException([String? technicalDetails])
      : super(
          'Unable to search for places. Please check your connection and try again.',
          technicalDetails,
        );
}

/// Thrown when saving a location to the database fails.
class SaveLocationException extends LocationException {
  const SaveLocationException([String? technicalDetails])
      : super(
          'Unable to save location. Please try again.',
          technicalDetails,
        );
}

/// Thrown when location permission is denied.
class LocationPermissionDeniedException extends LocationException {
  const LocationPermissionDeniedException()
      : super('Location permission is required to use this feature.');
}

/// Thrown when location services are disabled on the device.
class LocationServicesDisabledException extends LocationException {
  const LocationServicesDisabledException()
      : super('Please enable location services in your device settings.');
}
