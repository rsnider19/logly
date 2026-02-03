import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Tappable follow-up question suggestions shown after an AI response.
///
/// Displays 2-3 suggestions as horizontal chips that send the question
/// immediately when tapped. Per user decision:
/// - Chips stay visible while user types
/// - Chips removed when user sends a message (their own or tapping a chip)
class FollowUpChips extends StatelessWidget {
  const FollowUpChips({
    required this.suggestions,
    required this.onTap,
    super.key,
  });

  /// List of follow-up question suggestions (max 3).
  final List<String> suggestions;

  /// Called with the suggestion text when the user taps a chip.
  final void Function(String question) onTap;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Follow up with:',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          runSpacing: 8,
          children: suggestions.take(3).mapIndexed((index, suggestion) {
            return FractionallySizedBox(
              widthFactor: 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == 0 ? 4 : 0,
                  left: index == 1 ? 4 : 0,
                ),
                child: ActionChip(
                  label: Text(
                    '$suggestion\n',
                    style: theme.textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onPressed: () => onTap(suggestion),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  side: BorderSide.none,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
