import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for activity logging-related errors.
abstract class ActivityLoggingException extends AppException {
  const ActivityLoggingException(super.message, [super.technicalDetails]);
}

/// Thrown when logging an activity fails.
class LogActivityException extends ActivityLoggingException {
  const LogActivityException([String? technicalDetails])
      : super('Unable to log activity. Please try again.', technicalDetails);
}

/// Thrown when updating a logged activity fails.
class UpdateActivityException extends ActivityLoggingException {
  const UpdateActivityException([String? technicalDetails])
      : super('Unable to update activity. Please try again.', technicalDetails);
}

/// Thrown when deleting a logged activity fails.
class DeleteActivityException extends ActivityLoggingException {
  const DeleteActivityException([String? technicalDetails])
      : super('Unable to delete activity. Please try again.', technicalDetails);
}

/// Thrown when fetching user activities fails.
class FetchUserActivitiesException extends ActivityLoggingException {
  const FetchUserActivitiesException([String? technicalDetails])
      : super('Unable to load activities. Please try again.', technicalDetails);
}

/// Thrown when a user activity is not found.
class UserActivityNotFoundException extends ActivityLoggingException {
  const UserActivityNotFoundException([String? technicalDetails])
      : super('Activity not found.', technicalDetails);
}

/// Thrown when toggling favorite status fails.
class FavoriteToggleException extends ActivityLoggingException {
  const FavoriteToggleException([String? technicalDetails])
      : super('Unable to update favorite. Please try again.', technicalDetails);
}

/// Thrown when fetching favorites fails.
class FetchFavoritesException extends ActivityLoggingException {
  const FetchFavoritesException([String? technicalDetails])
      : super('Unable to load favorites. Please try again.', technicalDetails);
}

/// Thrown when validation fails for activity logging.
class ActivityLoggingValidationException extends ActivityLoggingException {
  const ActivityLoggingValidationException(super.message, [super.technicalDetails]);
}
