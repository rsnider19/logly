import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// A widget that triggers a light haptic when it first scrolls into view.
///
/// The parent controls whether haptics fire via [isEnabled].
class HapticItem extends StatefulWidget {
  const HapticItem({
    required this.id,
    required this.isEnabled,
    required this.child,
    super.key,
  });

  /// Unique identifier for the visibility detector.
  final String id;

  /// Whether to fire haptic feedback when this item becomes visible.
  final bool isEnabled;

  /// The child widget to display.
  final Widget child;

  @override
  State<HapticItem> createState() => _HapticItemState();
}

class _HapticItemState extends State<HapticItem> {
  bool _isFirstCallback = true;
  bool hasEntered = false;

  @override
  Widget build(BuildContext context) {
    // Early return when haptics disabled (matches old implementation)
    if (!widget.isEnabled) {
      return widget.child;
    }

    return VisibilityDetector(
      key: ValueKey(widget.id),
      onVisibilityChanged: (info) {
        // Skip the first callback (fires immediately on build for visible items)
        if (_isFirstCallback) {
          _isFirstCallback = false;
          hasEntered = info.visibleFraction > 0.1;
          return;
        }

        final isVisible = info.visibleFraction > 0.1;
        if (isVisible && !hasEntered) {
          HapticFeedback.lightImpact();
        }
        hasEntered = isVisible;
      },
      child: widget.child,
    );
  }
}
