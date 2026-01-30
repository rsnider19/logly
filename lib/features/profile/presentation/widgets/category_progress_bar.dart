import 'dart:async';

import 'package:flutter/material.dart';

/// An animated horizontal progress bar for a category.
class CategoryProgressBar extends StatefulWidget {
  const CategoryProgressBar({
    required this.categoryName,
    required this.count,
    required this.maxCount,
    required this.color,
    super.key,
  });

  /// Display name of the category.
  final String categoryName;

  /// Activity count for this category.
  final int count;

  /// Maximum count (used to calculate bar width).
  final int maxCount;

  /// Bar color (typically from category hex color).
  final Color color;

  @override
  State<CategoryProgressBar> createState() => _CategoryProgressBarState();
}

class _CategoryProgressBarState extends State<CategoryProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get _targetPercentage => widget.maxCount > 0 ? widget.count / widget.maxCount : 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _updateAnimation(from: 0, to: _targetPercentage);
    unawaited(_controller.forward());
  }

  @override
  void didUpdateWidget(CategoryProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count || oldWidget.maxCount != widget.maxCount) {
      // Use current animation value (not old target) for smooth mid-animation transitions
      final currentValue = _animation.value;
      _updateAnimation(from: currentValue, to: _targetPercentage);
      unawaited(_controller.forward(from: 0));
    }
  }

  void _updateAnimation({required double from, required double to}) {
    _animation = Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoryName,
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '${widget.count}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _animation.value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
