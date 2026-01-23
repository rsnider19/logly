import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/widgets/logly_icons.dart';

/// Two-row grid of category filter chips for the monthly chart.
class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final effectiveFiltersAsync = ref.watch(effectiveSelectedFiltersProvider);
    final notifier = ref.watch(selectedCategoryFiltersStateProvider.notifier);

    return categoriesAsync.when(
      data: (categories) {
        // Sort categories by sortOrder
        final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final allCategoryIds = sortedCategories.map((c) => c.activityCategoryId).toList();

        // Get effective selection (defaults to all selected when loading or on error)
        final effectiveFilters = effectiveFiltersAsync.when(
          data: (filters) => filters,
          loading: () => allCategoryIds.toSet(),
          error: (_, _) => allCategoryIds.toSet(),
        );

        // Split into two rows of 3
        return Row(
          spacing: 8,
          children: [
            for (final category in sortedCategories)
              Expanded(
                child: Builder(
                  builder: (context) {
                    final isSelected = effectiveFilters.contains(category.activityCategoryId);
                    return IconButton.outlined(
                      onPressed: () => notifier.toggle(category.activityCategoryId, allCategoryIds),
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
      loading: () => const _FilterChipsShimmer(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildRow(
    List<ActivityCategory> categories,
    Set<String> selectedFilters,
    List<String> allCategoryIds,
    SelectedCategoryFiltersStateNotifier notifier,
  ) {
    return Row(
      spacing: 8,
      children: categories.map((category) {
        final isSelected = selectedFilters.contains(category.activityCategoryId);
        final color = Color(int.parse('FF${category.hexColor.replaceFirst('#', '')}', radix: 16));

        return Expanded(
          child: FilterChip(
            label: Row(
              children: [
                Expanded(
                  child: Center(child: Text(category.name)),
                ),
              ],
            ),
            selected: isSelected,
            showCheckmark: false,
            shape: const StadiumBorder(),
            side: BorderSide(
              color: color,
            ),
            selectedColor: color,
            onSelected: (_) => notifier.toggle(category.activityCategoryId, allCategoryIds),
          ),
        );
      }).toList(),
    );
  }
}

class _FilterChipsShimmer extends StatelessWidget {
  const _FilterChipsShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildShimmerRow(theme),
        _buildShimmerRow(theme),
      ],
    );
  }

  Widget _buildShimmerRow(ThemeData theme) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
