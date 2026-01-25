import 'package:flutter/material.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_graph.dart';

/// Legend showing the color scale for the contribution graph.
class ContributionLegend extends StatelessWidget {
  const ContributionLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'Less',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        ...ContributionColors.getLevels(emptyColor: theme.colorScheme.surfaceContainerHighest).map((color) {
          return Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          'More',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
