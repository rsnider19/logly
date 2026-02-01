import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/snapping_slider.dart';

/// Input widget for weight values with unit toggle (kg/lbs).
///
/// Includes a slider for quick adjustment and stores the value as kilograms
/// via [ActivityFormStateNotifier.setWeightValue].
class WeightInput extends ConsumerStatefulWidget {
  const WeightInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<WeightInput> createState() => _WeightInputState();
}

enum _UnitSystem { metric, imperial }

class _WeightInputState extends ConsumerState<WeightInput> {
  late TextEditingController _controller;
  _UnitSystem _unitSystem = _UnitSystem.metric;

  // Conversion constants
  static const double _kilogramsPerPound = 0.453592;
  static const double _kilogramsPerOunce = 0.0283495;
  static const double _gramsPerKilogram = 1000;

  bool get _useMetric => _unitSystem == _UnitSystem.metric;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0.00');
    _initializeFromState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeFromState() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final kilograms = detailValue?.weightInKilograms;

    if (kilograms != null && kilograms > 0) {
      final displayValue = _useMetric ? _kilogramsToDisplayMetric(kilograms) : _kilogramsToDisplayImperial(kilograms);
      _controller.text = _formatNumber(displayValue);
    }
  }

  double _kilogramsToDisplayMetric(double kilograms) {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.grams => kilograms * _gramsPerKilogram,
      MetricUom.kilograms || null => kilograms,
      _ => kilograms,
    };
  }

  double _kilogramsToDisplayImperial(double kilograms) {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.ounces => kilograms / _kilogramsPerOunce,
      ImperialUom.pounds || null => kilograms / _kilogramsPerPound,
      _ => kilograms / _kilogramsPerPound,
    };
  }

  double _displayToKilograms(double displayValue) {
    if (_useMetric) {
      return switch (widget.activityDetail.metricUom) {
        MetricUom.grams => displayValue / _gramsPerKilogram,
        MetricUom.kilograms || null => displayValue,
        _ => displayValue,
      };
    } else {
      return switch (widget.activityDetail.imperialUom) {
        ImperialUom.ounces => displayValue * _kilogramsPerOunce,
        ImperialUom.pounds || null => displayValue * _kilogramsPerPound,
        _ => displayValue * _kilogramsPerPound,
      };
    }
  }

  String get _metricUnitLabel {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.grams => 'g',
      MetricUom.kilograms || null => 'kg',
      _ => 'kg',
    };
  }

  String get _imperialUnitLabel {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.ounces => 'oz',
      ImperialUom.pounds || null => 'lbs',
      _ => 'lbs',
    };
  }

  double get _minKilograms => widget.activityDetail.minWeightInKilograms ?? 0;
  double get _maxKilograms => widget.activityDetail.maxWeightInKilograms ?? 200;

  double get _minDisplay =>
      _useMetric ? _kilogramsToDisplayMetric(_minKilograms) : _kilogramsToDisplayImperial(_minKilograms);
  double get _maxDisplay =>
      _useMetric ? _kilogramsToDisplayMetric(_maxKilograms) : _kilogramsToDisplayImperial(_maxKilograms);
  double get _sliderInterval => widget.activityDetail.sliderInterval ?? 0.5;

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  void _updateValue(String text) {
    final displayValue = double.tryParse(text);
    if (displayValue != null && displayValue > 0) {
      final kilograms = _displayToKilograms(displayValue);
      ref
          .read(activityFormStateProvider.notifier)
          .setWeightValue(
            widget.activityDetail.activityDetailId,
            kilograms,
          );
    } else {
      ref
          .read(activityFormStateProvider.notifier)
          .setWeightValue(
            widget.activityDetail.activityDetailId,
            null,
          );
    }
  }

  void _onSliderChanged(double displayValue) {
    _controller.text = _formatNumber(displayValue);

    final kilograms = _displayToKilograms(displayValue);
    ref
        .read(activityFormStateProvider.notifier)
        .setWeightValue(
          widget.activityDetail.activityDetailId,
          kilograms > 0 ? kilograms : null,
        );
  }

  void _onUnitSystemChanged(_UnitSystem? newSystem) {
    if (newSystem == null) return;

    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final kilograms = detailValue?.weightInKilograms ?? 0;

    setState(() {
      _unitSystem = newSystem;
      if (kilograms > 0) {
        final displayValue = _useMetric ? _kilogramsToDisplayMetric(kilograms) : _kilogramsToDisplayImperial(kilograms);
        _controller.text = _formatNumber(displayValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final kilograms = detailValue?.weightInKilograms ?? 0;
    final currentDisplay = _useMetric ? _kilogramsToDisplayMetric(kilograms) : _kilogramsToDisplayImperial(kilograms);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                widget.activityDetail.label,
                style: theme.textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: _updateValue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoSlidingSegmentedControl<_UnitSystem>(
                      groupValue: _unitSystem,
                      children: {
                        _UnitSystem.metric: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(_metricUnitLabel),
                        ),
                        _UnitSystem.imperial: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(_imperialUnitLabel),
                        ),
                      },
                      onValueChanged: _onUnitSystemChanged,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SnappingSlider(
          value: currentDisplay,
          min: _minDisplay,
          max: _maxDisplay,
          interval: _sliderInterval,
          onChanged: _onSliderChanged,
        ),
      ],
    );
  }
}
