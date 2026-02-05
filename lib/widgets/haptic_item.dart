import 'dart:async';

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
  bool _hasFired = false;

  @override
  void didUpdateWidget(HapticItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset if the id changes (e.g. list item recycled).
    if (oldWidget.id != widget.id) {
      _hasFired = false;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (_hasFired || !widget.isEnabled) return;
    if (info.visibleFraction > 0.1) {
      _hasFired = true;
      unawaited(HapticFeedback.lightImpact());
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.id),
      onVisibilityChanged: _onVisibilityChanged,
      child: widget.child,
    );
  }
}
