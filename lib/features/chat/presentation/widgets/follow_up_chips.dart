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

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Continue the conversation:',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.take(3).map((suggestion) {
              return ActionChip(
                label: Text(
                  suggestion,
                  style: theme.textTheme.bodySmall,
                ),
                onPressed: () => onTap(suggestion),
                avatar: Icon(
                  LucideIcons.cornerDownRight,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
