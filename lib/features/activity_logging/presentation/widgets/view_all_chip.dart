import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A chip that navigates to view all activities in a category.
///
/// Displays "View all" text with a trailing chevron icon.
/// The outline and text are colored with the category color.
class ViewAllChip extends StatelessWidget {
  const ViewAllChip({
    required this.categoryColor,
    required this.onPressed,
    super.key,
  });

  /// The color to use for the chip outline and text.
  final Color? categoryColor;

  /// Called when the chip is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      padding: EdgeInsets.only(left: 8, top: 8, right: 2, bottom: 8),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View all',
            style: TextStyle(color: categoryColor),
          ),
          const SizedBox(width: 4),
          Icon(
            LucideIcons.chevronRight,
            size: 18,
            color: categoryColor,
          ),
        ],
      ),
      shape: const StadiumBorder(),
      backgroundColor: Colors.transparent,
      side: theme.chipTheme.side?.copyWith(color: categoryColor),
      onPressed: onPressed,
    );
  }
}
