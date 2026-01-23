import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';

/// Horizontal scrollable row of category filter chips.
class CategoryFilterChips extends ConsumerWidget {
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedFilters = ref.watch(selectedCategoryFiltersStateProvider);
    final notifier = ref.watch(selectedCategoryFiltersStateProvider.notifier);

    return categoriesAsync.when(
      data: (categories) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((category) {
            final isSelected = selectedFilters.contains(category.activityCategoryId);
            final color = Color(int.parse('FF${category.hexColor.replaceFirst('#', '')}', radix: 16));

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category.name),
                selected: isSelected,
                selectedColor: color.withValues(alpha: 0.3),
                checkmarkColor: color,
                onSelected: (_) => notifier.toggle(category.activityCategoryId),
              ),
            );
          }).toList(),
        ),
      ),
      loading: () => const _FilterChipsShimmer(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FilterChipsShimmer extends StatelessWidget {
  const _FilterChipsShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 80,
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
