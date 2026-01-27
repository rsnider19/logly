import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/router/app_router.dart';
import 'package:logly/features/health_integration/application/health_sync_initializer.dart';
import 'package:logly/features/settings/application/notification_service.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(currentThemeModeProvider);

    return MaterialApp.router(
      title: 'Logly',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        progressIndicatorTheme: Theme.of(context).progressIndicatorTheme.copyWith(
          linearTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(8),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
