import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/profile/data/category_filter_frequency_repository.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:logly/widgets/logly_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Floating filter bar for the profile screen with category chips and time period chips.
class ProfileFilterBar extends ConsumerWidget {
  const ProfileFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CategoryChipRow(),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TimePeriodChipRow(),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class _CategoryChipRow extends ConsumerWidget {
  const _CategoryChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(frequencySortedCategoriesProvider);
    final filterState = ref.watch(profileFilterStateProvider);
    final notifier = ref.watch(profileFilterStateProvider.notifier);
    final isAllSelected = filterState.selectedCategoryIds.isEmpty;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AllFilterChip(
              isSelected: isAllSelected,
              onPressed: notifier.selectAllCategories,
            );
          }
          final category = categories[index - 1];
          final isSelected = filterState.selectedCategoryIds.contains(category.activityCategoryId);
          return _CategoryFilterChip(
            category: category,
            isSelected: isSelected,
            onPressed: () async {
              if (!isSelected) {
                await ref.read(categoryFilterFrequencyRepositoryProvider).incrementFrequency(
                      category.activityCategoryId,
                    );
              }
              notifier.toggleCategory(category.activityCategoryId);
            },
          );
        },
      ),
    );
  }
}

class _AllFilterChip extends StatelessWidget {
  const _AllFilterChip({
    required this.isSelected,
    required this.onPressed,
  });

  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      avatar: Icon(
        LucideIcons.listFilter,
        size: 18,
        color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
      ),
      label: Text(
        'All',
        style: TextStyle(
          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        ),
      ),
      shape: const StadiumBorder(),
      backgroundColor: isSelected ? theme.colorScheme.primary : null,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.surface.withAlpha(Color.getAlphaFromOpacity(0.25))
            : theme.colorScheme.onSurface.withAlpha(Color.getAlphaFromOpacity(0.25)),
      ),
      onPressed: onPressed,
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  final ActivityCategory category;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = category.color;

    return ActionChip(
      avatar: ActivityCategoryIcon(
        activityCategory: category,
        size: 18,
        color: theme.colorScheme.onSurface,
      ),
      label: Text(category.name),
      shape: const StadiumBorder(),
      backgroundColor: isSelected ? categoryColor : null,
      side: BorderSide(
        color: isSelected
            ? theme.colorScheme.surface.withAlpha(Color.getAlphaFromOpacity(0.25))
            : theme.colorScheme.onSurface.withAlpha(Color.getAlphaFromOpacity(0.25)),
      ),
      onPressed: onPressed,
    );
  }
}

class _TimePeriodChipRow extends ConsumerWidget {
  const _TimePeriodChipRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(globalTimePeriodProvider);
    final notifier = ref.watch(profileFilterStateProvider.notifier);

    return Row(
      children: TimePeriod.values.asMap().entries.map((entry) {
        final index = entry.key;
        final period = entry.value;
        final isSelected = period == selectedPeriod;
        final isLast = index == TimePeriod.values.length - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: FilterChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  _getPeriodLabel(period),
                  textAlign: TextAlign.center,
                ),
              ),
              shape: const StadiumBorder(),
              selected: isSelected,
              onSelected: (_) => notifier.selectTimePeriod(period),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getPeriodLabel(TimePeriod period) {
    switch (period) {
      case TimePeriod.oneWeek:
        return '1W';
      case TimePeriod.oneMonth:
        return '1M';
      case TimePeriod.oneYear:
        return '1Y';
      case TimePeriod.all:
        return 'All';
    }
  }
}
