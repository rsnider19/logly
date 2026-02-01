import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for onboarding-related errors.
abstract class OnboardingException extends AppException {
  const OnboardingException(super.message, [super.technicalDetails]);
}

/// Thrown when fetching profile data fails.
class FetchProfileException extends OnboardingException {
  const FetchProfileException([String? technicalDetails])
    : super('Unable to load profile. Please try again.', technicalDetails);
}

/// Thrown when completing onboarding fails.
class CompleteOnboardingException extends OnboardingException {
  const CompleteOnboardingException([String? technicalDetails])
    : super('Unable to complete onboarding. Please try again.', technicalDetails);
}

/// Thrown when saving favorites fails.
class SaveFavoritesException extends OnboardingException {
  const SaveFavoritesException([String? technicalDetails])
    : super('Unable to save favorites. Please try again.', technicalDetails);
}

/// Thrown when requesting health permissions fails.
class HealthPermissionException extends OnboardingException {
  const HealthPermissionException([String? technicalDetails])
    : super('Unable to request health permissions.', technicalDetails);
}
