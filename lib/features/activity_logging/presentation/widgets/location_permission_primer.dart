import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Primer dialog shown before requesting location permission.
///
/// Explains the benefits of enabling location to help users make an informed
/// decision before the system permission dialog appears.
class LocationPermissionPrimer extends StatelessWidget {
  const LocationPermissionPrimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(LucideIcons.mapPin, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Enable Location'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Logly uses your location to:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          _BenefitRow(
            icon: LucideIcons.search,
            text: 'Show nearby places as you search',
          ),
          const SizedBox(height: 8),
          _BenefitRow(
            icon: LucideIcons.locateFixed,
            text: 'Auto-fill your current location',
          ),
          const SizedBox(height: 8),
          _BenefitRow(
            icon: LucideIcons.trendingUp,
            text: 'Provide location-based insights',
          ),
          const SizedBox(height: 16),
          Text(
            'Your location data stays private and is only used to enhance your logging experience.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not Now'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Enable Location'),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: theme.textTheme.bodyMedium),
        ),
      ],
    );
  }
}
