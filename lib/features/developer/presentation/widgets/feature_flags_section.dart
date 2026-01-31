import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/services/feature_flag_service.dart';

/// Debug section that displays all active GrowthBook feature flags.
///
/// Shows each flag's key, enabled status, and current value.
class FeatureFlagsSection extends ConsumerWidget {
  const FeatureFlagsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final service = ref.watch(featureFlagServiceProvider);
    final features = service.getAllFeatures();

    // features is dynamic from SDK, cast to Map if possible
    final featureMap = features is Map<String, dynamic> ? features : <String, dynamic>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Feature Flags',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '${featureMap.length} flags loaded from GrowthBook',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Divider(height: 32),
        if (featureMap.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No feature flags loaded.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ...featureMap.entries.map((entry) {
            final key = entry.key;
            final result = service.evalFeature(key);
            final isOn = result.on ?? false;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  key,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: result.value != null
                    ? Text(
                        'Value: ${result.value}',
                        style: theme.textTheme.bodySmall,
                      )
                    : null,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOn
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isOn ? 'ON' : 'OFF',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isOn
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
