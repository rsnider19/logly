import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/weekly_radar_provider.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';

/// Card displaying weekly activity as a radar chart by day of week.
class WeeklyRadarChartCard extends ConsumerWidget {
  const WeeklyRadarChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded = ref.watch(collapsibleSectionsStateProvider)[ProfileSections.weeklyRadar] ?? true;
    final normalizedDataAsync = ref.watch(normalizedRadarDataProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

    return CollapsibleSection(
      title: 'Weekly Activity',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.weeklyRadar),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TimePeriodSelector(),
          const SizedBox(height: 16),
          normalizedDataAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return const _EmptyState();
              }

              return categoriesAsync.when(
                data: (categories) {
                  // Build category color map
                  final categoryColors = {
                    for (final c in categories)
                      c.activityCategoryId: Color(int.parse('FF${c.hexColor.replaceFirst('#', '')}', radix: 16)),
                  };

                  // Sort categories by sortOrder for consistent layering
                  final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

                  return _WeeklyRadarChart(
                    normalizedData: data,
                    categoryColors: categoryColors,
                    categoryOrder: sortedCategories.map((c) => c.activityCategoryId).toList(),
                  );
                },
                loading: () => const _RadarChartShimmer(),
                error: (_, __) => const _RadarChartShimmer(),
              );
            },
            loading: () => const _RadarChartShimmer(),
            error: (error, _) => _RadarChartError(
              onRetry: () => ref.invalidate(normalizedRadarDataProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePeriodSelector extends ConsumerWidget {
  const _TimePeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedRadarTimePeriodStateProvider);
    final notifier = ref.watch(selectedRadarTimePeriodStateProvider.notifier);

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
              onSelected: (_) => notifier.select(period),
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

class _WeeklyRadarChart extends StatelessWidget {
  const _WeeklyRadarChart({
    required this.normalizedData,
    required this.categoryColors,
    required this.categoryOrder,
  });

  final Map<String, List<double>> normalizedData;
  final Map<String, Color> categoryColors;
  final List<String> categoryOrder;

  static const List<String> dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const double chartSize = 200;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build radar data sets in category order (for consistent stacking)
    // Reversed so lowest sortOrder is drawn last (on top)
    final dataSets = <RadarDataSet>[];
    for (final categoryId in categoryOrder.reversed) {
      final values = normalizedData[categoryId];
      if (values == null) continue;

      final color = categoryColors[categoryId] ?? Colors.grey;
      dataSets.add(
        RadarDataSet(
          dataEntries: values.map((v) => RadarEntry(value: v)).toList(),
          fillColor: color.withValues(alpha: 0.3),
          borderColor: color,
          borderWidth: 2,
          entryRadius: 0, // No dots on vertices
        ),
      );
    }

    return SizedBox(
      height: chartSize + 48, // Extra space for labels
      child: RadarChart(
        RadarChartData(
          dataSets: dataSets,
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
          tickBorderData: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          gridBorderData: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          tickCount: 4, // 25%, 50%, 75%, 100% rings
          ticksTextStyle: const TextStyle(fontSize: 0), // Hide tick labels
          titlePositionPercentageOffset: 0.15,
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: dayLabels[index],
              angle: 0, // Keep text horizontal
              positionPercentageOffset: 0.05,
            );
          },
          titleTextStyle: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
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
            LucideIcons.radar,
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

class _RadarChartShimmer extends StatelessWidget {
  const _RadarChartShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: _WeeklyRadarChart.chartSize + 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _RadarChartError extends StatelessWidget {
  const _RadarChartError({required this.onRetry});

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
            'Failed to load weekly data',
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
