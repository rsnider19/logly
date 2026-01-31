import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' show DefaultCacheManager;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/exceptions/app_exception.dart';
import 'package:logly/core/providers/shared_preferences_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bootstraps the application with the given environment path.
///
/// This function:
/// 1. Ensures Flutter is initialized
/// 2. Loads environment variables
/// 3. Initializes Sentry (non-debug builds with a configured DSN)
/// 4. Initializes Supabase
/// 5. Initializes RevenueCat
/// 6. Initializes SharedPreferences
/// 7. Wraps the app in ProviderScope
Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required String envPath,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables first — needed for Sentry DSN
  await EnvService.load(envPath);
  if (kDebugMode) {
    debugPrint('✓ Loaded env from: $envPath');
    debugPrint('✓ Supabase URL: ${EnvService.supabaseUrl}');
  }

  final sentryDsn = EnvService.sentryDsn;
  final shouldInitSentry = !kDebugMode && sentryDsn != null && sentryDsn.isNotEmpty;

  if (shouldInitSentry) {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn = sentryDsn
          ..environment = EnvService.environment
          ..tracesSampleRate = EnvService.environment == 'production' ? 0.2 : 1.0
          ..sendDefaultPii = false
          ..attachScreenshot = true
          ..attachViewHierarchy = true
          ..enableAutoPerformanceTracing = true
          ..enableUserInteractionTracing = true;

        options.beforeSend = (event, hint) {
          final throwable = event.throwable;
          if (throwable is AppException) {
            return event.copyWith(
              tags: {...?event.tags, 'app_exception_type': throwable.runtimeType.toString()},
              extra: {
                ...?event.extra,
                if (throwable.technicalDetails != null) 'technical_details': throwable.technicalDetails,
              },
            );
          }
          return event;
        };
      },
      appRunner: () async => _initializeAndRun(builder),
    );
  } else {
    // Debug mode or no DSN: use basic error logging, no Sentry
    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };
    await _initializeAndRun(builder);
  }
}

Future<void> _initializeAndRun(FutureOr<Widget> Function() builder) async {
  // Initialize Supabase
  await Supabase.initialize(
    url: EnvService.supabaseUrl,
    anonKey: EnvService.supabaseAnonKey,
  );
  if (kDebugMode) {
    debugPrint('✓ Supabase initialized');
  }

  // Initialize RevenueCat
  await Purchases.configure(PurchasesConfiguration(EnvService.revenueCatApiKey));
  if (kDebugMode) {
    debugPrint('✓ RevenueCat configured');
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  if (kDebugMode) {
    debugPrint('✓ SharedPreferences initialized');
  }

  await DefaultCacheManager().emptyCache();

  if (kDebugMode) {
    debugPrint('✓ Sentry ${Sentry.isEnabled ? "enabled" : "disabled"}');
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: await builder(),
    ),
  );
}
