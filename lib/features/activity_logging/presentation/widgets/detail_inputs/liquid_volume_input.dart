import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

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

class _LiquidVolumeInputState extends ConsumerState<LiquidVolumeInput> {
  late TextEditingController _controller;
  bool _useMetric = true;

  // Conversion constants
  static const double _litersPerFluidOunce = 0.0295735;
  static const double _litersPerGallon = 3.78541;
  static const double _millilitersPerLiter = 1000.0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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

  String get _unitLabel {
    if (_useMetric) {
      return switch (widget.activityDetail.metricUom) {
        MetricUom.milliliters => 'mL',
        MetricUom.liters || null => 'L',
        _ => 'L',
      };
    } else {
      return switch (widget.activityDetail.imperialUom) {
        ImperialUom.gallons => 'gal',
        ImperialUom.fluidOunces || null => 'fl oz',
        _ => 'fl oz',
      };
    }
  }

  double get _minLiters => widget.activityDetail.minLiquidVolumeInLiters ?? 0;
  double get _maxLiters => widget.activityDetail.maxLiquidVolumeInLiters ?? 5; // Default: 5 liters

  double get _minDisplay => _useMetric ? _litersToDisplayMetric(_minLiters) : _litersToDisplayImperial(_minLiters);
  double get _maxDisplay => _useMetric ? _litersToDisplayMetric(_maxLiters) : _litersToDisplayImperial(_maxLiters);

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
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
    setState(() {
      _controller.text = _formatNumber(displayValue);
    });

    final liters = _displayToLiters(displayValue);
    ref.read(activityFormStateProvider.notifier).setLiquidVolumeValue(
          widget.activityDetail.activityDetailId,
          liters > 0 ? liters : null,
        );
  }

  void _toggleUnit() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final liters = detailValue?.liquidVolumeInLiters ?? 0;

    setState(() {
      _useMetric = !_useMetric;
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
        Text(
          widget.activityDetail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixText: _unitLabel,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: _updateValue,
              ),
            ),
            const SizedBox(width: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Metric')),
                ButtonSegment(value: false, label: Text('Imperial')),
              ],
              selected: {_useMetric},
              onSelectionChanged: (_) => _toggleUnit(),
              showSelectedIcon: false,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '${_formatNumber(_minDisplay)} $_unitLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Slider(
                value: currentDisplay.clamp(_minDisplay, _maxDisplay),
                min: _minDisplay,
                max: _maxDisplay,
                divisions: 100,
                label: '${_formatNumber(currentDisplay)} $_unitLabel',
                onChanged: _onSliderChanged,
              ),
            ),
            Text(
              '${_formatNumber(_maxDisplay)} $_unitLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
