import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// Form fields for configuring a Number detail.
class NumberDetailForm extends StatelessWidget {
  const NumberDetailForm({
    required this.config,
    required this.onLabelChanged,
    required this.onIsIntegerChanged,
    required this.onMaxValueChanged,
    super.key,
  });

  final NumberDetailConfig config;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<bool> onIsIntegerChanged;
  final ValueChanged<double> onMaxValueChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label input
        TextField(
          decoration: InputDecoration(
            labelText: 'Label',
            hintText: config.labelPlaceholder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          onChanged: onLabelChanged,
          controller: TextEditingController(text: config.label)
            ..selection = TextSelection.collapsed(offset: config.label.length),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        // Integer/Decimal toggle
        Text('Number Type', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Integer')),
            ButtonSegment(value: false, label: Text('Decimal')),
          ],
          selected: {config.isInteger},
          onSelectionChanged: (selected) => onIsIntegerChanged(selected.first),
        ),
        const SizedBox(height: 16),

        // Maximum value input
        TextField(
          decoration: InputDecoration(
            labelText: 'Maximum Value',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: !config.isInteger),
          inputFormatters: [
            if (config.isInteger)
              FilteringTextInputFormatter.digitsOnly
            else
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          onChanged: (value) {
            final parsed = double.tryParse(value);
            if (parsed != null && parsed > 0) {
              onMaxValueChanged(parsed);
            }
          },
          controller: TextEditingController(
            text: config.isInteger ? config.maxValue.toInt().toString() : config.maxValue.toString(),
          )..selection = TextSelection.collapsed(
              offset: config.isInteger ? config.maxValue.toInt().toString().length : config.maxValue.toString().length,
            ),
        ),
      ],
    );
  }
}
