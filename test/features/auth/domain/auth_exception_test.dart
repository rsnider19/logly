import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/exceptions/app_exception.dart';
import 'package:logly/features/auth/domain/auth_exception.dart';

void main() {
  group('AuthException', () {
    group('AuthSignInCancelledException', () {
      test('has correct message', () {
        const exception = AuthSignInCancelledException();

        expect(exception.message, 'Sign-in was cancelled');
        expect(exception.technicalDetails, 'User cancelled authentication flow');
      });

      test('extends AuthException and AppException', () {
        const exception = AuthSignInCancelledException();

        expect(exception, isA<AuthException>());
        expect(exception, isA<AppException>());
      });
    });

    group('AuthNetworkException', () {
      test('has correct message', () {
        const exception = AuthNetworkException('Connection timed out');

        expect(
          exception.message,
          'Unable to connect. Please check your internet connection.',
        );
        expect(exception.technicalDetails, 'Connection timed out');
      });

      test('works without technical details', () {
        const exception = AuthNetworkException();

        expect(
          exception.message,
          'Unable to connect. Please check your internet connection.',
        );
        expect(exception.technicalDetails, isNull);
      });
    });

    group('AuthProviderException', () {
      test('has correct message and technical details', () {
        const exception = AuthProviderException(
          'Apple sign-in failed',
          'Invalid identity token',
        );

        expect(exception.message, 'Apple sign-in failed');
        expect(exception.technicalDetails, 'Invalid identity token');
      });

      test('works without technical details', () {
        const exception = AuthProviderException('Google sign-in failed');

        expect(exception.message, 'Google sign-in failed');
        expect(exception.technicalDetails, isNull);
      });
    });

    group('AuthDeletionException', () {
      test('has correct message', () {
        const exception = AuthDeletionException('RPC failed');

        expect(exception.message, 'Failed to delete account. Please try again.');
        expect(exception.technicalDetails, 'RPC failed');
      });

      test('works without technical details', () {
        const exception = AuthDeletionException();

        expect(exception.message, 'Failed to delete account. Please try again.');
        expect(exception.technicalDetails, isNull);
      });
    });
  });
}
