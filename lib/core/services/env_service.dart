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

  /// Loads the environment file for the given flavor.
  static Future<void> load(String envPath) async {
    await dotenv.load(fileName: envPath);
  }
}
