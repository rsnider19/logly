import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Date',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: TextField(
            controller: _controller,
            readOnly: true,
            showCursor: false,
            canRequestFocus: false,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              prefixIconConstraints: const BoxConstraints(),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 2),
                child: Icon(
                  LucideIcons.calendar,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: _isToday(selectedDate)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: const StadiumBorder(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: MediaQuery.withNoTextScaling(
                            child: Text(
                              'TODAY',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            onTap: () => _selectDate(selectedDate),
          ),
        ),
      ],
    );
  }
}
