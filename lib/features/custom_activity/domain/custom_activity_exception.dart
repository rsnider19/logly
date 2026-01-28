import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for custom activity-related errors.
abstract class CustomActivityException extends AppException {
  const CustomActivityException(super.message, [super.technicalDetails]);
}

/// Thrown when creating a custom activity fails.
class CreateCustomActivityException extends CustomActivityException {
  const CreateCustomActivityException([String? technicalDetails])
      : super('Unable to create activity. Please try again.', technicalDetails);
}

/// Thrown when validation fails for custom activity creation.
class CustomActivityValidationException extends CustomActivityException {
  const CustomActivityValidationException(super.message, [super.technicalDetails]);
}

/// Thrown when checking for duplicate activity names fails.
class CheckActivityNameException extends CustomActivityException {
  const CheckActivityNameException([String? technicalDetails])
      : super('Unable to validate activity name. Please try again.', technicalDetails);
}

/// Thrown when activity name is already taken by another custom activity.
class ActivityNameTakenException extends CustomActivityException {
  const ActivityNameTakenException(String name)
      : super('You already have a custom activity named "$name".');
}
