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

  /// Loads the environment file for the given flavor.
  static Future<void> load(String envPath) async {
    await dotenv.load(fileName: envPath);
  }
}
