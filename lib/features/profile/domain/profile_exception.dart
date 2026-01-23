import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for profile-related errors.
abstract class ProfileException extends AppException {
  const ProfileException(super.message, [super.technicalDetails]);
}

/// Thrown when fetching streak data fails.
class FetchStreakException extends ProfileException {
  const FetchStreakException([String? technicalDetails])
      : super('Unable to load streak data. Please try again.', technicalDetails);
}

/// Thrown when fetching category summary fails.
class FetchSummaryException extends ProfileException {
  const FetchSummaryException([String? technicalDetails])
      : super('Unable to load activity summary. Please try again.', technicalDetails);
}

/// Thrown when fetching contribution data fails.
class FetchContributionException extends ProfileException {
  const FetchContributionException([String? technicalDetails])
      : super('Unable to load contribution data. Please try again.', technicalDetails);
}

/// Thrown when fetching monthly data fails.
class FetchMonthlyDataException extends ProfileException {
  const FetchMonthlyDataException([String? technicalDetails])
      : super('Unable to load monthly data. Please try again.', technicalDetails);
}

/// Thrown when fetching daily activity counts fails.
class FetchDailyCountsException extends ProfileException {
  const FetchDailyCountsException([String? technicalDetails])
      : super('Unable to load activity data. Please try again.', technicalDetails);
}
