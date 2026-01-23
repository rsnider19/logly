import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/widgets/logly_icons.dart';

/// A chip displaying a logged activity with icon and name.
///
/// Tapping the chip navigates to the edit activity screen.
class ActivityChip extends StatelessWidget {
  const ActivityChip({
    required this.userActivity,
    super.key,
  });

  final UserActivity userActivity;

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(userActivity.color);

    return ActionChip(
      avatar: UserActivityIcon(userActivity: userActivity),
      label: Text(userActivity.displayName),
      shape: const StadiumBorder(),
      backgroundColor: color,
      side: BorderSide(
        color: Theme.of(context).colorScheme.surface.withAlpha(
          Color.getAlphaFromOpacity(0.25),
        ),
      ),
      onPressed: userActivity.userActivityId.isNotEmpty
          ? () => context.push('/activities/edit/${userActivity.userActivityId}')
          : null,
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
