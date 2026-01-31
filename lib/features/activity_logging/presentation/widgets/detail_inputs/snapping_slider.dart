import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A slider that snaps values to the nearest interval with haptic feedback.
///
/// Unlike the standard [Slider] with divisions, this slider does not show
/// tick marks but still rounds values to the nearest [interval] on change.
/// A selection haptic fires each time the slider moves to a new snap position.
class SnappingSlider extends StatefulWidget {
  const SnappingSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.interval,
    required this.onChanged,
    super.key,
  });

  /// The current value of the slider.
  final double value;

  /// The minimum value the slider can have.
  final double min;

  /// The maximum value the slider can have.
  final double max;

  /// The interval to snap values to.
  final double interval;

  /// Called when the slider value changes, with the snapped value.
  final ValueChanged<double> onChanged;

  @override
  State<SnappingSlider> createState() => _SnappingSliderState();
}

class _SnappingSliderState extends State<SnappingSlider> {
  double? _lastSnappedValue;

  double _snapToInterval(double rawValue) {
    if (widget.interval <= 0) return rawValue;

    final snapped = (rawValue / widget.interval).round() * widget.interval;
    return snapped.clamp(widget.min, widget.max);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
      ),
      child: Slider(
        value: widget.value.clamp(widget.min, widget.max),
        min: widget.min,
        max: widget.max,
        onChanged: (rawValue) {
          final snappedValue = _snapToInterval(rawValue);
          if (snappedValue != _lastSnappedValue) {
            _lastSnappedValue = snappedValue;
            HapticFeedback.selectionClick();
          }
          widget.onChanged(snappedValue);
        },
        onChangeEnd: (_) => _lastSnappedValue = null,
      ),
    );
  }
}
