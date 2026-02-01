import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';

/// Question content for selecting gender.
class GenderQuestionContent extends ConsumerWidget {
  const GenderQuestionContent({super.key});

  static const _options = ['Male', 'Female', 'Prefer not to say'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final answers = ref.watch(onboardingAnswersStateProvider);
    final selected = answers.gender;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'What is your gender?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us personalize your experience.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ..._options.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option.toLowerCase().replaceAll(' ', '_'),
              groupValue: selected,
              onChanged: (value) {
                ref.read(onboardingAnswersStateProvider.notifier).setGender(value);
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }
}
