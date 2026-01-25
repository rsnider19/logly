import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/consistency_provider.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';

/// Card displaying current and longest streak information.
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded =
        ref.watch(collapsibleSectionsStateProvider)[ProfileSections.streak] ?? true;
    final streakAsync = ref.watch(streakProvider);
    final consistencyAsync = ref.watch(consistencyScoreProvider);

    return CollapsibleSection(
      title: 'Streak',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.streak),
      child: switch ((streakAsync, consistencyAsync)) {
        (AsyncData(:final value), AsyncData(value: final consistencyScore)) => _StreakContent(
            currentStreak: value.currentStreak,
            longestStreak: value.longestStreak,
            consistencyScore: consistencyScore,
          ),
        (AsyncError(), _) => _StreakError(
            onRetry: () => ref.invalidate(streakProvider),
          ),
        (_, AsyncError()) => _StreakError(
            onRetry: () => ref.invalidate(consistencyScoreProvider),
          ),
        _ => const _StreakContentShimmer(),
      },
    );
  }
}

class _StreakContent extends StatelessWidget {
  const _StreakContent({
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyScore,
  });

  final int currentStreak;
  final int longestStreak;
  final int consistencyScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StreakStatBox(
            label: 'Current',
            value: currentStreak,
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StreakStatBox(
            label: 'Longest',
            value: longestStreak,
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StreakStatBox(
            label: 'Consistency',
            value: consistencyScore,
            icon: Icons.show_chart,
            iconColor: Colors.teal,
            suffix: '%',
          ),
        ),
      ],
    );
  }
}

class _StreakStatBox extends StatelessWidget {
  const _StreakStatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.suffix,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = suffix != null ? '$value$suffix' : '$value';
    final displayLabel = suffix != null ? label : '$label days';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(
            displayValue,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            displayLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakContentShimmer extends StatelessWidget {
  const _StreakContentShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ShimmerBox()),
        const SizedBox(width: 12),
        Expanded(child: _ShimmerBox()),
        const SizedBox(width: 12),
        Expanded(child: _ShimmerBox()),
      ],
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _StreakError extends StatelessWidget {
  const _StreakError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load streak data',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
