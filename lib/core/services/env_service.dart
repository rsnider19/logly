import 'dart:io' show Platform;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logly/core/exceptions/app_exception.dart';

/// Service for accessing environment variables.
///
/// Wraps flutter_dotenv to provide type-safe access to configuration values.
class EnvService {
  const EnvService._();

  /// Supabase project URL.
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      throw const EnvironmentException(
        'Supabase URL not configured',
        'SUPABASE_URL is missing from env file',
      );
    }
    return value;
  }

  /// Supabase anon/publishable key for client-side access.
  static String get supabaseAnonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw const EnvironmentException(
        'Supabase key not configured',
        'SUPABASE_ANON_KEY is missing from env file',
      );
    }
    return value;
  }

  /// Google OAuth web client ID (used as serverClientId).
  static String get googleWebClientId {
    final value = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    if (value == null || value.isEmpty) {
      throw const EnvironmentException(
        'Google Web Client ID not configured',
        'GOOGLE_WEB_CLIENT_ID is missing from env file',
      );
    }
    return value;
  }

  /// Google OAuth iOS client ID.
  static String get googleIosClientId {
    final value = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
    if (value == null || value.isEmpty) {
      throw const EnvironmentException(
        'Google iOS Client ID not configured',
        'GOOGLE_IOS_CLIENT_ID is missing from env file',
      );
    }
    return value;
  }

  /// Google OAuth Android client ID.
  ///
  /// Note: This is not used in code - Android uses package name + SHA-1
  /// fingerprint configured in Google Cloud Console. This getter is for
  /// reference only.
  static String get googleAndroidClientId {
    final value = dotenv.env['GOOGLE_ANDROID_CLIENT_ID'];
    if (value == null || value.isEmpty) {
      throw const EnvironmentException(
        'Google Android Client ID not configured',
        'GOOGLE_ANDROID_CLIENT_ID is missing from env file',
      );
    }
    return value;
  }

  /// RevenueCat API key.
  ///
  /// Uses platform-specific keys (REVENUE_CAT_API_KEY_APPLE / REVENUE_CAT_API_KEY_GOOGLE)
  /// first, falling back to REVENUE_CAT_API_KEY_TEST for development/sandbox.
  static String get revenueCatApiKey {
    final appleKey = dotenv.env['REVENUE_CAT_API_KEY_APPLE'];
    final googleKey = dotenv.env['REVENUE_CAT_API_KEY_GOOGLE'];

    // Use platform-specific production keys first
    if (Platform.isIOS || Platform.isMacOS) {
      if (appleKey != null && appleKey.isNotEmpty) {
        return appleKey;
      }
    } else {
      if (googleKey != null && googleKey.isNotEmpty) {
        return googleKey;
      }
    }

    // Fall back to test key (development/sandbox)
    final testKey = dotenv.env['REVENUE_CAT_API_KEY_TEST'];
    if (testKey != null && testKey.isNotEmpty) {
      return testKey;
    }

    // No key found
    final platform = (Platform.isIOS || Platform.isMacOS) ? 'APPLE' : 'GOOGLE';
    throw EnvironmentException(
      'RevenueCat API key not configured',
      'REVENUE_CAT_API_KEY_$platform is missing from env file',
    );
  }

  /// RevenueCat API key for Apple platforms (production).
  static String? get revenueCatAppleApiKey => dotenv.env['REVENUE_CAT_API_KEY_APPLE'];

  /// RevenueCat API key for Google/Android (production).
  static String? get revenueCatGoogleApiKey => dotenv.env['REVENUE_CAT_API_KEY_GOOGLE'];

  /// Sentry DSN for error reporting.
  ///
  /// Returns null if not configured (e.g., development environment),
  /// which disables Sentry error reporting.
  static String? get sentryDsn {
    final value = dotenv.env['SENTRY_DSN'];
    if (value == null || value.isEmpty) {
      return null;
    }
    return value;
  }

  /// The current environment name derived from the Supabase URL.
  ///
  /// Used for Sentry environment tagging.
  static String get environment {
    final url = dotenv.env['SUPABASE_URL'] ?? '';
    if (url.contains('127.0.0.1') || url.contains('localhost')) {
      return 'development';
    }
    if (url.contains('staging')) {
      return 'staging';
    }
    return 'production';
  }

  /// Loads the environment file for the given flavor.
  static Future<void> load(String envPath) async {
    await dotenv.load(fileName: envPath);
  }
}
