import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for home screen-related errors.
abstract class HomeException extends AppException {
  const HomeException(super.message, [super.technicalDetails]);
}

/// Thrown when fetching daily activities fails.
class FetchDailyActivitiesException extends HomeException {
  const FetchDailyActivitiesException([String? technicalDetails])
    : super('Unable to load activities. Please try again.', technicalDetails);
}

/// Thrown when fetching trending activities fails.
class FetchTrendingActivitiesException extends HomeException {
  const FetchTrendingActivitiesException([String? technicalDetails])
    : super('Unable to load trending activities. Please try again.', technicalDetails);
}
