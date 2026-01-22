import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/imperial_uom.dart';
import 'package:logly/features/activity_catalog/domain/metric_uom.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

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

class _DistanceInputState extends ConsumerState<DistanceInput> {
  late TextEditingController _controller;
  bool _useMetric = true;

  // Conversion constants
  static const double _metersPerKilometer = 1000.0;
  static const double _metersPerMile = 1609.344;
  static const double _metersPerYard = 0.9144;

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

  String get _unitLabel {
    if (_useMetric) {
      return switch (widget.activityDetail.metricUom) {
        MetricUom.meters => 'm',
        MetricUom.kilometers || null => 'km',
        _ => 'km',
      };
    } else {
      return switch (widget.activityDetail.imperialUom) {
        ImperialUom.yards => 'yd',
        ImperialUom.miles || null => 'mi',
        _ => 'mi',
      };
    }
  }

  double get _minMeters => widget.activityDetail.minDistanceInMeters ?? 0;
  double get _maxMeters => widget.activityDetail.maxDistanceInMeters ?? 42195; // Default: marathon distance

  double get _minDisplay => _useMetric ? _metersToDisplayMetric(_minMeters) : _metersToDisplayImperial(_minMeters);
  double get _maxDisplay => _useMetric ? _metersToDisplayMetric(_maxMeters) : _metersToDisplayImperial(_maxMeters);

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _updateValue(String text) {
    final displayValue = double.tryParse(text);
    if (displayValue != null && displayValue > 0) {
      final meters = _displayToMeters(displayValue);
      ref.read(activityFormStateProvider.notifier).setDistanceValue(
            widget.activityDetail.activityDetailId,
            meters,
          );
    } else {
      ref.read(activityFormStateProvider.notifier).setDistanceValue(
            widget.activityDetail.activityDetailId,
            null,
          );
    }
  }

  void _onSliderChanged(double displayValue) {
    setState(() {
      _controller.text = _formatNumber(displayValue);
    });

    final meters = _displayToMeters(displayValue);
    ref.read(activityFormStateProvider.notifier).setDistanceValue(
          widget.activityDetail.activityDetailId,
          meters > 0 ? meters : null,
        );
  }

  void _toggleUnit() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final meters = detailValue?.distanceInMeters ?? 0;

    setState(() {
      _useMetric = !_useMetric;
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
