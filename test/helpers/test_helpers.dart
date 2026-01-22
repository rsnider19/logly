import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Sets up test environment variables.
///
/// Use this in setUp() for tests that require environment configuration.
void setUpTestEnv({
  String? supabaseUrl,
  String? supabaseAnonKey,
}) {
  dotenv.loadFromString(
    envString: '''
SUPABASE_URL=${supabaseUrl ?? 'https://test.supabase.co'}
SUPABASE_ANON_KEY=${supabaseAnonKey ?? 'test-anon-key'}
''',
  );
}

/// Clears test environment variables.
///
/// Use this in tearDown() to ensure a clean state between tests.
void clearTestEnv() {
  dotenv.clean();
}
