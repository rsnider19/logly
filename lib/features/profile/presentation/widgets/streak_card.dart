import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/profile/presentation/providers/consistency_provider.dart';
import 'package:logly/features/profile/presentation/providers/streak_provider.dart';
import 'package:logly/widgets/skeleton_loader.dart';

/// Card displaying current and longest streak information.
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(streakProvider);
    final consistencyAsync = ref.watch(consistencyScoreProvider);

    if (streakAsync is AsyncError) {
      return _StreakError(onRetry: () => ref.invalidate(streakProvider));
    }
    if (consistencyAsync is AsyncError) {
      return _StreakError(onRetry: () => ref.invalidate(consistencyScoreProvider));
    }

    final isLoading = streakAsync is! AsyncData || consistencyAsync is! AsyncData;

    return SkellyWrapper(
      isLoading: isLoading,
      child: _StreakContent(
        currentStreak: streakAsync.value?.currentStreak ?? 0,
        longestStreak: streakAsync.value?.longestStreak ?? 0,
        consistencyScore: consistencyAsync.value ?? 0,
      ),
    );
  }
}

class _StreakContent extends StatefulWidget {
  const _StreakContent({
    required this.currentStreak,
    required this.longestStreak,
    required this.consistencyScore,
  });

  final int currentStreak;
  final int longestStreak;
  final int consistencyScore;

  @override
  State<_StreakContent> createState() => _StreakContentState();
}

class _StreakContentState extends State<_StreakContent> {
  final autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StreakStatBox(
            label: 'Current',
            value: widget.currentStreak,
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            autoSizeGroup: autoSizeGroup,
            placeholderText: '888',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StreakStatBox(
            label: 'Longest',
            value: widget.longestStreak,
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
            autoSizeGroup: autoSizeGroup,
            placeholderText: '888',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StreakStatBox(
            label: 'Consistency',
            value: widget.consistencyScore,
            icon: Icons.show_chart,
            iconColor: Colors.teal,
            suffix: '%',
            autoSizeGroup: autoSizeGroup,
            placeholderText: '88%',
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
  });

  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  final String? suffix;
  final AutoSizeGroup autoSizeGroup;
  final String placeholderText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayValue = suffix != null ? '$value$suffix' : '$value';
    final displayLabel = suffix != null ? label : '$label days';

    return Card.outlined(
      child: Padding(
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
    );
  }
}

class _StreakError extends StatelessWidget {
  const _StreakError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card.outlined(
      child: Padding(
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
      ),
    );
  }
}
