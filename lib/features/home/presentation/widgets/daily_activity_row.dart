import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/widgets/skeleton_loader.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A row displaying a single day with its logged activities.
///
/// Shows the day name and date on the left, and a horizontal scrollable
/// list of activity chips on the right.
///
/// Tapping the row (outside of chips) navigates to log a new activity
/// for that date.
class DailyActivityRow extends StatelessWidget {
  const DailyActivityRow({
    required this.summary,
    super.key,
  });

  final DailyActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = _isToday(summary.activityDate);
    final isFuture = summary.activityDate.isAfter(DateTime.now());

    return GestureDetector(
      onTap: () => _navigateToLogActivity(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
        child: Row(
          children: [
            // Date column
            SizedBox(
              width: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDayName(summary.activityDate),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isToday
                          ? theme.colorScheme.primary
                          : isFuture
                          ? Colors.grey[500]
                          : theme.colorScheme.onSurface,
                    ),
                  ).withSkeleton(placeholderText: 'Mon'),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(summary.activityDate),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isFuture ? Colors.grey[400] : Colors.grey[600],
                      fontFeatures: [
                        const FontFeature.tabularFigures(),
                      ],
                    ),
                  ).withSkeleton(placeholderText: '01/22'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Activity chips
            Expanded(
              child: _buildChipsArea(context, isFuture),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipsArea(BuildContext context, bool isFuture) {
    final theme = Theme.of(context);
    final isToday = _isToday(summary.activityDate);

    return Skelly(
      builder: (context) {
        final chips = <Widget>[];

        // Add activity chips
        for (final userActivity in summary.userActivities.sortedBy((a) => a.createdAt!)) {
          chips.add(
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: UserActivityChip(
                userActivity: userActivity,
                onPressed: () => EditActivityRoute(userActivityId: userActivity.userActivityId).push<void>(context),
              ),
            ),
          );
        }

        // Add "Logly It" chip only for today
        if (summary.userActivities.isEmpty) {
          chips.add(
            Opacity(
              opacity: isToday ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: Icon(
                    LucideIcons.plus,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  label: Text(
                    'Logly It!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.surface.withAlpha(
                      Color.getAlphaFromOpacity(0.25),
                    ),
                  ),
                  onPressed: () => const ActivitySearchRoute().push<void>(context),
                ),
              ),
            ),
          );
        }

        if (chips.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: chips),
        );
      },
      placeholder: (context) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: UserActivityChip(userActivity: UserActivity.empty(name: 'Charizard')),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: UserActivityChip(userActivity: UserActivity.empty(name: 'Blastoise')),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: UserActivityChip(userActivity: UserActivity.empty(name: 'Venusaur')),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToLogActivity(BuildContext context) {
    final dateStr = summary.activityDate.toIso8601String().split('T').first;
    unawaited(context.push('/activities/search?date=$dateStr'));
  }

  String _formatDayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
