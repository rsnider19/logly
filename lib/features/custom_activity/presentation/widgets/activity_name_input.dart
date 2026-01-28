import 'package:flutter/material.dart';

/// A text field for entering the activity name.
class ActivityNameInput extends StatelessWidget {
  const ActivityNameInput({
    required this.controller,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Name',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Enter activity name',
            errorText: errorText,
            counterText: '${controller.text.length}/50',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          maxLength: 50,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
