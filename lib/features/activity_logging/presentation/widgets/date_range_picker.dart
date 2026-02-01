import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Date range picker for multi-day activities.
///
/// Includes a toggle to enable multi-day mode and uses
/// [ActivityFormStateNotifier.setActivityDate] and [setEndDate].
class DateRangePicker extends ConsumerWidget {
  const DateRangePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final startDate = formState.activityDate;
    final endDate = formState.endDate;
    final isMultiDay = endDate != null;
    final dateFormat = DateFormat.yMMMd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Date',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            Row(
              children: [
                Text(
                  'Multi-day',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 4),
                Switch(
                  value: isMultiDay,
                  onChanged: (value) {
                    if (value) {
                      // Enable multi-day with end date same as start
                      ref.read(activityFormStateProvider.notifier).setEndDate(startDate);
                    } else {
                      // Disable multi-day
                      ref.read(activityFormStateProvider.notifier).setEndDate(null);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isMultiDay) ...[
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'Start',
                  date: startDate,
                  onTap: () => _selectStartDate(context, ref, startDate, endDate),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  LucideIcons.arrowRight,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              Expanded(
                child: _DateField(
                  label: 'End',
                  date: endDate,
                  onTap: () => _selectEndDate(context, ref, startDate, endDate),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatDateRange(startDate, endDate, dateFormat),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ] else ...[
          _DateField(
            date: startDate,
            showToday: true,
            onTap: () => _selectStartDate(context, ref, startDate, null),
          ),
        ],
      ],
    );
  }

  String _formatDateRange(DateTime start, DateTime? end, DateFormat format) {
    if (end == null || _isSameDay(start, end)) {
      return format.format(start);
    }
    final days = end.difference(start).inDays + 1;
    return '${format.format(start)} - ${format.format(end)} ($days days)';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _selectStartDate(
    BuildContext context,
    WidgetRef ref,
    DateTime currentStart,
    DateTime? currentEnd,
  ) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentStart,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select start date',
    );

    if (selectedDate != null) {
      ref
          .read(activityFormStateProvider.notifier)
          .setActivityDate(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
          );
      // If end date is before new start date, adjust it
      if (currentEnd != null && selectedDate.isAfter(currentEnd)) {
        ref.read(activityFormStateProvider.notifier).setEndDate(selectedDate);
      }
    }
  }

  Future<void> _selectEndDate(
    BuildContext context,
    WidgetRef ref,
    DateTime startDate,
    DateTime? currentEnd,
  ) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentEnd ?? startDate,
      firstDate: startDate, // Can't end before start
      lastDate: now.add(30.days),
      helpText: 'Select end date',
    );

    if (selectedDate != null) {
      ref
          .read(activityFormStateProvider.notifier)
          .setEndDate(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
          );
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.onTap,
    this.label,
    this.showToday = false,
  });

  final DateTime date;
  final VoidCallback onTap;
  final String? label;
  final bool showToday;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: const InputDecoration().applyDefaults(
          theme.inputDecorationTheme,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 24,
              child: Icon(
                LucideIcons.calendar,
                color: theme.colorScheme.onSurfaceVariant,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    dateFormat.format(date),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (showToday && _isToday(date))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Today',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
