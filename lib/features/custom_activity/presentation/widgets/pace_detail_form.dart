import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Form fields for configuring a Pace detail.
class PaceDetailForm extends StatelessWidget {
  const PaceDetailForm({
    required this.config,
    required this.onPaceTypeChanged,
    required this.areDependenciesMet,
    super.key,
  });

  final PaceDetailConfig config;
  final ValueChanged<PaceType> onPaceTypeChanged;
  final bool areDependenciesMet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Error state if dependencies not met
        if (!areDependenciesMet)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.triangleAlert,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pace requires both a Duration and Distance detail marked for pace calculation.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Pace type dropdown
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Pace Type', style: theme.textTheme.bodyMedium),
            ),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<PaceType>(
                initialValue: config.paceType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: PaceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getPaceTypeLabel(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onPaceTypeChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _getPaceTypeDescription(config.paceType),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getPaceTypeLabel(PaceType type) {
    return switch (type) {
      PaceType.minutesPerUom => 'Minutes/unit',
      PaceType.minutesPer100Uom => 'Minutes/100 units',
      PaceType.minutesPer500m => 'Minutes/500m',
      PaceType.floorsPerMinute => 'Floors/minute',
    };
  }

  String _getPaceTypeDescription(PaceType type) {
    return switch (type) {
      PaceType.minutesPerUom => 'e.g. min/km or min/mi - Standard running pace',
      PaceType.minutesPer100Uom => 'e.g. min/100m - Common for swimming',
      PaceType.minutesPer500m => 'min/500m - Standard for rowing',
      PaceType.floorsPerMinute => 'floors/min - For stair climbing',
    };
  }
}
