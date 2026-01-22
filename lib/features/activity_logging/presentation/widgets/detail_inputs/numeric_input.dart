import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

/// Generic numeric input widget for integer and double values.
///
/// Supports min/max bounds from [ActivityDetail] and includes a slider for
/// quick adjustment. Stores via [ActivityFormStateNotifier.setNumericValue].
class NumericInput extends ConsumerStatefulWidget {
  const NumericInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<NumericInput> createState() => _NumericInputState();
}

class _NumericInputState extends ConsumerState<NumericInput> {
  late TextEditingController _controller;

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

  bool get _isInteger => widget.activityDetail.activityDetailType == ActivityDetailType.integer;

  double get _minValue => widget.activityDetail.minNumeric ?? 0;
  double get _maxValue => widget.activityDetail.maxNumeric ?? 100;

  int get _divisions {
    final range = _maxValue - _minValue;
    final interval = widget.activityDetail.sliderInterval ?? (_isInteger ? 1 : 0.1);
    return (range / interval).round().clamp(1, 1000);
  }

  void _initializeFromState() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final value = detailValue?.numericValue;

    if (value != null) {
      _controller.text = _formatValue(value);
    }
  }

  String _formatValue(double value) {
    if (_isInteger) {
      return value.round().toString();
    }
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _updateValue(String text) {
    final value = double.tryParse(text);
    if (value != null) {
      ref.read(activityFormStateProvider.notifier).setNumericValue(
            widget.activityDetail.activityDetailId,
            _isInteger ? value.roundToDouble() : value,
          );
    } else {
      ref.read(activityFormStateProvider.notifier).setNumericValue(
            widget.activityDetail.activityDetailId,
            null,
          );
    }
  }

  void _onSliderChanged(double value) {
    final adjustedValue = _isInteger ? value.roundToDouble() : value;
    setState(() {
      _controller.text = _formatValue(adjustedValue);
    });

    ref.read(activityFormStateProvider.notifier).setNumericValue(
          widget.activityDetail.activityDetailId,
          adjustedValue,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final currentValue = detailValue?.numericValue ?? _minValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.activityDetail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: !_isInteger),
          inputFormatters: [
            if (_isInteger)
              FilteringTextInputFormatter.digitsOnly
            else
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter ${widget.activityDetail.label.toLowerCase()}',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          onChanged: _updateValue,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              _formatValue(_minValue),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Slider(
                value: currentValue.clamp(_minValue, _maxValue),
                min: _minValue,
                max: _maxValue,
                divisions: _divisions,
                label: _formatValue(currentValue),
                onChanged: _onSliderChanged,
              ),
            ),
            Text(
              _formatValue(_maxValue),
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
