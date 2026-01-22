import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/domain/auth_exception.dart' as app_auth;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

/// Repository for authentication operations with Supabase.
///
/// Handles direct auth operations - no business logic, just data access.
class AuthRepository {
  AuthRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Stream of authentication state changes.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// The currently authenticated user, or null if not authenticated.
  User? get currentUser => _supabase.auth.currentUser;

  /// Signs in with Apple.
  ///
  /// Throws [app_auth.AuthSignInCancelledException] if the user cancels.
  /// Throws [app_auth.AuthProviderException] on other errors.
  Future<AuthResponse> signInWithApple() async {
    try {
      _logger.d('Requesting Apple credential...');
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      _logger.d('Apple credential received, hasIdToken: ${credential.identityToken != null}');

      if (credential.identityToken == null) {
        throw const app_auth.AuthProviderException(
          'Apple sign-in failed',
          'No identity token returned from Apple',
        );
      }

      _logger.d('Calling Supabase signInWithIdToken...');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
      );
      _logger.d('Supabase signInWithIdToken completed, user: ${response.user?.id}');
      return response;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const app_auth.AuthSignInCancelledException();
      }
      _logger.e('Apple sign-in failed (SignInWithAppleAuthorizationException)', e);
      throw app_auth.AuthProviderException('Apple sign-in failed', e.message);
    } on AuthException catch (e) {
      _logger.e('Apple sign-in failed (Supabase AuthException): ${e.message}', e);
      throw app_auth.AuthProviderException('Apple sign-in failed', e.message);
    } on app_auth.AuthException {
      rethrow;
    } catch (e, st) {
      _logger.e('Apple sign-in failed (unknown)', e, st);
      throw app_auth.AuthProviderException('Apple sign-in failed', e.toString());
    }
  }

  /// Signs in with Google.
  ///
  /// Throws [app_auth.AuthSignInCancelledException] if the user cancels.
  /// Throws [app_auth.AuthProviderException] on other errors.
  Future<AuthResponse> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        clientId: Platform.isIOS ? EnvService.googleIosClientId : null,
        serverClientId: EnvService.googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const app_auth.AuthSignInCancelledException();
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        throw const app_auth.AuthProviderException(
          'Google sign-in failed',
          'No ID token returned from Google',
        );
      }

      return await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );
    } on app_auth.AuthSignInCancelledException {
      rethrow;
    } on app_auth.AuthProviderException {
      rethrow;
    } catch (e, st) {
      _logger.e('Google sign-in failed', e, st);
      throw app_auth.AuthProviderException('Google sign-in failed', e.toString());
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e, st) {
      _logger.e('Sign out failed', e, st);
      throw app_auth.AuthProviderException('Sign out failed', e.toString());
    }
  }

  /// Requests account deletion via edge function.
  ///
  /// This initiates a soft delete with a 30-day grace period.
  Future<void> requestAccountDeletion() async {
    try {
      await _supabase.functions.invoke('soft-delete-account');
    } catch (e, st) {
      _logger.e('Account deletion request failed', e, st);
      throw app_auth.AuthDeletionException(e.toString());
    }
  }
}

/// Provides the auth repository instance.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
