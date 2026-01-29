import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_graph.dart';
import 'package:logly/features/profile/presentation/widgets/monthly_chart.dart';
import 'package:logly/features/profile/presentation/widgets/streak_card.dart';
import 'package:logly/features/profile/presentation/widgets/summary_card.dart';
import 'package:logly/features/profile/presentation/widgets/weekly_radar_chart.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/subscription_service_provider.dart';
import 'package:logly/features/subscriptions/presentation/widgets/pro_badge.dart';

/// Profile screen displaying user stats, graphs, and achievements.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        showTrendingButton: false,
      ),
      floatingActionButton: _InsightsFab(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            // User info header
            Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: user?.userMetadata?['avatar_url'] != null
                      ? NetworkImage(user!.userMetadata!['avatar_url'] as String)
                      : null,
                  child: user?.userMetadata?['avatar_url'] == null
                      ? Icon(
                          Icons.person,
                          size: 48,
                          color: theme.colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                if (user?.email != null)
                  Text(
                    user!.email!,
                    style: theme.textTheme.titleMedium,
                  ),
                if (user?.createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Member since ${_formatMemberSince(user!.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),

            // Streak card
            const StreakCard(),

            // Summary card with time period filter
            const SummaryCard(),

            // Contribution graph (GitHub-style)
            const ContributionCard(),

            // Weekly radar chart (activity by day of week)
            const WeeklyRadarChartCard(),

            // Monthly chart (12 month stacked bars)
            const MonthlyChartCard(),

            // Bottom padding for safe area
            const SizedBox(height: 56),
          ],
        ),
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
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('LoglyAI'),
          ProBadge(feature: FeatureCode.aiInsights),
        ],
      ),
      icon: const Icon(Icons.auto_awesome_rounded),
    );
  }

  Future<void> _onPressed(BuildContext context, WidgetRef ref, bool hasAccess) async {
    if (hasAccess) {
      // Navigate to AI Insights screen (not yet implemented)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('AI Insights coming soon!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
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

String _formatMemberSince(String createdAt) {
  final date = DateTime.parse(createdAt);
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}
