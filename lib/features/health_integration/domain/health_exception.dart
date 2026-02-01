import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for health integration-related errors.
abstract class HealthException extends AppException {
  const HealthException(super.message, [super.technicalDetails]);
}

/// Thrown when the health platform is not available on the device.
class HealthPlatformUnavailableException extends HealthException {
  const HealthPlatformUnavailableException([String? technicalDetails])
    : super('Health platform is not available on this device.', technicalDetails);
}

/// Thrown when fetching workouts from the health platform fails.
class FetchWorkoutsException extends HealthException {
  const FetchWorkoutsException([String? technicalDetails])
    : super('Unable to fetch workouts from health platform.', technicalDetails);
}

/// Thrown when storing external data to Supabase fails.
class StoreExternalDataException extends HealthException {
  const StoreExternalDataException([String? technicalDetails])
    : super('Unable to store workout data. Please try again.', technicalDetails);
}

/// Thrown when updating the last sync date fails.
class UpdateLastSyncException extends HealthException {
  const UpdateLastSyncException([String? technicalDetails])
    : super('Unable to update sync status. Please try again.', technicalDetails);
}
