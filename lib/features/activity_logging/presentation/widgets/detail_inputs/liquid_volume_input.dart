import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/snapping_slider.dart';

/// Input widget for liquid volume values with unit toggle (L/fl oz).
///
/// Includes a slider for quick adjustment and stores the value as liters
/// via [ActivityFormStateNotifier.setLiquidVolumeValue].
class LiquidVolumeInput extends ConsumerStatefulWidget {
  const LiquidVolumeInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<LiquidVolumeInput> createState() => _LiquidVolumeInputState();
}

enum _UnitSystem { metric, imperial }

class _LiquidVolumeInputState extends ConsumerState<LiquidVolumeInput> {
  late TextEditingController _controller;
  _UnitSystem _unitSystem = _UnitSystem.metric;

  // Conversion constants
  static const double _litersPerFluidOunce = 0.0295735;
  static const double _litersPerGallon = 3.78541;
  static const double _millilitersPerLiter = 1000;

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
    final liters = detailValue?.liquidVolumeInLiters;

    if (liters != null && liters > 0) {
      final displayValue = _useMetric ? _litersToDisplayMetric(liters) : _litersToDisplayImperial(liters);
      _controller.text = _formatNumber(displayValue);
    }
  }

  double _litersToDisplayMetric(double liters) {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.milliliters => liters * _millilitersPerLiter,
      MetricUom.liters || null => liters,
      _ => liters,
    };
  }

  double _litersToDisplayImperial(double liters) {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.gallons => liters / _litersPerGallon,
      ImperialUom.fluidOunces || null => liters / _litersPerFluidOunce,
      _ => liters / _litersPerFluidOunce,
    };
  }

  double _displayToLiters(double displayValue) {
    if (_useMetric) {
      return switch (widget.activityDetail.metricUom) {
        MetricUom.milliliters => displayValue / _millilitersPerLiter,
        MetricUom.liters || null => displayValue,
        _ => displayValue,
      };
    } else {
      return switch (widget.activityDetail.imperialUom) {
        ImperialUom.gallons => displayValue * _litersPerGallon,
        ImperialUom.fluidOunces || null => displayValue * _litersPerFluidOunce,
        _ => displayValue * _litersPerFluidOunce,
      };
    }
  }

  String get _metricUnitLabel {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.milliliters => 'mL',
      MetricUom.liters || null => 'L',
      _ => 'L',
    };
  }

  String get _imperialUnitLabel {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.gallons => 'gal',
      ImperialUom.fluidOunces || null => 'oz',
      _ => 'oz',
    };
  }

  double get _minLiters => widget.activityDetail.minLiquidVolumeInLiters ?? 0;
  double get _maxLiters => widget.activityDetail.maxLiquidVolumeInLiters ?? 5;

  double get _minDisplay => _useMetric ? _litersToDisplayMetric(_minLiters) : _litersToDisplayImperial(_minLiters);
  double get _maxDisplay => _useMetric ? _litersToDisplayMetric(_maxLiters) : _litersToDisplayImperial(_maxLiters);
  double get _sliderInterval => widget.activityDetail.sliderInterval ?? 0.1;

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  void _updateValue(String text) {
    final displayValue = double.tryParse(text);
    if (displayValue != null && displayValue > 0) {
      final liters = _displayToLiters(displayValue);
      ref.read(activityFormStateProvider.notifier).setLiquidVolumeValue(
            widget.activityDetail.activityDetailId,
            liters,
          );
    } else {
      ref.read(activityFormStateProvider.notifier).setLiquidVolumeValue(
            widget.activityDetail.activityDetailId,
            null,
          );
    }
  }

  void _onSliderChanged(double displayValue) {
    _controller.text = _formatNumber(displayValue);

    final liters = _displayToLiters(displayValue);
    ref.read(activityFormStateProvider.notifier).setLiquidVolumeValue(
          widget.activityDetail.activityDetailId,
          liters > 0 ? liters : null,
        );
  }

  void _onUnitSystemChanged(_UnitSystem? newSystem) {
    if (newSystem == null) return;

    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final liters = detailValue?.liquidVolumeInLiters ?? 0;

    setState(() {
      _unitSystem = newSystem;
      if (liters > 0) {
        final displayValue = _useMetric ? _litersToDisplayMetric(liters) : _litersToDisplayImperial(liters);
        _controller.text = _formatNumber(displayValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final liters = detailValue?.liquidVolumeInLiters ?? 0;
    final currentDisplay = _useMetric ? _litersToDisplayMetric(liters) : _litersToDisplayImperial(liters);

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
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.colorScheme.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: theme.colorScheme.outline),
                        ),
                      ),
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
