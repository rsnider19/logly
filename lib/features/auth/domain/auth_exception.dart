import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for authentication-related errors.
abstract class AuthException extends AppException {
  const AuthException(super.message, [super.technicalDetails]);
}

/// Thrown when the user cancels the sign-in process.
class AuthSignInCancelledException extends AuthException {
  const AuthSignInCancelledException() : super('Sign-in was cancelled', 'User cancelled authentication flow');
}

/// Thrown when there's a network issue during authentication.
class AuthNetworkException extends AuthException {
  const AuthNetworkException([String? technicalDetails])
    : super('Unable to connect. Please check your internet connection.', technicalDetails);
}

/// Thrown when the authentication provider returns an error.
class AuthProviderException extends AuthException {
  const AuthProviderException(super.message, [super.technicalDetails]);
}

/// Thrown when account deletion fails.
class AuthDeletionException extends AuthException {
  const AuthDeletionException([String? technicalDetails])
    : super('Failed to delete account. Please try again.', technicalDetails);
}
