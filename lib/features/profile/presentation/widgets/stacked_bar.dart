import 'package:flutter/material.dart';

/// A single stacked bar representing one month's activity breakdown.
class StackedBar extends StatelessWidget {
  const StackedBar({
    required this.monthLabel,
    required this.segments,
    required this.maxHeight,
    super.key,
  });

  /// Short month label (e.g., "Jan").
  final String monthLabel;

  /// Segments to display, each with count and color.
  final List<StackedBarSegment> segments;

  /// Maximum height for scaling (based on max total across all bars).
  final double maxHeight;

  static const double barWidth = 24;
  static const double maxBarHeight = 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = segments.fold(0, (sum, s) => sum + s.count);
    final scaledHeight = maxHeight > 0 ? (total / maxHeight) * maxBarHeight : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: barWidth,
          height: maxBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (total > 0)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: scaledHeight,
                    child: Column(
                      children: segments.reversed.map((segment) {
                        final segmentHeight = total > 0 ? (segment.count / total) * scaledHeight : 0.0;
                        return Container(
                          height: segmentHeight,
                          color: segment.color,
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          monthLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A segment within a stacked bar.
class StackedBarSegment {
  const StackedBarSegment({
    required this.categoryId,
    required this.count,
    required this.color,
  });

  final String? categoryId;
  final int count;
  final Color color;
}
