import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/widgets/logly_icons.dart';

/// A chip displaying a logged activity with icon and name.
///
/// Tapping the chip navigates to the edit activity screen.
class UserActivityChip extends StatelessWidget {
  const UserActivityChip({
    required this.userActivity,
    this.onPressed,
    super.key,
  });

  final UserActivity userActivity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: UserActivityIcon(userActivity: userActivity),
      label: Text(userActivity.displayName),
      shape: const StadiumBorder(),
      backgroundColor: userActivity.getColor(context),
      side: BorderSide(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(
          Color.getAlphaFromOpacity(0.25),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

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
    required Activity activity,
    VoidCallback? onPressed,
    bool showIcon = true,
  }) => ActivityChip(
    activity: activity,
    onPressed: onPressed,
    isFilled: true,
    showIcon: showIcon,
  );

  final Activity activity;
  final VoidCallback? onPressed;
  final bool isFilled;
  final bool showIcon;
  final MaterialTapTargetSize? materialTapTargetSize;

  @override
  Widget build(BuildContext context) {
    final color = activity.getColor(context);

    return ActionChip(
      avatar: showIcon ? ActivityIcon(activity: activity) : null,
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
