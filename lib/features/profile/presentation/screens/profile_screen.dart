import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_graph.dart';
import 'package:logly/features/profile/presentation/widgets/monthly_chart.dart';
import 'package:logly/features/profile/presentation/widgets/streak_card.dart';
import 'package:logly/features/profile/presentation/widgets/summary_card.dart';

/// Profile screen displaying user stats, graphs, and achievements.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                ],
              ),
            ),

            // Streak card
            const StreakCard(),

            // Summary card with time period filter
            const SummaryCard(),

            // Contribution graph (GitHub-style)
            const ContributionCard(),

            // Monthly chart (12 month stacked bars)
            const MonthlyChartCard(),

            // Sign out button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isSigningOut ? null : _signOut,
                  icon: _isSigningOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: Text(_isSigningOut ? 'Signing out...' : 'Sign Out'),
                ),
              ),
            ),

            // Bottom padding for safe area
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
