import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A styled [CupertinoPicker] with rounded corners, flat appearance,
/// themed background, and arrow selection overlay.
///
/// Optionally displays a [label] above the picker.
class StyledCupertinoPicker extends StatelessWidget {
  const StyledCupertinoPicker({
    required this.onSelectedItemChanged,
    required this.children,
    super.key,
    this.label,
    this.scrollController,
  });

  /// Optional label displayed above the picker.
  final String? label;

  /// Controller for the picker scroll position.
  final FixedExtentScrollController? scrollController;

  /// Called when the selected item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// The picker items.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final picker = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CupertinoPicker(
        scrollController: scrollController,
        itemExtent: 50,
        diameterRatio: 1000,
        backgroundColor: theme.colorScheme.surfaceContainer,
        selectionOverlay: const Row(
          children: [
            Icon(Icons.arrow_right_rounded),
            Spacer(),
            Icon(Icons.arrow_left_rounded),
          ],
        ),
        onSelectedItemChanged: onSelectedItemChanged,
        children: children,
      ),
    );

    if (label == null) return picker;

    return Column(
      children: [
        Text(
          label!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(height: 180, child: picker),
      ],
    );
  }
}
