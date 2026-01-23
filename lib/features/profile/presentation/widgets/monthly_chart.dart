import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/features/profile/presentation/widgets/category_filter_chips.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';
import 'package:logly/features/profile/presentation/widgets/stacked_bar.dart';

/// Card displaying the last 12 months as stacked bar chart.
class MonthlyChartCard extends ConsumerWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded =
        ref.watch(collapsibleSectionsStateProvider)[ProfileSections.monthly] ?? true;
    final monthlyDataAsync = ref.watch(filteredMonthlyChartDataProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return CollapsibleSection(
      title: 'Last 12 Months',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.monthly),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryFilterChips(),
          const SizedBox(height: 16),
          monthlyDataAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return const _EmptyState();
              }

              return categoriesAsync.when(
                data: (categories) {
                  final categoryColors = {
                    for (final c in categories) c.activityCategoryId: Color(int.parse('FF${c.hexColor.replaceFirst('#', '')}', radix: 16)),
                  };

                  return _MonthlyChart(
                    data: data,
                    categoryColors: categoryColors,
                  );
                },
                loading: () => const _MonthlyChartShimmer(),
                error: (_, _) => const _MonthlyChartShimmer(),
              );
            },
            loading: () => const _MonthlyChartShimmer(),
            error: (error, _) => _MonthlyChartError(
              onRetry: () => ref.invalidate(filteredMonthlyChartDataProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({
    required this.data,
    required this.categoryColors,
  });

  final List<MonthlyCategoryData> data;
  final Map<String, Color> categoryColors;

  static const List<String> monthLabels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

  @override
  Widget build(BuildContext context) {
    // Group data by month
    final monthlyGroups = <DateTime, List<MonthlyCategoryData>>{};
    for (final item in data) {
      final monthKey = DateTime(item.activityMonth.year, item.activityMonth.month);
      monthlyGroups.putIfAbsent(monthKey, () => []).add(item);
    }

    // Get last 12 months
    final now = DateTime.now();
    final months = List.generate(12, (i) {
      final date = DateTime(now.year, now.month - 11 + i);
      return DateTime(date.year, date.month);
    });

    // Calculate max total for scaling
    var maxTotal = 0;
    for (final month in months) {
      final items = monthlyGroups[month] ?? [];
      final total = items.fold(0, (sum, item) => sum + item.activityCount);
      if (total > maxTotal) maxTotal = total;
    }

    return SizedBox(
      height: StackedBar.maxBarHeight + 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: months.map((month) {
          final items = monthlyGroups[month] ?? [];
          final segments = items.map((item) {
            return StackedBarSegment(
              categoryId: item.activityCategoryId,
              count: item.activityCount,
              color: item.activityCategoryId != null
                  ? categoryColors[item.activityCategoryId] ?? Colors.grey
                  : Colors.grey,
            );
          }).toList();

          return StackedBar(
            monthLabel: monthLabels[month.month - 1],
            segments: segments,
            maxHeight: maxTotal.toDouble(),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No activities logged',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChartShimmer extends StatelessWidget {
  const _MonthlyChartShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: StackedBar.maxBarHeight + 24,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _MonthlyChartError extends StatelessWidget {
  const _MonthlyChartError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load monthly data',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
