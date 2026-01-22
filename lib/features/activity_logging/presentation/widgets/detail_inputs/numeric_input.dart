import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/snapping_slider.dart';

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
    _controller = TextEditingController(text: _isInteger ? '0' : '0.00');
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
  double get _sliderInterval => widget.activityDetail.sliderInterval ?? (_isInteger ? 1 : 0.1);

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
    _controller.text = _formatValue(adjustedValue);

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
                  const Spacer(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.numberWithOptions(decimal: !_isInteger),
                      textAlign: TextAlign.right,
                      textAlignVertical: TextAlignVertical.center,
                      style: theme.textTheme.bodyLarge,
                      inputFormatters: [
                        if (_isInteger)
                          FilteringTextInputFormatter.digitsOnly
                        else
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
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SnappingSlider(
          value: currentValue,
          min: _minValue,
          max: _maxValue,
          interval: _sliderInterval,
          onChanged: _onSliderChanged,
        ),
      ],
    );
  }
}
