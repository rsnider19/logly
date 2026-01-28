import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/features/profile/presentation/widgets/category_filter_chips.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';

/// Card displaying the last 12 months as stacked bar chart.
class MonthlyChartCard extends ConsumerWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded = ref.watch(collapsibleSectionsStateProvider)[ProfileSections.monthly] ?? true;
    final monthlyDataAsync = ref.watch(filteredMonthlyChartDataProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

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
                    for (final c in categories)
                      c.activityCategoryId: Color(int.parse('FF${c.hexColor.replaceFirst('#', '')}', radix: 16)),
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

  static const List<String> monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const double chartHeight = 124;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group data by month
    final monthlyGroups = <DateTime, List<MonthlyCategoryData>>{};
    for (final item in data) {
      final monthKey = DateTime(item.activityMonth.year, item.activityMonth.month);
      monthlyGroups.putIfAbsent(monthKey, () => []).add(item);
    }

    // Calculate overall totals per category (for sorting segments)
    final categoryTotals = <String, int>{};
    for (final item in data) {
      if (item.activityCategoryId != null) {
        categoryTotals.update(
          item.activityCategoryId!,
          (v) => v + item.activityCount,
          ifAbsent: () => item.activityCount,
        );
      }
    }

    // Sort categories by total (descending) - highest total at bottom of stack
    final sortedCategories = categoryTotals.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final categoryOrder = {for (var i = 0; i < sortedCategories.length; i++) sortedCategories[i].key: i};

    // Get last 12 months (most recent first)
    final now = DateTime.now();
    final months = List.generate(12, (i) {
      final date = DateTime(now.year, now.month - i);
      return DateTime(date.year, date.month);
    });

    // Calculate max total for Y axis
    var maxTotal = 0.0;
    for (final month in months) {
      final items = monthlyGroups[month] ?? [];
      final total = items.fold(0, (sum, item) => sum + item.activityCount);
      if (total > maxTotal) maxTotal = total.toDouble();
    }

    // Build bar groups
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < months.length; i++) {
      final month = months[i];
      final items = monthlyGroups[month] ?? [];

      // Sort items by category order (highest total category first = bottom of stack)
      final sortedItems = items.toList()
        ..sort((a, b) {
          final aOrder = categoryOrder[a.activityCategoryId] ?? 999;
          final bOrder = categoryOrder[b.activityCategoryId] ?? 999;
          return aOrder.compareTo(bOrder);
        });

      // Build stack items
      final stackItems = <BarChartRodStackItem>[];
      var fromY = 0.0;
      for (final item in sortedItems) {
        final toY = fromY + item.activityCount;
        stackItems.add(
          BarChartRodStackItem(
            fromY,
            toY,
            item.activityCategoryId != null
                ? categoryColors[item.activityCategoryId] ?? Colors.grey
                : Colors.grey,
          ),
        );
        fromY = toY;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: fromY,
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              rodStackItems: stackItems,
              color: Colors.transparent,
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxTotal > 0 ? maxTotal : 1,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: chartHeight,
      child: BarChart(
        BarChartData(
          maxY: maxTotal > 0 ? maxTotal : 1,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= months.length) {
                    return const SizedBox.shrink();
                  }
                  // Skip every other month label
                  if (index % 2 != 0) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      monthLabels[months[index].month - 1],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          barTouchData: const BarTouchData(enabled: false),
          alignment: BarChartAlignment.spaceAround,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
      height: _MonthlyChart.chartHeight,
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
