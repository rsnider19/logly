import 'package:flutter/material.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// Form fields for configuring an Environment detail.
class EnvironmentDetailForm extends StatelessWidget {
  const EnvironmentDetailForm({
    required this.config,
    required this.onLabelChanged,
    super.key,
  });

  final EnvironmentDetailConfig config;
  final ValueChanged<String> onLabelChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label input (optional for environment)
        TextField(
          decoration: InputDecoration(
            labelText: 'Label (Optional)',
            hintText: config.labelPlaceholder,
            helperText: 'Leave empty for default "Environment"',
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

        // Preview
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Users can select Indoor or Outdoor when logging this activity.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
