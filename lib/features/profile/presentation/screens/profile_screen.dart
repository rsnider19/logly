import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_graph.dart';
import 'package:logly/features/profile/presentation/widgets/monthly_chart.dart';
import 'package:logly/features/profile/presentation/widgets/profile_filter_bar.dart';
import 'package:logly/features/profile/presentation/widgets/streak_card.dart';
import 'package:logly/features/profile/presentation/widgets/summary_card.dart';
import 'package:logly/features/profile/presentation/widgets/weekly_radar_chart.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/subscription_service_provider.dart';
import 'package:logly/features/subscriptions/presentation/widgets/pro_badge.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Profile screen displaying user stats, graphs, and achievements.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: _InsightsFab(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Profile',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.settings),
                tooltip: 'Settings',
                onPressed: () => context.go('/settings'),
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(120),
              child: ProfileFilterBar(),
            ),
          ),

          // Content sections
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const StreakCard(),

                const SizedBox(height: 16),

                // Summary card
                const SummaryCard(),

                const SizedBox(height: 16),

                // Contribution graph
                const ContributionCard(),

                const SizedBox(height: 16),

                // Weekly radar chart
                const WeeklyRadarChartCard(),

                const SizedBox(height: 16),

                // Monthly chart
                const MonthlyChartCard(),

                // Bottom padding for safe area + FAB
                const SizedBox(height: 88),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementStateProvider);
    final hasAccess = entitlements.hasFeature(FeatureCode.aiInsights);

    return FloatingActionButton.extended(
      onPressed: () => _onPressed(context, ref, hasAccess),
      label: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('LoglyAI'),
          ProBadge(
            feature: FeatureCode.aiInsights,
            margin: EdgeInsets.only(left: 8),
          ),
        ],
      ),
      icon: const Icon(LucideIcons.sparkles, size: 20),
    );
  }

  Future<void> _onPressed(BuildContext context, WidgetRef ref, bool hasAccess) async {
    if (hasAccess) {
      await const ChatRoute().push<void>(context);
    } else {
      // Show paywall - no manual invalidation needed, StateNotifier listens for updates
      final purchased = await ref.read(subscriptionServiceProvider).showPaywall();
      if (purchased && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to Premium!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
