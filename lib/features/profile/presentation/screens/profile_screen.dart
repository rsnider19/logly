import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
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

/// Profile screen displaying user stats, graphs, and achievements.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      floatingActionButton: _InsightsFab(),
      body: CustomScrollView(
        slivers: [
          // App bar scrolls away with content
          SliverAppBar(
            title: Text(
              'Profile',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.settings),
                tooltip: 'Settings',
                onPressed: () => context.go('/settings'),
              ),
            ],
          ),

          // Filter bar pins to top when app bar scrolls away
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterBarDelegate(theme: theme, topPadding: topPadding),
          ),

          // Content sections
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                              LucideIcons.user,
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

                const SizedBox(height: 16),

                // Streak card (unaffected by filters)
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
                const SizedBox(height: 56),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

/// Persistent header delegate for the pinned filter bar.
class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  _FilterBarDelegate({required this.theme, required this.topPadding});

  final ThemeData theme;
  final double topPadding;

  // Category icons row (~48) + spacing (8) + filter chips row (~40) + padding (16+8)
  static const double _contentExtent = 120;

  double get _extent => _contentExtent + topPadding;

  @override
  double get maxExtent => _extent;

  @override
  double get minExtent => _extent;

  @override
  bool shouldRebuild(covariant _FilterBarDelegate oldDelegate) =>
      topPadding != oldDelegate.topPadding;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(16, 8 + topPadding, 16, 8),
      child: const ProfileFilterBar(),
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
      icon: const Icon(LucideIcons.sparkles, size: 20),
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
