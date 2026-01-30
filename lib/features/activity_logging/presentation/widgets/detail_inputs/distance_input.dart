import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/snapping_slider.dart';

/// Input widget for distance values with unit toggle (km/miles).
///
/// Includes a slider for quick adjustment and stores the value as meters
/// via [ActivityFormStateNotifier.setDistanceValue].
class DistanceInput extends ConsumerStatefulWidget {
  const DistanceInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<DistanceInput> createState() => _DistanceInputState();
}

enum _UnitSystem { metric, imperial }

class _DistanceInputState extends ConsumerState<DistanceInput> {
  late TextEditingController _controller;
  _UnitSystem _unitSystem = _UnitSystem.metric;

  // Conversion constants
  static const double _metersPerKilometer = 1000;
  static const double _metersPerMile = 1609.344;
  static const double _metersPerYard = 0.9144;

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
    final meters = detailValue?.distanceInMeters;

    if (meters != null && meters > 0) {
      final displayValue = _useMetric ? _metersToDisplayMetric(meters) : _metersToDisplayImperial(meters);
      _controller.text = _formatNumber(displayValue);
    }
  }

  double _metersToDisplayMetric(double meters) {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.meters => meters,
      MetricUom.kilometers || null => meters / _metersPerKilometer,
      _ => meters / _metersPerKilometer,
    };
  }

  double _metersToDisplayImperial(double meters) {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.yards => meters / _metersPerYard,
      ImperialUom.miles || null => meters / _metersPerMile,
      _ => meters / _metersPerMile,
    };
  }

  double _displayToMeters(double displayValue) {
    if (_useMetric) {
      return switch (widget.activityDetail.metricUom) {
        MetricUom.meters => displayValue,
        MetricUom.kilometers || null => displayValue * _metersPerKilometer,
        _ => displayValue * _metersPerKilometer,
      };
    } else {
      return switch (widget.activityDetail.imperialUom) {
        ImperialUom.yards => displayValue * _metersPerYard,
        ImperialUom.miles || null => displayValue * _metersPerMile,
        _ => displayValue * _metersPerMile,
      };
    }
  }

  String get _metricUnitLabel {
    return switch (widget.activityDetail.metricUom) {
      MetricUom.meters => 'm',
      MetricUom.kilometers || null => 'km',
      _ => 'km',
    };
  }

  String get _imperialUnitLabel {
    return switch (widget.activityDetail.imperialUom) {
      ImperialUom.yards => 'yd',
      ImperialUom.miles || null => 'mi',
      _ => 'mi',
    };
  }

  double get _minMeters => widget.activityDetail.minDistanceInMeters ?? 0;
  double get _maxMeters => widget.activityDetail.maxDistanceInMeters ?? 42195;

  double get _minDisplay => _useMetric ? _metersToDisplayMetric(_minMeters) : _metersToDisplayImperial(_minMeters);
  double get _maxDisplay => _useMetric ? _metersToDisplayMetric(_maxMeters) : _metersToDisplayImperial(_maxMeters);
  double get _sliderInterval => widget.activityDetail.sliderInterval ?? 0.1;

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  void _updateValue(String text) {
    final displayValue = double.tryParse(text);
    if (displayValue != null && displayValue > 0) {
      final meters = _displayToMeters(displayValue);
      ref
          .read(activityFormStateProvider.notifier)
          .setDistanceValue(
            widget.activityDetail.activityDetailId,
            meters,
          );
    } else {
      ref
          .read(activityFormStateProvider.notifier)
          .setDistanceValue(
            widget.activityDetail.activityDetailId,
            null,
          );
    }
  }

  void _onSliderChanged(double displayValue) {
    _controller.text = _formatNumber(displayValue);

    final meters = _displayToMeters(displayValue);
    ref
        .read(activityFormStateProvider.notifier)
        .setDistanceValue(
          widget.activityDetail.activityDetailId,
          meters > 0 ? meters : null,
        );
  }

  void _onUnitSystemChanged(_UnitSystem? newSystem) {
    if (newSystem == null) return;

    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final meters = detailValue?.distanceInMeters ?? 0;

    setState(() {
      _unitSystem = newSystem;
      if (meters > 0) {
        final displayValue = _useMetric ? _metersToDisplayMetric(meters) : _metersToDisplayImperial(meters);
        _controller.text = _formatNumber(displayValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final meters = detailValue?.distanceInMeters ?? 0;
    final currentDisplay = _useMetric ? _metersToDisplayMetric(meters) : _metersToDisplayImperial(meters);

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
                      cursorHeight: 20,
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
