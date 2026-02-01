import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';
import 'package:logly/widgets/styled_cupertino_picker.dart';

/// Question content for selecting birthday via CupertinoPicker wheels.
class BirthdayQuestionContent extends ConsumerStatefulWidget {
  const BirthdayQuestionContent({super.key});

  @override
  ConsumerState<BirthdayQuestionContent> createState() => _BirthdayQuestionContentState();
}

class _BirthdayQuestionContentState extends ConsumerState<BirthdayQuestionContent> {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _minAge = 13;
  static const _maxAge = 120;

  late final int _maxYear;
  late final int _minYear;
  late final int _defaultYear;

  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _maxYear = now.year - _minAge;
    _minYear = now.year - _maxAge;
    _defaultYear = 2000;

    final existing = ref.read(onboardingAnswersStateProvider).dateOfBirth;
    _selectedMonth = existing?.month ?? 1;
    _selectedDay = existing?.day ?? 1;
    _selectedYear = existing?.year ?? _defaultYear;

    _monthController = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _yearController = FixedExtentScrollController(initialItem: _selectedYear - _minYear);
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _daysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  void _updateDate() {
    final maxDay = _daysInMonth(_selectedMonth, _selectedYear);
    if (_selectedDay > maxDay) {
      _selectedDay = maxDay;
    }
    final date = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    ref.read(onboardingAnswersStateProvider.notifier).setDateOfBirth(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalDays = _daysInMonth(_selectedMonth, _selectedYear);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'When is your birthday?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We use this to provide age-appropriate recommendations.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 16,
            children: [
              // Month
              Expanded(
                child: StyledCupertinoPicker(
                  label: 'Month',
                  scrollController: _monthController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMonth = index + 1;
                    });
                    _updateDate();
                  },
                  children:
                      _months.map((m) => Center(child: Text(m, style: theme.textTheme.bodyLarge))).toList(),
                ),
              ),
              // Day
              Expanded(
                child: StyledCupertinoPicker(
                  label: 'Day',
                  scrollController: _dayController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDay = index + 1;
                    });
                    _updateDate();
                  },
                  children: List.generate(
                    totalDays,
                    (i) => Center(child: Text('${i + 1}', style: theme.textTheme.bodyLarge)),
                  ),
                ),
              ),
              // Year
              Expanded(
                child: StyledCupertinoPicker(
                  label: 'Year',
                  scrollController: _yearController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedYear = _minYear + index;
                    });
                    _updateDate();
                  },
                  children: List.generate(
                    _maxYear - _minYear + 1,
                    (i) => Center(child: Text('${_minYear + i}', style: theme.textTheme.bodyLarge)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
