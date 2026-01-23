import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';

/// Displays an icon for an [ActivityCategory] from Supabase Storage.
///
/// Falls back to [Icons.category_outlined] with the category color on error.
class ActivityCategoryIcon extends StatelessWidget {
  const ActivityCategoryIcon({
    required this.activityCategory,
    this.size = 24,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    super.key,
  });

  final ActivityCategory activityCategory;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);
    final categoryColor = _parseColor(activityCategory.hexColor);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: CachedNetworkImage(
        imageUrl: activityCategory.icon,
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => SizedBox(width: size, height: size),
        errorWidget: (context, url, error) => Icon(
          Icons.category_outlined,
          size: size,
          color: color ?? categoryColor,
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

/// Displays an icon for an [Activity] from Supabase Storage.
///
/// Falls back to [ActivityCategoryIcon] if category exists, else [Icons.fitness_center].
class ActivityIcon extends StatelessWidget {
  const ActivityIcon({
    required this.activity,
    this.size = 24,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    super.key,
  });

  final Activity activity;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: CachedNetworkImage(
        imageUrl: activity.icon,
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => SizedBox(width: size, height: size),
        errorWidget: (context, url, error) {
          if (activity.activityCategory != null) {
            return ActivityCategoryIcon(
              activityCategory: activity.activityCategory!,
              size: size,
              fit: fit,
              borderRadius: effectiveBorderRadius,
              color: color,
            );
          }
          return Icon(
            Icons.category_outlined,
            size: size,
            color: color,
          );
        },
      ),
    );
  }
}

/// Displays an icon for a [SubActivity] from Supabase Storage.
///
/// Falls back to [ActivityIcon] if fallbackActivity provided, else [Icons.layers_outlined].
class SubActivityIcon extends StatelessWidget {
  const SubActivityIcon({
    required this.subActivity,
    this.fallbackActivity,
    this.size = 24,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    super.key,
  });

  final SubActivity subActivity;
  final Activity? fallbackActivity;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);

    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: CachedNetworkImage(
        imageUrl: subActivity.icon,
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => SizedBox(width: size, height: size),
        errorWidget: (context, url, error) {
          if (fallbackActivity != null) {
            return ActivityIcon(
              activity: fallbackActivity!,
              size: size,
              fit: fit,
              borderRadius: effectiveBorderRadius,
              color: color,
            );
          }
          return Icon(
            Icons.category_outlined,
            size: size,
            color: color,
          );
        },
      ),
    );
  }
}

/// Displays an icon for a [UserActivity] with smart fallback logic.
///
/// Priority logic:
/// 1. If exactly 1 subactivity -> [SubActivityIcon] (with activity as fallback)
/// 2. Otherwise -> [ActivityIcon] (which cascades to category on error)
/// 3. If no activity -> generic [Icons.event_outlined]
class UserActivityIcon extends StatelessWidget {
  const UserActivityIcon({
    required this.userActivity,
    this.size = 24,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    super.key,
  });

  final UserActivity userActivity;
  final double size;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);
    final activity = userActivity.activity;

    // No activity -> generic icon
    if (activity == null) {
      return ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Icon(
          Icons.category_outlined,
          size: size,
        ),
      );
    }

    // Exactly 1 subactivity -> use SubActivityIcon with activity fallback
    if (userActivity.subActivity.length == 1) {
      return SubActivityIcon(
        subActivity: userActivity.subActivity.first,
        fallbackActivity: activity,
        size: size,
        fit: fit,
        borderRadius: effectiveBorderRadius,
        color: color,
      );
    }

    // Otherwise -> use ActivityIcon (which cascades to category on error)
    return ActivityIcon(
      activity: activity,
      size: size,
      fit: fit,
      borderRadius: effectiveBorderRadius,
      color: color,
    );
  }
}
