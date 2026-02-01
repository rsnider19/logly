import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/pace_type.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/pace_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Displays calculated pace based on duration and distance values.
///
/// Uses [calculatePaceProvider] to compute pace from the current form state.
/// Only shows when both duration and distance have values.
class PaceDisplay extends ConsumerWidget {
  const PaceDisplay({
    required this.paceType,
    this.isMetric = true,
    super.key,
  });

  final PaceType paceType;
  final bool isMetric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);

    // Find duration and distance detail values
    int? durationSeconds;
    double? distanceMeters;

    for (final detail in formState.detailValues.values) {
      if (detail.durationInSec != null) {
        durationSeconds = detail.durationInSec;
      }
      if (detail.distanceInMeters != null) {
        distanceMeters = detail.distanceInMeters;
      }
    }

    final paceResult = ref.watch(
      calculatePaceProvider(
        durationInSeconds: durationSeconds,
        distanceInMeters: distanceMeters,
        paceType: paceType,
        isMetric: isMetric,
      ),
    );

    if (paceResult == null) {
      return const SizedBox.shrink();
    }

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              LucideIcons.gauge,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pace',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  paceResult.formattedPace,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
