import 'package:flutter/material.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A card container for an activity detail configuration.
///
/// Displays the detail type name and a delete button in the header,
/// with the form fields as children.
class DetailCard extends StatelessWidget {
  const DetailCard({
    required this.detail,
    required this.index,
    required this.onDelete,
    required this.child,
    super.key,
  });

  final ActivityDetailConfig detail;
  final int index;
  final VoidCallback onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    LucideIcons.gripVertical,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                detail.typeName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  LucideIcons.trash2,
                  color: theme.colorScheme.error,
                ),
                onPressed: onDelete,
                tooltip: 'Remove ${detail.typeName}',
              ),
            ],
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          const SizedBox(height: 16),
          // Form fields
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
