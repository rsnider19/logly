/// Base exception class for all app exceptions.
///
/// All feature-specific exceptions should extend this class.
abstract class AppException implements Exception {
  const AppException(this.message, [this.technicalDetails]);

  /// User-facing error message.
  final String message;

  /// Technical details for logging (not shown to users).
  final String? technicalDetails;

  @override
  String toString() => 'AppException: $message${technicalDetails != null ? ' ($technicalDetails)' : ''}';
}

/// Exception thrown when environment configuration is invalid.
class EnvironmentException extends AppException {
  const EnvironmentException(super.message, [super.technicalDetails]);
}
