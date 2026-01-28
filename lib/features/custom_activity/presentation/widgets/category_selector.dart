import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';

/// A widget for selecting an activity category.
///
/// Displays categories as chips in a wrap layout, 3 per row.
class CategorySelector extends ConsumerWidget {
  const CategorySelector({
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.hasError = false,
    super.key,
  });

  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;
  final bool hasError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(activityCategoriesProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        categoriesAsync.when(
          data: (categories) => _buildCategoryChips(context, categories),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Failed to load categories',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
        if (hasError && selectedCategoryId == null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Please select a category',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<ActivityCategory> categories) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = category.activityCategoryId == selectedCategoryId;
        return _CategoryChip(
          category: category,
          isSelected: isSelected,
          onTap: () => onCategorySelected(category.activityCategoryId),
        );
      }).toList(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryColor = category.color;

    return FilterChip(
      label: Text(category.name),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: categoryColor,
      checkmarkColor: _contrastColor(categoryColor),
      labelStyle: TextStyle(
        color: isSelected ? _contrastColor(categoryColor) : theme.colorScheme.onSurface,
      ),
      side: BorderSide(
        color: isSelected ? categoryColor : categoryColor.withValues(alpha: 0.5),
        width: isSelected ? 2 : 1,
      ),
      shape: const StadiumBorder(),
    );
  }

  Color _contrastColor(Color color) {
    // Calculate luminance to determine if text should be black or white
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
