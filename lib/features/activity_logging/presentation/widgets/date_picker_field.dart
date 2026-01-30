import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

/// Date picker field for selecting the activity date.
///
/// Uses [ActivityFormStateNotifier.setActivityDate] to update the value.
class DatePickerField extends ConsumerStatefulWidget {
  const DatePickerField({super.key});

  @override
  ConsumerState<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends ConsumerState<DatePickerField> {
  final _controller = TextEditingController();
  final _dateFormat = DateFormat.yMMMd();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  Future<void> _selectDate(DateTime currentDate) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Select activity date',
    );

    if (selectedDate != null) {
      // Preserve the time from the current date or use current time if today
      final DateTime dateWithTime;
      if (_isToday(selectedDate)) {
        dateWithTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          now.hour,
          now.minute,
        );
      } else {
        dateWithTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          currentDate.hour,
          currentDate.minute,
        );
      }
      ref.read(activityFormStateProvider.notifier).setActivityDate(dateWithTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final selectedDate = formState.activityDate;

    final formattedDate = _dateFormat.format(selectedDate);
    if (_controller.text != formattedDate) {
      _controller.text = formattedDate;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          readOnly: true,
          showCursor: false,
          canRequestFocus: false,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            prefixIconConstraints: const BoxConstraints.tightFor(width: 36),
            prefixIcon: Icon(
              LucideIcons.calendar,
              color: theme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            border: const OutlineInputBorder(),
            suffixIconConstraints: const BoxConstraints.tightFor(width: 64),
            suffixIcon: _isToday(selectedDate)
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: MediaQuery.withNoTextScaling(
                        child: Text(
                          'Today',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          onTap: () => _selectDate(selectedDate),
        ),
      ],
    );
  }
}
