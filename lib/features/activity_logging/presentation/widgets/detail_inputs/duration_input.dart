import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/snapping_slider.dart';

/// Input widget for duration values with hours, minutes, and seconds fields.
///
/// Includes a slider for quick adjustment and stores the value as seconds
/// via [ActivityFormStateNotifier.setDurationValue].
class DurationInput extends ConsumerStatefulWidget {
  const DurationInput({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  ConsumerState<DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends ConsumerState<DurationInput> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController(text: '00');
    _minutesController = TextEditingController(text: '00');
    _secondsController = TextEditingController(text: '00');
    _initializeFromState();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _initializeFromState() {
    final formState = ref.read(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final totalSeconds = detailValue?.durationInSec ?? 0;
    _updateControllersFromSeconds(totalSeconds);
  }

  void _updateControllersFromSeconds(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    _hoursController.text = hours.toString().padLeft(2, '0');
    _minutesController.text = minutes.toString().padLeft(2, '0');
    _secondsController.text = seconds.toString().padLeft(2, '0');
  }

  int get _totalSeconds {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  int get _minSeconds => widget.activityDetail.minDurationInSec ?? 0;
  int get _maxSeconds => widget.activityDetail.maxDurationInSec ?? 10800;
  double get _sliderInterval => widget.activityDetail.sliderInterval ?? 60;

  void _updateValue() {
    final totalSeconds = _totalSeconds;
    ref.read(activityFormStateProvider.notifier).setDurationValue(
          widget.activityDetail.activityDetailId,
          totalSeconds > 0 ? totalSeconds : null,
        );
  }

  void _onSliderChanged(double value) {
    final totalSeconds = value.round();
    _updateControllersFromSeconds(totalSeconds);
    ref.read(activityFormStateProvider.notifier).setDurationValue(
          widget.activityDetail.activityDetailId,
          totalSeconds > 0 ? totalSeconds : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[widget.activityDetail.activityDetailId];
    final currentSeconds = detailValue?.durationInSec ?? 0;

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
                    child: _TimeField(
                      controller: _hoursController,
                      suffix: 'h',
                      maxValue: 99,
                      onChanged: (_) => _updateValue(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TimeField(
                      controller: _minutesController,
                      suffix: 'm',
                      maxValue: 59,
                      onChanged: (_) => _updateValue(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TimeField(
                      controller: _secondsController,
                      suffix: 's',
                      maxValue: 59,
                      onChanged: (_) => _updateValue(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SnappingSlider(
          value: currentSeconds.toDouble(),
          min: _minSeconds.toDouble(),
          max: _maxSeconds.toDouble(),
          interval: _sliderInterval,
          onChanged: _onSliderChanged,
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.controller,
    required this.suffix,
    required this.maxValue,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String suffix;
  final int maxValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        style: theme.textTheme.bodyLarge,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
          _MaxValueInputFormatter(maxValue),
        ],
        decoration: InputDecoration(
          suffixText: suffix,
          suffixStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
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
        onChanged: onChanged,
      );
  }
}

class _MaxValueInputFormatter extends TextInputFormatter {
  _MaxValueInputFormatter(this.maxValue);

  final int maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final intValue = int.tryParse(newValue.text);
    if (intValue == null) return oldValue;
    if (intValue > maxValue) {
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }
    return newValue;
  }
}
