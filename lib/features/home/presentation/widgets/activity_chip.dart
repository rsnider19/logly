import 'package:cached_network_image/cached_network_image.dart';
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
    final iconUrl = userActivity.effectiveIconUrl;

    return ActionChip(
      avatar: iconUrl != null
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: iconUrl,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox(
                  width: 24,
                  height: 24,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.circle,
                  size: 24,
                ),
              ),
            )
          : null,
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
