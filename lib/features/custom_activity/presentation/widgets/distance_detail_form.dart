import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// Form fields for configuring a Distance detail.
class DistanceDetailForm extends StatelessWidget {
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

        // Short/Long toggle
        Text('Distance Type', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Short'),
              icon: Icon(Icons.straighten, size: 16),
            ),
            ButtonSegment(
              value: false,
              label: Text('Long'),
              icon: Icon(Icons.route, size: 16),
            ),
          ],
          selected: {config.isShort},
          onSelectionChanged: (selected) => onIsShortChanged(selected.first),
        ),
        const SizedBox(height: 4),
        Text(
          config.isShort ? 'meters / yards' : 'kilometers / miles',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),

        // Maximum value input
        TextField(
          decoration: InputDecoration(
            labelText: 'Maximum Value',
            suffixText: config.isShort ? 'm / yd' : 'km / mi',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
        const SizedBox(height: 16),

        // Use for pace calculation toggle
        if (paceEnabled)
          SwitchListTile(
            title: const Text('Use for pace calculation'),
            subtitle: const Text('Mark this distance for pace calculation'),
            value: config.useForPace,
            onChanged: onUseForPaceChanged,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }
}
