import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/widgets/skeleton_loader.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Card displaying current and longest streak information.
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider);

    if (statsAsync is AsyncError) {
      return _StreakError(onRetry: () => ref.invalidate(userStatsProvider));
    }

    final isLoading = statsAsync is! AsyncData;

    return SkellyWrapper(
      isLoading: isLoading,
      child: _StreakContent(
        currentStreak: statsAsync.value?.currentStreak ?? 0,
        longestStreak: statsAsync.value?.longestStreak ?? 0,
        consistencyScore: statsAsync.value?.consistencyPct ?? 0,
      ),
    );
  }
}

class _StreakContent extends ConsumerStatefulWidget {
  const _StreakContent({
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyScore,
  });

  final int currentStreak;
  final int longestStreak;
  final double consistencyScore;

  @override
  ConsumerState<_StreakContent> createState() => _StreakContentState();
}

class _StreakContentState extends ConsumerState<_StreakContent> {
  final autoSizeGroup = AutoSizeGroup();

  void _showConsistencyInfo(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.chartLine, color: Colors.teal, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Consistency Score',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Your consistency score shows the percentage of days you logged at least one activity over the '
                'last 30 days.\n\n'
                "It's not about being perfect every single day — it's about showing up regularly. "
                'Even small efforts count!\n\n'
                'Keep building your routine and watch this number grow. '
                "You're doing great just by tracking your progress.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analyticsService = ref.read(analyticsServiceProvider);

    return Row(
      children: [
        Expanded(
          child: _StreakStatBox(
            label: 'Current',
            value: widget.currentStreak,
            icon: LucideIcons.flame,
            iconColor: Colors.orange,
            autoSizeGroup: autoSizeGroup,
            placeholderText: '8888',
            onTap: () => analyticsService.trackStreakCardTapped(cardType: 'current'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StreakStatBox(
            label: 'Longest',
            value: widget.longestStreak,
            icon: LucideIcons.trophy,
            iconColor: Colors.amber,
            autoSizeGroup: autoSizeGroup,
            placeholderText: '8888',
            onTap: () => analyticsService.trackStreakCardTapped(cardType: 'longest'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StreakStatBox(
            label: 'Consistency',
            value: widget.consistencyScore.round(),
            icon: LucideIcons.chartLine,
            iconColor: Colors.teal,
            suffix: '%',
            autoSizeGroup: autoSizeGroup,
            placeholderText: '888%',
            showInfoIcon: true,
            onTap: () {
              analyticsService.trackStreakCardTapped(cardType: 'consistency');
              _showConsistencyInfo(context);
            },
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
    required this.autoSizeGroup,
    required this.placeholderText,
    this.suffix,
    this.showInfoIcon = false,
    this.onTap,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  final String? suffix;
  final AutoSizeGroup autoSizeGroup;
  final String placeholderText;
  final bool showInfoIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = suffix != null ? '$value$suffix' : '$value';
    final displayLabel = suffix != null ? label : '$label days';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(icon, color: iconColor, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    displayValue,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: [
                        const FontFeature.tabularFigures(),
                      ],
                    ),
                  ).withSkeleton(placeholderText: placeholderText),
                  AutoSizeText(
                    displayLabel,
                    maxLines: 1,
                    group: autoSizeGroup,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (showInfoIcon)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  LucideIcons.info,
                  size: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              LucideIcons.circleAlert,
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
      ),
    );
  }
}
