import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';

/// Form fields for configuring a Number detail.
class NumberDetailForm extends StatefulWidget {
  const NumberDetailForm({
    required this.config,
    required this.onLabelChanged,
    required this.onIsIntegerChanged,
    required this.onMaxValueChanged,
    super.key,
  });

  final NumberDetailConfig config;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<bool> onIsIntegerChanged;
  final ValueChanged<double> onMaxValueChanged;

  @override
  State<NumberDetailForm> createState() => _NumberDetailFormState();
}

class _NumberDetailFormState extends State<NumberDetailForm> {
  late TextEditingController _labelController;
  late TextEditingController _maxValueController;
  late FocusNode _maxValueFocusNode;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.config.label)
      ..selection = TextSelection.collapsed(offset: widget.config.label.length);
    _maxValueController = TextEditingController(
      text: widget.config.isInteger
          ? widget.config.maxValue.toInt().toString()
          : widget.config.maxValue.toString(),
    );
    _maxValueFocusNode = FocusNode()..addListener(_onMaxValueFocusChanged);
  }

  @override
  void didUpdateWidget(NumberDetailForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config.label != widget.config.label && _labelController.text != widget.config.label) {
      _labelController.text = widget.config.label;
      _labelController.selection = TextSelection.collapsed(offset: widget.config.label.length);
    }
    if (oldWidget.config.isInteger != widget.config.isInteger) {
      _maxValueController.text = widget.config.isInteger
          ? widget.config.maxValue.toInt().toString()
          : widget.config.maxValue.toString();
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _maxValueController.dispose();
    _maxValueFocusNode
      ..removeListener(_onMaxValueFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onMaxValueFocusChanged() {
    if (!_maxValueFocusNode.hasFocus && _maxValueController.text.isEmpty) {
      final defaultValue = widget.config.isInteger
          ? widget.config.maxValue.toInt().toString()
          : widget.config.maxValue.toString();
      _maxValueController.text = defaultValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label input
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Label', style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: _labelController,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: widget.config.labelPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                onChanged: widget.onLabelChanged,
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Integer/Decimal toggle
        Row(
          children: [
            Expanded(
              child: CupertinoSlidingSegmentedControl<bool>(
                groupValue: widget.config.isInteger,
                children: const {
                  true: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Integer'),
                  ),
                  false: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Decimal'),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    widget.onIsIntegerChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Max value input
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Maximum', style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: _maxValueController,
                focusNode: _maxValueFocusNode,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: !widget.config.isInteger),
                inputFormatters: [
                  if (widget.config.isInteger)
                    FilteringTextInputFormatter.digitsOnly
                  else
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    widget.onMaxValueChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
