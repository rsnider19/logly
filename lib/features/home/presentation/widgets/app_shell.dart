import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/home/presentation/providers/daily_activities_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_bottom_nav.dart';
import 'package:logly/features/profile/presentation/providers/activity_counts_provider.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/features/profile/presentation/providers/summary_provider.dart';

/// Shell widget that wraps the main navigation areas with consistent
/// app bar and bottom navigation.
class AppShell extends ConsumerWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, ref, index),
      ),
    );
  }

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    // Refresh data on every tap, whether navigating or re-selecting
    switch (index) {
      case 0:
        // Profile tab — invalidate root profile data providers
        ref.invalidate(activityCountsByDateProvider);
        ref.invalidate(streakProvider);
        ref.invalidate(allPeriodSummariesProvider);
      case 1:
        // Home tab — refresh daily activities
        ref.read(dailyActivitiesStateProvider.notifier).refresh();
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
