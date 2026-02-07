import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/app/theme/app_theme.dart';
import 'package:logly/core/providers/scaffold_messenger_provider.dart';
import 'package:logly/core/services/analytics_initializer.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/core/services/sentry_initializer.dart';
import 'package:logly/features/feature_flags/application/feature_flag_initializer.dart';
import 'package:logly/features/health_integration/application/health_sync_initializer.dart';
import 'package:logly/features/settings/application/notification_service.dart';
import 'package:logly/features/subscriptions/application/subscription_initializer.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  bool _coldStartTracked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize notification service
      ref.read(notificationServiceProvider).initialize();
      // Initialize health sync (auto-syncs after auth if enabled)
      ref.read(healthSyncInitializerProvider).initialize();
      // Initialize subscription listener (syncs RevenueCat with auth state)
      ref.read(subscriptionInitializerProvider).initialize();
      // Initialize Sentry user context (syncs auth state with Sentry)
      ref.read(sentryInitializerProvider).initialize();
      // Initialize feature flag attribute updates (syncs GrowthBook with auth state)
      ref.read(featureFlagInitializerProvider).initialize();
      // Initialize analytics identity sync (syncs Mixpanel with auth state)
      ref.read(analyticsInitializerProvider).initialize();

      // Track cold start
      if (!_coldStartTracked) {
        _coldStartTracked = true;
        ref.read(analyticsServiceProvider).trackAppOpened(source: 'cold_start');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _coldStartTracked) {
      ref.read(analyticsServiceProvider).trackAppOpened(source: 'background');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Logly',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
