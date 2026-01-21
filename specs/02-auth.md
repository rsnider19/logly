# 02 - Authentication

## Overview

Authentication is handled via Supabase Auth with Apple Sign-in and Google Sign-in as the only supported providers. There is no distinction between sign-in and sign-up - new users are automatically created on first authentication.

## Requirements

### Functional Requirements

- [ ] Support Apple Sign-in (iOS and macOS)
- [ ] Support Google Sign-in (all platforms)
- [ ] Automatically create user profile on first sign-in
- [ ] Persist authentication state across app restarts
- [ ] Handle sign-out with state cleanup
- [ ] Implement account deletion with 30-day soft delete
- [ ] Redirect unauthenticated users to sign-in screen

### Non-Functional Requirements

- [ ] Auth state must be reactive (Riverpod stream)
- [ ] Sign-in must complete within 10 seconds
- [ ] Session tokens must be stored securely

## Architecture

### Auth State Management

```dart
@Riverpod(keepAlive: true)
Stream<AuthState> authState(Ref ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
}

@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  return ref.watch(supabaseProvider).auth.currentUser;
}
```

### Sign-in Flow

```
1. User taps "Sign in with Apple/Google"
2. Native auth UI presented
3. Credential returned to app
4. Supabase signInWithIdToken called
5. On success:
   - If new user: profile created via trigger
   - Auth state updates
   - Navigate to home (or onboarding if new)
6. On failure: Show error snackbar
```

### Account Deletion Flow

```
1. User requests deletion in Settings
2. Confirmation dialog shown
3. On confirm:
   - Call soft delete edge function
   - Sign out user
   - Navigate to sign-in screen
4. After 30 days:
   - Cron job anonymizes data
   - User cannot recover account
```

## Components

### Files to Create

```
lib/features/auth/
├── data/
│   └── auth_repository.dart
├── domain/
│   ├── auth_exception.dart
│   └── auth_user.dart
└── presentation/
    ├── screens/
    │   └── sign_in_screen.dart
    ├── widgets/
    │   ├── apple_sign_in_button.dart
    │   └── google_sign_in_button.dart
    └── providers/
        ├── auth_state_provider.dart
        └── auth_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `AuthRepository` | Direct auth operations with Supabase |
| `AuthService` | Business logic for auth flows |
| `AuthException` | Auth-specific exceptions |
| `SignInScreen` | Sign-in UI with provider buttons |

## Data Operations

### Apple Sign-in

```dart
Future<AuthResponse> signInWithApple() async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [AppleIDAuthorizationScopes.email],
  );

  return await _supabase.auth.signInWithIdToken(
    provider: OAuthProvider.apple,
    idToken: credential.identityToken!,
  );
}
```

### Google Sign-in

```dart
Future<AuthResponse> signInWithGoogle() async {
  final googleUser = await GoogleSignIn(
    clientId: Platform.isIOS ? iosClientId : null,
    serverClientId: webClientId,
  ).signIn();

  final googleAuth = await googleUser!.authentication;

  return await _supabase.auth.signInWithIdToken(
    provider: OAuthProvider.google,
    idToken: googleAuth.idToken!,
    accessToken: googleAuth.accessToken,
  );
}
```

### Sign Out

```dart
Future<void> signOut() async {
  await _supabase.auth.signOut();
  // Clear local cache
  await ref.read(appDatabaseProvider).clearAllTables();
}
```

### Account Deletion

```dart
Future<void> requestAccountDeletion() async {
  await _supabase.functions.invoke('soft-delete-account');
  await signOut();
}
```

## Integration Points

- **Core**: Uses Supabase client from core
- **Onboarding**: New users routed to onboarding after first sign-in
- **All Features**: Auth state guards routes and data access
- **Settings**: Account deletion initiated from settings

## Testing Requirements

### Unit Tests

- [ ] AuthRepository methods handle success/failure cases
- [ ] AuthService validates inputs
- [ ] Auth state updates propagate correctly

### Widget Tests

- [ ] Sign-in screen renders both provider buttons
- [ ] Loading state shown during sign-in
- [ ] Error messages display on failure

### Integration Tests

- [ ] Full sign-in flow with mock providers
- [ ] Sign-out clears all local data
- [ ] Route guards redirect correctly

## Success Criteria

- [ ] Apple Sign-in works on iOS
- [ ] Google Sign-in works on all platforms
- [ ] Auth state persists across app restarts
- [ ] Sign-out clears all user data locally
- [ ] Account deletion soft-deletes user
- [ ] Unauthenticated routes redirect to sign-in
- [ ] New users routed to onboarding
- [ ] Existing users routed to home
