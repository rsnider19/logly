import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

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
    _hoursController = TextEditingController();
    _minutesController = TextEditingController();
    _secondsController = TextEditingController();
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

    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    _hoursController.text = hours > 0 ? hours.toString() : '';
    _minutesController.text = minutes > 0 || hours > 0 ? minutes.toString() : '';
    _secondsController.text = seconds > 0 || minutes > 0 || hours > 0 ? seconds.toString() : '';
  }

  int get _totalSeconds {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  int get _minSeconds => widget.activityDetail.minDurationInSec ?? 0;
  int get _maxSeconds => widget.activityDetail.maxDurationInSec ?? 10800; // Default 3 hours

  void _updateValue() {
    final totalSeconds = _totalSeconds;
    ref.read(activityFormStateProvider.notifier).setDurationValue(
          widget.activityDetail.activityDetailId,
          totalSeconds > 0 ? totalSeconds : null,
        );
  }

  void _onSliderChanged(double value) {
    final totalSeconds = value.round();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    setState(() {
      _hoursController.text = hours > 0 ? hours.toString() : '';
      _minutesController.text = minutes > 0 || hours > 0 ? minutes.toString() : '';
      _secondsController.text = seconds > 0 ? seconds.toString() : '';
    });

    ref.read(activityFormStateProvider.notifier).setDurationValue(
          widget.activityDetail.activityDetailId,
          totalSeconds > 0 ? totalSeconds : null,
        );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
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
        Text(
          widget.activityDetail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _TimeField(
                controller: _hoursController,
                label: 'Hours',
                maxValue: 99,
                onChanged: (_) => _updateValue(),
              ),
            ),
            const SizedBox(width: 8),
            Text(':', style: theme.textTheme.headlineSmall),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                controller: _minutesController,
                label: 'Min',
                maxValue: 59,
                onChanged: (_) => _updateValue(),
              ),
            ),
            const SizedBox(width: 8),
            Text(':', style: theme.textTheme.headlineSmall),
            const SizedBox(width: 8),
            Expanded(
              child: _TimeField(
                controller: _secondsController,
                label: 'Sec',
                maxValue: 59,
                onChanged: (_) => _updateValue(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              _formatDuration(_minSeconds),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Slider(
                value: currentSeconds.toDouble().clamp(_minSeconds.toDouble(), _maxSeconds.toDouble()),
                min: _minSeconds.toDouble(),
                max: _maxSeconds.toDouble(),
                divisions: _maxSeconds > _minSeconds ? (_maxSeconds - _minSeconds) ~/ 60 : 1,
                label: _formatDuration(currentSeconds),
                onChanged: _onSliderChanged,
              ),
            ),
            Text(
              _formatDuration(_maxSeconds),
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

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.controller,
    required this.label,
    required this.maxValue,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final int maxValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _MaxValueInputFormatter(maxValue),
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
