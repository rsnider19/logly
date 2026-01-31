import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' show DefaultCacheManager;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growthbook_sdk_flutter/growthbook_sdk_flutter.dart';
import 'package:logly/core/providers/growthbook_provider.dart';
import 'package:logly/core/providers/shared_preferences_provider.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/core/services/feature_flag_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bootstraps the application with the given environment path.
///
/// This function:
/// 1. Ensures Flutter is initialized
/// 2. Loads environment variables
/// 3. Initializes Supabase
/// 4. Initializes SharedPreferences
/// 5. Wraps the app in ProviderScope
Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  required String envPath,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Load environment variables
  await EnvService.load(envPath);
  if (kDebugMode) {
    debugPrint('✓ Loaded env from: $envPath');
    debugPrint('✓ Supabase URL: ${EnvService.supabaseUrl}');
  }

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

  // Initialize GrowthBook feature flags
  final packageInfo = await PackageInfo.fromPlatform();
  final environment = envPath.contains('development')
      ? 'development'
      : envPath.contains('staging')
          ? 'staging'
          : 'production';
  final gbSdk = await GBSDKBuilderApp(
    apiKey: EnvService.growthBookClientKey,
    hostURL: 'https://cdn.growthbook.io',
    attributes: FeatureFlagService.buildAnonymousAttributes(
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      environment: environment,
    ),
  ).initialize();
  if (kDebugMode) {
    debugPrint('✓ GrowthBook initialized');
  }

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  if (kDebugMode) {
    debugPrint('✓ SharedPreferences initialized');
  }

  await DefaultCacheManager().emptyCache();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        growthBookProvider.overrideWithValue(gbSdk),
      ],
      child: await builder(),
    ),
  );
}
