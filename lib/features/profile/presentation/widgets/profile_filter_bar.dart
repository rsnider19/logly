import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:logly/widgets/logly_icons.dart';

/// Floating filter bar for the profile screen with category icons and time period chips.
class ProfileFilterBar extends ConsumerWidget {
  const ProfileFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CategoryIconRow(),
          SizedBox(height: 8),
          _TimePeriodChipRow(),
        ],
      ),
    );
  }
}

class _CategoryIconRow extends ConsumerWidget {
  const _CategoryIconRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(activityCategoriesProvider);
    final filterState = ref.watch(profileFilterStateProvider);
    final effectiveFiltersAsync = ref.watch(effectiveGlobalCategoryFiltersProvider);
    final notifier = ref.watch(profileFilterStateProvider.notifier);

    return categoriesAsync.when(
      data: (categories) {
        final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final allCategoryIds = sortedCategories.map((c) => c.activityCategoryId).toList();

        final effectiveFilters = effectiveFiltersAsync.when(
          data: (filters) => filters,
          loading: () => allCategoryIds.toSet(),
          error: (_, _) => allCategoryIds.toSet(),
        );

        return Row(
          children: [
            for (final category in sortedCategories)
              Expanded(
                child: Builder(
                  builder: (context) {
                    final isSelected = effectiveFilters.contains(category.activityCategoryId);
                    return IconButton.outlined(
                      onPressed: () => notifier.toggleCategory(category.activityCategoryId, allCategoryIds),
                      color: Color(int.parse(category.hexColor.replaceFirst('#', 'FF'), radix: 16)),
                      style: IconButton.styleFrom(
                        shape: const CircleBorder(),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onSurface.withAlpha(Color.getAlphaFromOpacity(0.54))
                              : category.color,
                        ),
                        backgroundColor: isSelected ? category.color : null,
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.all(4),
                        child: ActivityCategoryIcon(
                          activityCategory: category,
                          color: isSelected ? Theme.of(context).colorScheme.onSurface : category.color,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox(height: 48),
      error: (_, _) => const SizedBox.shrink(),
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
