import 'package:flutter/material.dart';

/// A slider that snaps values to the nearest interval.
///
/// Unlike the standard [Slider] with divisions, this slider does not show
/// tick marks but still rounds values to the nearest [interval] on change.
class SnappingSlider extends StatelessWidget {
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

  double _snapToInterval(double rawValue) {
    if (interval <= 0) return rawValue;

    final snapped = (rawValue / interval).round() * interval;
    return snapped.clamp(min, max);
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
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: (rawValue) {
          final snappedValue = _snapToInterval(rawValue);
          onChanged(snappedValue);
        },
      ),
    );
  }
}
