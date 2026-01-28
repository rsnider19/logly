import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// Form fields for configuring a Duration detail.
class DurationDetailForm extends StatefulWidget {
  const DurationDetailForm({
    required this.config,
    required this.onLabelChanged,
    required this.onMaxSecondsChanged,
    required this.onUseForPaceChanged,
    this.paceEnabled = true,
    super.key,
  });

  final DurationDetailConfig config;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<int> onMaxSecondsChanged;
  final ValueChanged<bool> onUseForPaceChanged;
  final bool paceEnabled;

  @override
  State<DurationDetailForm> createState() => _DurationDetailFormState();
}

class _DurationDetailFormState extends State<DurationDetailForm> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    final hours = widget.config.maxSeconds ~/ 3600;
    final minutes = (widget.config.maxSeconds % 3600) ~/ 60;
    final seconds = widget.config.maxSeconds % 60;

    _hoursController = TextEditingController(text: hours.toString());
    _minutesController = TextEditingController(text: minutes.toString());
    _secondsController = TextEditingController(text: seconds.toString());
  }

  @override
  void didUpdateWidget(DurationDetailForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.maxSeconds != widget.config.maxSeconds) {
      _initControllers();
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _updateMaxSeconds() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    final totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    if (totalSeconds > 0) {
      widget.onMaxSecondsChanged(totalSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label input
        TextField(
          decoration: InputDecoration(
            labelText: 'Label',
            hintText: widget.config.labelPlaceholder,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          onChanged: widget.onLabelChanged,
          controller: TextEditingController(text: widget.config.label)
            ..selection = TextSelection.collapsed(offset: widget.config.label.length),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        // Maximum duration input
        Text('Maximum Duration', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _hoursController,
                decoration: const InputDecoration(
                  labelText: 'Hours',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateMaxSeconds(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _minutesController,
                decoration: const InputDecoration(
                  labelText: 'Minutes',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateMaxSeconds(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _secondsController,
                decoration: const InputDecoration(
                  labelText: 'Seconds',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _updateMaxSeconds(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Use for pace calculation toggle
        if (widget.paceEnabled)
          SwitchListTile(
            title: const Text('Use for pace calculation'),
            subtitle: const Text('Mark this duration for pace calculation'),
            value: widget.config.useForPace,
            onChanged: widget.onUseForPaceChanged,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }
}
