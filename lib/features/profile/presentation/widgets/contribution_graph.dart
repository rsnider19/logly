import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/contribution_provider.dart';
import 'package:logly/features/profile/presentation/providers/profile_filter_provider.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';
import 'package:logly/features/profile/presentation/widgets/contribution_legend.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// GitHub-style contribution graph color mapping.
abstract class ContributionColors {
  static const Color level1 = Color(0xFF033A16);
  static const Color level2 = Color(0xFF196C2E);
  static const Color level3 = Color(0xFF2EA043);
  static const Color level4 = Color(0xFF56D364);

  /// Returns the appropriate color for a given activity count.
  /// [emptyColor] is used for count == 0 (typically from theme).
  static Color getColorForCount(int count, {required Color emptyColor}) {
    if (count == 0) return emptyColor;
    if (count < 2) return level1;
    if (count < 4) return level2;
    if (count < 6) return level3;
    return level4;
  }

  /// Returns all levels including the empty color for legend display.
  static List<Color> getLevels({required Color emptyColor}) {
    return [emptyColor, level1, level2, level3, level4];
  }
}

/// Card displaying a GitHub-style contribution graph for the last year.
class ContributionCard extends ConsumerWidget {
  const ContributionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded = ref.watch(collapsibleSectionsStateProvider)[ProfileSections.contribution] ?? true;

    return CollapsibleSection(
      title: 'Activities Last Year',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.contribution),
      child: const _CachedContributionContent(),
    );
  }
}

class _CachedContributionContent extends ConsumerStatefulWidget {
  const _CachedContributionContent();

  @override
  ConsumerState<_CachedContributionContent> createState() => _CachedContributionContentState();
}

class _CachedContributionContentState extends ConsumerState<_CachedContributionContent> {
  Map<DateTime, int>? _cachedData;

  @override
  Widget build(BuildContext context) {
    final contributionAsync = ref.watch(contributionDataProvider);
    final timePeriod = ref.watch(globalTimePeriodProvider);

    final data = contributionAsync.value ?? _cachedData;
    final hasError = contributionAsync.hasError && _cachedData == null;

    if (contributionAsync.hasValue) {
      _cachedData = contributionAsync.value;
    }

    if (data == null) {
      return const _ContributionShimmer();
    }

    if (hasError) {
      return _ContributionError(
        onRetry: () => ref.invalidate(contributionDataProvider),
      );
    }

    return _ContributionContent(data: data, timePeriod: timePeriod);
  }
}

class _ContributionContent extends StatelessWidget {
  const _ContributionContent({required this.data, required this.timePeriod});

  final Map<DateTime, int> data;
  final TimePeriod timePeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContributionGraph(data: data, timePeriod: timePeriod),
        const SizedBox(height: 8),
        const ContributionLegend(),
      ],
    );
  }
}

class _ContributionGraph extends StatelessWidget {
  const _ContributionGraph({required this.data, required this.timePeriod});

  final Map<DateTime, int> data;
  final TimePeriod timePeriod;

  static const double cellSize = 16;
  static const double cellGap = 4;
  static const int rows = 7;
  static const int columns = 53;
  static const double labelWidth = 28;

  // Day labels: Mon (row 1), Wed (row 3), Fri (row 5)
  static const Map<int, String> _dayLabels = {
    1: 'Mon',
    3: 'Wed',
    5: 'Fri',
  };

  static const List<String> _months = [
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    // Calculate the time period start date for opacity
    final periodStartDate = _getPeriodStartDate(todayNormalized);
    final shouldDim = timePeriod == TimePeriod.oneWeek || timePeriod == TimePeriod.oneMonth;

    // Find the starting Sunday for the graph (approximately 1 year ago)
    final startDate = todayNormalized.subtract(Duration(days: (columns - 1) * 7 + todayNormalized.weekday % 7));

    final monthLabels = _calculateMonthLabelPositions(startDate, todayNormalized);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month labels row
          _buildMonthLabelsRow(theme, monthLabels),
          const SizedBox(height: 4),
          // Grid with day labels and week columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day labels column (Mon, Wed, Fri)
              Padding(
                padding: const EdgeInsets.only(right: cellGap),
                child: Column(
                  children: List.generate(rows, (dayIndex) {
                    final label = _dayLabels[dayIndex];
                    return SizedBox(
                      width: labelWidth,
                      height: cellSize + cellGap,
                      child: label != null
                          ? Text(
                              label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                    );
                  }),
                ),
              ),
              // Weeks in reverse order (today on left)
              ...List.generate(columns, (index) {
                final weekIndex = columns - 1 - index; // Reverse order
                return Padding(
                  padding: const EdgeInsets.only(right: cellGap),
                  child: Column(
                    children: List.generate(rows, (dayIndex) {
                      final date = startDate.add(Duration(days: weekIndex * 7 + dayIndex));
                      final normalizedDate = DateTime(date.year, date.month, date.day);

                      // Don't show future dates
                      if (normalizedDate.isAfter(todayNormalized)) {
                        return const SizedBox(
                          width: cellSize,
                          height: cellSize + cellGap,
                        );
                      }

                      final count = data[normalizedDate] ?? 0;
                      final color = ContributionColors.getColorForCount(
                        count,
                        emptyColor: theme.colorScheme.surfaceContainerHighest,
                      );

                      // Apply dimming for cells outside the selected time window
                      final isOutOfRange = shouldDim && normalizedDate.isBefore(periodStartDate);
                      final effectiveColor = isOutOfRange ? color.withValues(alpha: 0.1) : color;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: cellGap),
                        child: Tooltip(
                          message: '${_formatDate(normalizedDate)}: $count activities',
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: cellSize,
                            height: cellSize,
                            decoration: BoxDecoration(
                              color: effectiveColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Returns the start date for the selected time period.
  DateTime _getPeriodStartDate(DateTime today) {
    return switch (timePeriod) {
      TimePeriod.oneWeek => today.subtract(const Duration(days: 6)),
      TimePeriod.oneMonth => today.subtract(const Duration(days: 29)),
      TimePeriod.oneYear => today.subtract(const Duration(days: 364)),
      TimePeriod.all => DateTime(2000),
    };
  }

  /// Calculates column positions for month labels.
  /// Returns a map of column index to 3-letter month abbreviation.
  Map<int, String> _calculateMonthLabelPositions(DateTime startDate, DateTime today) {
    final labels = <int, String>{};
    final labeledMonths = <int>{}; // Track year*100+month to handle year transitions
    var lastLabelColumn = -3; // Allow column 0 without spacing constraint

    for (var colIndex = 0; colIndex < columns; colIndex++) {
      final weekIndex = columns - 1 - colIndex; // Same reversal as the grid

      // Check days in this week for unlabeled months
      for (var dayIndex = 0; dayIndex < rows; dayIndex++) {
        final date = startDate.add(Duration(days: weekIndex * 7 + dayIndex));
        if (date.isAfter(today)) continue;

        final monthKey = date.year * 100 + date.month;
        if (!labeledMonths.contains(monthKey)) {
          // Found an unlabeled month - calculate label position
          var labelColumn = colIndex;

          // Apply minimum 2-column spacing
          if (labelColumn - lastLabelColumn < 2) {
            labelColumn = lastLabelColumn + 2;
          }

          if (labelColumn >= columns) break;

          labels[labelColumn] = _months[date.month - 1];
          labeledMonths.add(monthKey);
          lastLabelColumn = labelColumn;
          break;
        }
      }
    }

    return labels;
  }

  Widget _buildMonthLabelsRow(ThemeData theme, Map<int, String> monthLabels) {
    return Row(
      children: [
        // Empty space to align with day labels column
        SizedBox(width: labelWidth + cellGap),
        // Month label cells
        ...List.generate(columns, (colIndex) {
          final label = monthLabels[colIndex];
          return SizedBox(
            width: cellSize + cellGap,
            child: label != null
                ? Text(
                    label,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _ContributionShimmer extends StatelessWidget {
  const _ContributionShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: (_ContributionGraph.cellSize + _ContributionGraph.cellGap) * _ContributionGraph.rows,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        const ContributionLegend(),
      ],
    );
  }
}

class _ContributionError extends StatelessWidget {
  const _ContributionError({required this.onRetry});

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
            'Failed to load contribution data',
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
