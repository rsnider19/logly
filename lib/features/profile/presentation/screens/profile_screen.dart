import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_graph.dart';
import 'package:logly/features/profile/presentation/widgets/monthly_chart.dart';
import 'package:logly/features/profile/presentation/widgets/streak_card.dart';
import 'package:logly/features/profile/presentation/widgets/summary_card.dart';
import 'package:logly/features/profile/presentation/widgets/weekly_radar_chart.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User info header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

String _formatMemberSince(String createdAt) {
  final date = DateTime.parse(createdAt);
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}
