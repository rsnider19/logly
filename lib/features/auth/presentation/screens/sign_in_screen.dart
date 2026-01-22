import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/auth/domain/auth_exception.dart' as app_auth;
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:logly/features/auth/presentation/widgets/apple_sign_in_button.dart';
import 'package:logly/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Sign-in screen with Apple and Google authentication options.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _isAppleLoading = false;
  bool _isGoogleLoading = false;

  bool get _isLoading => _isAppleLoading || _isGoogleLoading;

  Future<void> _signInWithApple() async {
    setState(() => _isAppleLoading = true);

    try {
      await ref.read(authServiceProvider).signInWithApple();
      // Navigation handled by router redirect
    } on app_auth.AuthSignInCancelledException {
      // User cancelled - don't show error
    } on app_auth.AuthException catch (e) {
      if (mounted) {
        _showError(e.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isAppleLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);

    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      // Navigation handled by router redirect
    } on app_auth.AuthSignInCancelledException {
      // User cancelled - don't show error
    } on app_auth.AuthException catch (e) {
      if (mounted) {
        _showError(e.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showAppleButton = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // App branding
              Icon(
                Icons.track_changes,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Logly',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your activities, build habits',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Sign-in buttons
              if (showAppleButton) ...[
                AppleSignInButton(
                  onPressed: _isLoading ? null : _signInWithApple,
                  isLoading: _isAppleLoading,
                ),
                const SizedBox(height: 12),
              ],
              GoogleSignInButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                isLoading: _isGoogleLoading,
              ),
              const Spacer(),
              // Terms and privacy
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      const TextSpan(text: 'By signing in, you agree to our '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _openUrl('https://logly.app/terms'),
                          child: Text(
                            'Terms of Service',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => _openUrl('https://logly.app/privacy'),
                          child: Text(
                            'Privacy Policy',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
