import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_state_provider.g.dart';

/// Provides a stream of auth state changes from Supabase.
@Riverpod(keepAlive: true)
Stream<AuthState> authState(Ref ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
}

/// Provides the currently authenticated user, or null if not authenticated.
///
/// This provider rebuilds whenever the auth state changes.
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  // Watch the auth state stream to trigger rebuilds on auth changes
  ref.watch(authStateProvider);
  ref.read(loggerProvider).i('Current user: ${ref.watch(supabaseProvider).auth.currentUser?.id}');
  ref.read(loggerProvider).i('Access Token: ${ref.watch(supabaseProvider).auth.currentSession?.accessToken}');
  return ref.watch(supabaseProvider).auth.currentUser;
}

/// Provides whether the user is currently authenticated.
@riverpod
bool isAuthenticated(Ref ref) {
  return ref.watch(currentUserProvider) != null;
}
