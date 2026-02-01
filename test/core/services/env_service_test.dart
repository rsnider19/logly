import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logly/core/exceptions/app_exception.dart';
import 'package:logly/core/services/env_service.dart';

void main() {
  group('EnvService', () {
    setUp(() {
      dotenv.clean();
    });

    tearDown(() {
      dotenv.clean();
    });

    group('supabaseUrl', () {
      test('returns value when set', () {
        dotenv.loadFromString(
          envString: 'SUPABASE_URL=https://test.supabase.co',
        );

        expect(EnvService.supabaseUrl, 'https://test.supabase.co');
      });

      test('throws EnvironmentException when missing', () {
        dotenv.loadFromString(isOptional: true);

        expect(
          () => EnvService.supabaseUrl,
          throwsA(
            isA<EnvironmentException>().having(
              (e) => e.message,
              'message',
              'Supabase URL not configured',
            ),
          ),
        );
      });

      test('throws EnvironmentException when empty', () {
        dotenv.loadFromString(envString: 'SUPABASE_URL=');

        expect(
          () => EnvService.supabaseUrl,
          throwsA(
            isA<EnvironmentException>().having(
              (e) => e.technicalDetails,
              'technicalDetails',
              'SUPABASE_URL is missing from env file',
            ),
          ),
        );
      });
    });

    group('supabaseAnonKey', () {
      test('returns value when set', () {
        dotenv.loadFromString(
          envString: 'SUPABASE_ANON_KEY=test-anon-key-12345',
        );

        expect(EnvService.supabaseAnonKey, 'test-anon-key-12345');
      });

      test('throws EnvironmentException when missing', () {
        dotenv.loadFromString(isOptional: true);

        expect(
          () => EnvService.supabaseAnonKey,
          throwsA(
            isA<EnvironmentException>().having(
              (e) => e.message,
              'message',
              'Supabase key not configured',
            ),
          ),
        );
      });

      test('throws EnvironmentException when empty', () {
        dotenv.loadFromString(envString: 'SUPABASE_ANON_KEY=');

        expect(
          () => EnvService.supabaseAnonKey,
          throwsA(
            isA<EnvironmentException>().having(
              (e) => e.technicalDetails,
              'technicalDetails',
              'SUPABASE_ANON_KEY is missing from env file',
            ),
          ),
        );
      });
    });

    group('multiple values', () {
      test('loads and returns multiple environment values', () {
        dotenv.loadFromString(
          envString: '''
SUPABASE_URL=https://project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9
''',
        );

        expect(EnvService.supabaseUrl, 'https://project.supabase.co');
        expect(
          EnvService.supabaseAnonKey,
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        );
      });
    });
  });
}
