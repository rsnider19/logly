import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Welcome screen shown when the chat has no messages.
///
/// Displays the LoglyAI branding and three tappable suggestion
/// chips that send a pre-defined question when tapped.
class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({required this.onSuggestionTap, super.key});

  /// Called with the suggestion text when the user taps a chip.
  final void Function(String question) onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LoglyAI icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(LucideIcons.sparkles, size: 32, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 16),
            // Welcome title
            Text(
              'LoglyAI',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Welcome subtitle
            Text(
              'Ask me anything about your activities and habits',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Suggestion chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _SuggestionChip(
                  label: 'What did I do this week?',
                  onTap: () => onSuggestionTap('What did I do this week?'),
                ),
                _SuggestionChip(
                  label: 'What are my most consistent habits?',
                  onTap: () => onSuggestionTap('What are my most consistent habits?'),
                ),
                _SuggestionChip(
                  label: 'How active was I last month?',
                  onTap: () => onSuggestionTap('How active was I last month?'),
                ),
              ],
            ),
            // Bottom padding so chips aren't hidden behind composer
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      avatar: const Icon(LucideIcons.messageSquare, size: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
