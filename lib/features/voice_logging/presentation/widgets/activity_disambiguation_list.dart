import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/widgets/logly_icons.dart';

/// A list of activity options for disambiguation.
///
/// Shows when voice input matches multiple activities,
/// allowing the user to select the correct one.
class ActivityDisambiguationList extends StatelessWidget {
  const ActivityDisambiguationList({
    required this.activities,
    required this.onActivitySelected,
    super.key,
  });

  final List<ActivitySummary> activities;
  final void Function(ActivitySummary) onActivitySelected;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return _ActivityTile(
            activity: activity,
            onTap: () => onActivitySelected(activity),
          );
        },
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.onTap,
  });

  final ActivitySummary activity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ActivitySummaryIcon(activitySummary: activity),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (activity.activityCategory != null)
                      Text(
                        activity.activityCategory!.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
