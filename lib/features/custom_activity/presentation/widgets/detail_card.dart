import 'package:flutter/material.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// A card container for an activity detail configuration.
///
/// Displays the detail type name and a delete button in the header,
/// with the form fields as children.
class DetailCard extends StatelessWidget {
  const DetailCard({
    required this.detail,
    required this.onDelete,
    required this.child,
    super.key,
  });

  final ActivityDetailConfig detail;
  final VoidCallback onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  detail.typeName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Remove ${detail.typeName}',
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            // Form fields
            child,
          ],
        ),
      ),
    );
  }
}
