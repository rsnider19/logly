import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/app/theme/app_theme.dart';
import 'package:logly/core/providers/scaffold_messenger_provider.dart';
import 'package:logly/features/health_integration/application/health_sync_initializer.dart';
import 'package:logly/features/settings/application/notification_service.dart';
import 'package:logly/core/services/sentry_initializer.dart';
import 'package:logly/features/subscriptions/application/subscription_initializer.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize notification service
      ref.read(notificationServiceProvider).initialize();
      // Initialize health sync (auto-syncs after auth if enabled)
      ref.read(healthSyncInitializerProvider).initialize();
      // Initialize subscription listener (syncs RevenueCat with auth state)
      ref.read(subscriptionInitializerProvider).initialize();
      // Initialize Sentry user context (syncs auth state with Sentry)
      ref.read(sentryInitializerProvider).initialize();
    });
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
