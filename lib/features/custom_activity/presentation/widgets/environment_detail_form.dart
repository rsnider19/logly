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

    return Row(
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
    );
  }
}
