import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';

/// Question content for selecting measurement units.
class UnitsQuestionContent extends ConsumerWidget {
  const UnitsQuestionContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final answers = ref.watch(onboardingAnswersStateProvider);
    final selected = answers.unitSystem;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Which measurement system do you prefer?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll use this for displaying distances and weights.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          RadioListTile<String>(
            title: const Text('Imperial'),
            subtitle: const Text('miles, pounds, feet'),
            value: 'imperial',
            groupValue: selected,
            onChanged: (value) {
              ref.read(onboardingAnswersStateProvider.notifier).setUnitSystem(value);
            },
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile<String>(
            title: const Text('Metric'),
            subtitle: const Text('kilometers, kilograms, meters'),
            value: 'metric',
            groupValue: selected,
            onChanged: (value) {
              ref.read(onboardingAnswersStateProvider.notifier).setUnitSystem(value);
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
