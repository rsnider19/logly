import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';

/// Question content for selecting motivations (multiselect).
class MotivationsQuestionContent extends ConsumerWidget {
  const MotivationsQuestionContent({super.key});

  static const _options = [
    'Build healthy habits',
    'Track my fitness progress',
    'Stay accountable',
    'Improve my wellness',
    'Explore new activities',
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
          ..._options.map((option) {
            final value = option.toLowerCase().replaceAll(' ', '_');
            return CheckboxListTile(
              title: Text(option),
              value: selected.contains(value),
              onChanged: (_) {
                ref.read(onboardingAnswersStateProvider.notifier).toggleMotivation(value);
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
        ],
      ),
    );
  }
}
