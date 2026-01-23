import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';

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
        final firstRow = sortedCategories.take(3).toList();
        final secondRow = sortedCategories.skip(3).take(3).toList();

        return Column(
          children: [
            _buildRow(firstRow, effectiveFilters, allCategoryIds, notifier),
            const SizedBox(height: 8),
            _buildRow(secondRow, effectiveFilters, allCategoryIds, notifier),
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
      children: categories
          .map((category) {
            final isSelected = selectedFilters.contains(category.activityCategoryId);
            final color = Color(int.parse('FF${category.hexColor.replaceFirst('#', '')}', radix: 16));

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  showCheckmark: false,
                  selectedColor: color.withValues(alpha: 0.3),
                  onSelected: (_) => notifier.toggle(category.activityCategoryId, allCategoryIds),
                ),
              ),
            );
          })
          .toList(),
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
        const SizedBox(height: 8),
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
