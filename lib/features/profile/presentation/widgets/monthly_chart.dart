import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/monthly_category_data.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/monthly_chart_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';

/// Card displaying activity data as a stacked bar chart.
///
/// The chart dynamically adapts to the global time period:
/// - 1W: 7 daily bars
/// - 1M: 4-5 weekly bars
/// - 1Y / All: 12 monthly bars
class MonthlyChartCard extends ConsumerWidget {
  const MonthlyChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded = ref.watch(collapsibleSectionsStateProvider)[ProfileSections.monthly] ?? true;
    final timePeriod = ref.watch(globalTimePeriodProvider);

    final title = switch (timePeriod) {
      TimePeriod.oneWeek => 'Last 7 Days',
      TimePeriod.oneMonth => 'Last 30 Days',
      TimePeriod.oneYear || TimePeriod.all => 'Last 12 Months',
    };

    return CollapsibleSection(
      title: title,
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.monthly),
      child: const _MonthlyChartContent(),
    );
  }
}

/// Content widget that maintains previous data during loading transitions
/// to enable smooth chart animations between filter changes.
class _MonthlyChartContent extends ConsumerStatefulWidget {
  const _MonthlyChartContent();

  @override
  ConsumerState<_MonthlyChartContent> createState() => _MonthlyChartContentState();
}

class _MonthlyChartContentState extends ConsumerState<_MonthlyChartContent> {
  List<MonthlyCategoryData>? _cachedData;
  Map<String, Color>? _cachedCategoryColors;

  @override
  Widget build(BuildContext context) {
    final monthlyDataAsync = ref.watch(filteredMonthlyChartDataProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);
    final timePeriod = ref.watch(globalTimePeriodProvider);

    return categoriesAsync.when(
      data: (categories) {
        final categoryColors = {
          for (final c in categories)
            c.activityCategoryId: Color(int.parse('FF${c.hexColor.replaceFirst('#', '')}', radix: 16)),
        };

        // Get current or cached data
        final data = monthlyDataAsync.value ?? _cachedData;
        final hasError = monthlyDataAsync.hasError && _cachedData == null;

        // Update cache when we have new data
        if (monthlyDataAsync.hasValue) {
          _cachedData = monthlyDataAsync.value;
          _cachedCategoryColors = categoryColors;
        }

        // Show shimmer only on initial load
        if (data == null) {
          return const _MonthlyChartShimmer();
        }

        // Show error only if we have no cached data
        if (hasError) {
          return _MonthlyChartError(
            onRetry: () => ref.invalidate(filteredMonthlyChartDataProvider),
          );
        }

        // Show empty state immediately (not stale cached chart)
        if (data.isEmpty) {
          return const _EmptyState();
        }

        return _MonthlyChart(
          data: data,
          categoryColors: _cachedCategoryColors ?? categoryColors,
          timePeriod: timePeriod,
        );
      },
      loading: () => const _MonthlyChartShimmer(),
      error: (_, __) => const _MonthlyChartShimmer(),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({
    required this.data,
    required this.categoryColors,
    required this.timePeriod,
  });

  final List<MonthlyCategoryData> data;
  final Map<String, Color> categoryColors;
  final TimePeriod timePeriod;

  static const List<String> monthLabels = [
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
  static const List<String> dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const double chartHeight = 155;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periods = _generatePeriods();

    // Group data by period key
    final periodGroups = <DateTime, List<MonthlyCategoryData>>{};
    for (final item in data) {
      final key = _periodKeyForItem(item);
      periodGroups.putIfAbsent(key, () => []).add(item);
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

    // Calculate max total for Y axis
    var maxTotal = 0.0;
    for (final period in periods) {
      final items = periodGroups[period] ?? [];
      final total = items.fold(0, (sum, item) => sum + item.activityCount);
      if (total > maxTotal) maxTotal = total.toDouble();
    }

    // Build bar groups
    final barGroups = <BarChartGroupData>[];
    for (var i = 0; i < periods.length; i++) {
      final period = periods[i];
      final items = periodGroups[period] ?? [];

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
            item.activityCategoryId != null ? categoryColors[item.activityCategoryId] ?? Colors.grey : Colors.grey,
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
                  if (index < 0 || index >= periods.length) {
                    return const SizedBox.shrink();
                  }
                  return _buildLabel(theme, periods[index], index, periods.length);
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

  /// Generates the list of period start dates based on time period.
  List<DateTime> _generatePeriods() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (timePeriod) {
      case TimePeriod.oneWeek:
        // Last 7 days, most recent on the left
        return List.generate(7, (i) => today.subtract(Duration(days: i)));

      case TimePeriod.oneMonth:
        // Rolling 7-day windows anchored from today, most recent on the left
        // e.g. Jan 31 (covers Jan 25-31), Jan 24 (covers Jan 18-24), etc.
        return List.generate(5, (i) => today.subtract(Duration(days: i * 7)));

      case TimePeriod.oneYear:
      case TimePeriod.all:
        // Last 12 months, most recent on the left
        return List.generate(12, (i) {
          final date = DateTime(now.year, now.month - i);
          return DateTime(date.year, date.month);
        });
    }
  }

  /// Returns the period key for a data item (normalizes to the period bucket).
  DateTime _periodKeyForItem(MonthlyCategoryData item) {
    switch (timePeriod) {
      case TimePeriod.oneWeek:
        return DateTime(item.activityMonth.year, item.activityMonth.month, item.activityMonth.day);

      case TimePeriod.oneMonth:
        // Bucket into rolling 7-day windows anchored from today
        final date = DateTime(item.activityMonth.year, item.activityMonth.month, item.activityMonth.day);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final daysAgo = today.difference(date).inDays;
        final windowIndex = daysAgo ~/ 7;
        return today.subtract(Duration(days: windowIndex * 7));

      case TimePeriod.oneYear:
      case TimePeriod.all:
        return DateTime(item.activityMonth.year, item.activityMonth.month);
    }
  }

  /// Builds the x-axis label for a period.
  Widget _buildLabel(ThemeData theme, DateTime period, int index, int total) {
    String label;
    bool shouldShow;

    switch (timePeriod) {
      case TimePeriod.oneWeek:
        label = dayLabels[period.weekday - 1];
        shouldShow = true; // Show all 7 days

      case TimePeriod.oneMonth:
        label = '${monthLabels[period.month - 1]} ${period.day}';
        shouldShow = true; // Show all week labels

      case TimePeriod.oneYear:
      case TimePeriod.all:
        label = monthLabels[period.month - 1];
        shouldShow = index % 2 == 0; // Skip every other month label
    }

    if (!shouldShow) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
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
            LucideIcons.chartColumn,
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
            LucideIcons.circleAlert,
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
