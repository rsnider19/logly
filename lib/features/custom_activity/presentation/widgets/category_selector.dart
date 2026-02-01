import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.triangleAlert,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please select a category.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<ActivityCategory> categories) {
    final rows = <List<ActivityCategory>>[];
    for (var i = 0; i < categories.length; i += 3) {
      rows.add(categories.sublist(i, (i + 3).clamp(0, categories.length)));
    }

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              for (var i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: _CategoryChip(
                    category: row[i],
                    isSelected: row[i].activityCategoryId == selectedCategoryId,
                    onTap: () => onCategorySelected(row[i].activityCategoryId),
                  ),
                ),
              ],
              // Fill remaining space if row has fewer than 3 items
              for (var i = row.length; i < 3; i++) ...[
                const SizedBox(width: 8),
                const Expanded(child: SizedBox.shrink()),
              ],
            ],
          ),
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
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              category.name,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: categoryColor,
      showCheckmark: false,
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
