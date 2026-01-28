import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/widgets/logly_icons.dart';

/// A chip displaying a logged activity with icon and name.
///
/// Tapping the chip navigates to the edit activity screen.
/// Shows a loading state with spinner when the activity is optimistically
/// added (userActivityId starts with 'optimistic_').
class UserActivityChip extends StatelessWidget {
  const UserActivityChip({
    required this.userActivity,
    this.onPressed,
    super.key,
  });

  final UserActivity userActivity;
  final VoidCallback? onPressed;

  bool get _isPending => userActivity.userActivityId.startsWith('optimistic_');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = userActivity.getColor(context);

    return ActionChip(
      avatar: _isPending
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : UserActivityIcon(userActivity: userActivity),
      label: Text(
        userActivity.displayName,
        style: _isPending
            ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
            : null,
      ),
      shape: const StadiumBorder(),
      backgroundColor: _isPending ? theme.colorScheme.surfaceContainerHighest : color,
      side: BorderSide(
        color: theme.colorScheme.onSurface.withAlpha(
          Color.getAlphaFromOpacity(0.25),
        ),
      ),
      onPressed: _isPending ? null : onPressed,
    );
  }
}

/// A chip displaying an activity summary with icon and name.
///
/// Used in search results, category lists, and favorites.
class ActivityChip extends StatelessWidget {
  const ActivityChip({
    required this.activity,
    this.onPressed,
    this.isFilled = false,
    this.showIcon = true,
    this.materialTapTargetSize = MaterialTapTargetSize.padded,
    super.key,
  });

  factory ActivityChip.filled({
    required ActivitySummary activity,
    VoidCallback? onPressed,
    bool showIcon = true,
  }) => ActivityChip(
    activity: activity,
    onPressed: onPressed,
    isFilled: true,
    showIcon: showIcon,
  );

  final ActivitySummary activity;
  final VoidCallback? onPressed;
  final bool isFilled;
  final bool showIcon;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    final color = activity.getColor(context);

    return ActionChip(
      avatar: showIcon ? ActivitySummaryIcon(activitySummary: activity) : null,
      label: Text(activity.name),
      shape: const StadiumBorder(),
      backgroundColor: isFilled ? color : null,
      materialTapTargetSize: materialTapTargetSize,
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(
          Color.getAlphaFromOpacity(0.25),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
