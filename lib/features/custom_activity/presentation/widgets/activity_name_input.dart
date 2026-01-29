import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Activity Name',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Enter activity name',
              errorText: errorText,
              counter: const SizedBox.shrink(),
            ),
            maxLength: 50,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
}
