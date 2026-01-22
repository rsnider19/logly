import 'package:logly/app/database/database_provider.dart';
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/auth/data/auth_repository.dart';
import 'package:logly/features/auth/domain/auth_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_service_provider.g.dart';

/// Service for authentication business logic.
///
/// Coordinates auth operations and manages side effects like clearing local data.
class AuthService {
  AuthService(this._repository, this._ref, this._logger);

  final AuthRepository _repository;
  final Ref _ref;
  final LoggerService _logger;

  /// Signs in with Apple.
  ///
  /// Returns the [AuthResponse] on success.
  /// Throws [AuthSignInCancelledException] if user cancels.
  /// Throws [AuthProviderException] on error.
  Future<AuthResponse> signInWithApple() async {
    _logger.i('Initiating Apple sign-in');
    final response = await _repository.signInWithApple();
    _logger.i('Apple sign-in successful for user: ${response.user?.id}');
    return response;
  }

  /// Signs in with Google.
  ///
  /// Returns the [AuthResponse] on success.
  /// Throws [AuthSignInCancelledException] if user cancels.
  /// Throws [AuthProviderException] on error.
  Future<AuthResponse> signInWithGoogle() async {
    _logger.i('Initiating Google sign-in');
    final response = await _repository.signInWithGoogle();
    _logger.i('Google sign-in successful for user: ${response.user?.id}');
    return response;
  }

  /// Signs out the current user and clears local data.
  Future<void> signOut() async {
    _logger.i('Signing out user');
    await _repository.signOut();

    // Clear local database
    await _ref.read(appDatabaseProvider).clearAllCache();
    _logger.i('Sign out complete, local data cleared');
  }

  /// Requests account deletion and signs out.
  ///
  /// This initiates a 30-day soft delete grace period.
  Future<void> requestAccountDeletion() async {
    _logger.i('Requesting account deletion');
    await _repository.requestAccountDeletion();
    await signOut();
    _logger.i('Account deletion requested, user signed out');
  }
}

/// Provides the auth service instance.
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(
    ref.watch(authRepositoryProvider),
    ref,
    ref.watch(loggerProvider),
  );
}
