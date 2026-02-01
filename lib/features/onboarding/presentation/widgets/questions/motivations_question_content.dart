import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';

/// Question content for selecting motivations (multiselect).
class MotivationsQuestionContent extends ConsumerWidget {
  const MotivationsQuestionContent({super.key});

  static const _options = [
    ('💪', 'Improve my fitness'),
    ('🧠', 'Feel better mentally'),
    ('😴', 'Improve sleep & recovery'),
    ('🔁', 'Be more consistent with habits'),
    ('🔍', 'Understand patterns in my life'),
    ('📊', 'Track health metrics'),
    ('🧘', 'Reduce stress'),
    ('🤝', 'Stay accountable'),
    ('🤖', 'Use AI to get insights'),
    ('📦', 'Just want everything in one place'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final answers = ref.watch(onboardingAnswersStateProvider);
    final selected = answers.motivations;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'What brought you here?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select all that apply.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _options.map((option) {
                  final (emoji, label) = option;
                  final value = label.toLowerCase().replaceAll(' ', '_');
                  final isSelected = selected.contains(value);
                  return SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 48 - 12) / 2,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(onboardingAnswersStateProvider.notifier).toggleMotivation(value);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              '$label\n',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.surface
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
