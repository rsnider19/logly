import 'package:flutter/material.dart';

/// A segmented progress bar showing filled segments up to the current step.
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.totalSegments,
    required this.currentSegment,
  });

  /// Total number of segments.
  final int totalSegments;

  /// The currently active segment (1-based). 0 means no segment filled.
  final int currentSegment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: List.generate(totalSegments, (index) {
        final isFilled = index < currentSegment;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index < totalSegments - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isFilled ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
