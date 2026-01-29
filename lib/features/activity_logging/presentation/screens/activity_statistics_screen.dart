import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_statistics_provider.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/widgets/logly_icons.dart';
import 'package:table_calendar/table_calendar.dart';

/// Screen displaying monthly statistics for a specific activity.
///
/// Shows a calendar with colored dots indicating logged instances
/// and a list of subactivity counts for the displayed month.
class ActivityStatisticsScreen extends ConsumerStatefulWidget {
  const ActivityStatisticsScreen({
    required this.activityId,
    required this.activityName,
    this.initialMonth,
    this.colorHex,
    super.key,
  });

  final String activityId;
  final String activityName;
  final DateTime? initialMonth;
  final String? colorHex;

  @override
  ConsumerState<ActivityStatisticsScreen> createState() => _ActivityStatisticsScreenState();
}

class _ActivityStatisticsScreenState extends ConsumerState<ActivityStatisticsScreen> {
  late DateTime _focusedDay;

  Color get _dotColor {
    if (widget.colorHex != null && widget.colorHex!.isNotEmpty) {
      try {
        final hex = widget.colorHex!.replaceFirst('#', 'FF');
        return Color(int.parse(hex, radix: 16));
      } catch (_) {
        // Fall through to default
      }
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialMonth ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(
      activityMonthStatisticsProvider(widget.activityId, _focusedDay.year, _focusedDay.month),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activityName),
      ),
      body: Column(
        children: [
          // Calendar
          statsAsync.when(
            loading: () => _buildCalendar(context, {}),
            error: (_, _) => _buildCalendar(context, {}),
            data: (stats) => _buildCalendar(context, stats.dailyActivityCounts),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // Subactivity list
          Expanded(
            child: statsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.circleAlert, size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load statistics',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          ref.invalidate(
                            activityMonthStatisticsProvider(
                              widget.activityId,
                              _focusedDay.year,
                              _focusedDay.month,
                            ),
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (stats) {
                if (stats.totalCount == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.calendarOff,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No activity logged this month',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (stats.subActivityCounts.isEmpty) {
                  // No subactivities — show single row with activity name + total
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      ListTile(
                        leading: Icon(
                          LucideIcons.dumbbell,
                          color: _dotColor,
                        ),
                        title: Text(widget.activityName),
                        trailing: Text(
                          '${stats.totalCount}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: stats.subActivityCounts.length,
                  itemBuilder: (context, index) {
                    final sac = stats.subActivityCounts[index];
                    return ListTile(
                      leading: SubActivityIcon(
                        subActivity: sac.subActivity,
                        fallbackActivity: stats.activity,
                      ),
                      title: Text(sac.subActivity.name),
                      trailing: Text(
                        '${sac.count}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context, Map<DateTime, int> dailyCounts) {
    final theme = Theme.of(context);
    final dotColor = _dotColor;

    return TableCalendar<void>(
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      focusedDay: _focusedDay,
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: theme.colorScheme.onPrimaryContainer,
        ),
        outsideDaysVisible: false,
      ),
      selectedDayPredicate: (_) => false,
      eventLoader: (day) {
        final key = DateTime(day.year, day.month, day.day);
        final count = dailyCounts[key] ?? 0;
        return List<void>.filled(min(count, 3), null);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                events.length,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
    );
  }
}
