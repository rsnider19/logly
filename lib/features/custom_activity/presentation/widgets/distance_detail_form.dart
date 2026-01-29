import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';

/// Form fields for configuring a Distance detail.
class DistanceDetailForm extends ConsumerWidget {
  const DistanceDetailForm({
    required this.config,
    required this.onLabelChanged,
    required this.onIsShortChanged,
    required this.onMaxValueChanged,
    required this.onUseForPaceChanged,
    this.paceEnabled = true,
    super.key,
  });

  final DistanceDetailConfig config;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<bool> onIsShortChanged;
  final ValueChanged<double> onMaxValueChanged;
  final ValueChanged<bool> onUseForPaceChanged;
  final bool paceEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final preferencesAsync = ref.watch(preferencesStateProvider);
    final isImperial = switch (preferencesAsync) {
      AsyncData(:final value) => value.unitSystem == UnitSystem.imperial,
      _ => false,
    };
    final shortUnit = isImperial ? 'yd' : 'm';
    final longUnit = isImperial ? 'mi' : 'km';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label input
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Label', style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: config.labelPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                onChanged: onLabelChanged,
                controller: TextEditingController(text: config.label)
                  ..selection = TextSelection.collapsed(offset: config.label.length),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Short/Long toggle (full width, no label)
        CupertinoSlidingSegmentedControl<bool>(
          groupValue: config.isShort,
          children: {
            true: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Short ($shortUnit)'),
            ),
            false: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Long ($longUnit)'),
            ),
          },
          onValueChanged: (value) {
            if (value != null) {
              onIsShortChanged(value);
            }
          },
        ),
        const SizedBox(height: 16),

        // Max value input
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Maximum', style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  suffixText: config.isShort ? shortUnit : longUnit,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    onMaxValueChanged(parsed);
                  }
                },
                controller: TextEditingController(text: config.maxValue.toString())
                  ..selection = TextSelection.collapsed(offset: config.maxValue.toString().length),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Use for pace calculation toggle
        if (paceEnabled)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Use for pace', style: theme.textTheme.bodyMedium),
              Switch(
                value: config.useForPace,
                onChanged: onUseForPaceChanged,
              ),
            ],
          ),
      ],
    );
  }
}
