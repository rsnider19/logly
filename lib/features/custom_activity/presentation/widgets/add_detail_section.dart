import 'package:flutter/material.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// The detail types available for adding.
enum DetailType {
  number('Number', LucideIcons.hash),
  duration('Duration', LucideIcons.timer),
  distance('Distance', LucideIcons.ruler),
  environment('Environment', LucideIcons.sun),
  pace('Pace', LucideIcons.gauge);

  const DetailType(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// A sticky section at the bottom for adding detail types.
class AddDetailSection extends StatelessWidget {
  const AddDetailSection({
    required this.onAddDetail,
    required this.isAtLimit,
    required this.hasEnvironment,
    required this.hasPace,
    super.key,
  });

  final void Function(ActivityDetailConfig) onAddDetail;
  final bool isAtLimit;
  final bool hasEnvironment;
  final bool hasPace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Add Detail',
                  style: theme.textTheme.titleMedium,
                ),
                if (isAtLimit) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Limit reached',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DetailType.values.map((type) {
                final isDisabled = _isTypeDisabled(type);
                return _DetailTypeChip(
                  type: type,
                  onTap: isDisabled ? null : () => _handleAddDetail(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  bool _isTypeDisabled(DetailType type) {
    if (isAtLimit) return true;

    return switch (type) {
      DetailType.environment => hasEnvironment,
      DetailType.pace => hasPace,
      _ => false,
    };
  }

  void _handleAddDetail(DetailType type) {
    final detail = switch (type) {
      DetailType.number => ActivityDetailConfig.createNumber(),
      DetailType.duration => ActivityDetailConfig.createDuration(),
      DetailType.distance => ActivityDetailConfig.createDistance(),
      DetailType.environment => ActivityDetailConfig.createEnvironment(),
      DetailType.pace => ActivityDetailConfig.createPace(),
    };
    onAddDetail(detail);
  }
}

class _DetailTypeChip extends StatelessWidget {
  const _DetailTypeChip({
    required this.type,
    required this.onTap,
  });

  final DetailType type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onTap == null;

    return ActionChip(
      avatar: Icon(
        type.icon,
        size: 18,
        color: isDisabled ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5) : null,
      ),
      label: Text(type.label),
      onPressed: onTap,
      backgroundColor: isDisabled ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : null,
      labelStyle: isDisabled ? TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)) : null,
    );
  }
}
