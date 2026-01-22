import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';

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
    final color = _parseColor(userActivity.effectiveColor);

    return ActionChip(
      avatar: userActivity.effectiveIcon != null
          ? Text(
              userActivity.effectiveIcon!,
              style: const TextStyle(fontSize: 16),
            )
          : null,
      label: Text(userActivity.displayName),
      shape: const StadiumBorder(),
      backgroundColor: color,
      side: BorderSide(color: Theme.of(context).colorScheme.surface.withAlpha(Color.getAlphaFromOpacity(0.25))),
      onPressed: () => context.push('/activities/edit/${userActivity.userActivityId}'),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
