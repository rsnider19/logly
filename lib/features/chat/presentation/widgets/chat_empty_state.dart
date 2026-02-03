import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/chat/presentation/providers/chat_starter_prompts_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Welcome screen shown when the chat has no messages.
///
/// Displays the LoglyAI branding and tappable suggestion
/// chips that send a pre-defined question when tapped.
/// Prompts are fetched dynamically from Supabase.
class ChatEmptyState extends ConsumerWidget {
  const ChatEmptyState({required this.onSuggestionTap, super.key});

  /// Called with the suggestion text when the user taps a chip.
  final void Function(String question) onSuggestionTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final promptsAsync = ref.watch(chatStarterPromptsProvider);

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
                ...promptsAsync.when(
                  data: (prompts) => prompts
                      .map(
                        (prompt) => _SuggestionChip(
                          label: prompt,
                          onTap: () => onSuggestionTap(prompt),
                        ),
                      )
                      .toList(),
                  loading: () => [
                    // Show shimmer placeholder chips during loading
                    for (int i = 0; i < 3; i++) const _ShimmerChip(),
                  ],
                  error: (_, _) => [
                    // Fallback to static prompt on error (provider already has fallback, but defensive)
                    _SuggestionChip(
                      label: 'What did I do this week?',
                      onTap: () => onSuggestionTap('What did I do this week?'),
                    ),
                  ],
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

/// Shimmer placeholder chip shown while loading prompts.
class _ShimmerChip extends StatelessWidget {
  const _ShimmerChip();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 180,
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
