import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/health_integration/presentation/providers/health_sync_provider.dart';
import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Bottom sheet for managing health sync settings.
class HealthSyncBottomSheet extends ConsumerStatefulWidget {
  const HealthSyncBottomSheet({super.key});

  @override
  ConsumerState<HealthSyncBottomSheet> createState() => _HealthSyncBottomSheetState();
}

class _HealthSyncBottomSheetState extends ConsumerState<HealthSyncBottomSheet> {
  bool _isRequesting = false;
  bool? _hasPermissions;

  String get _platformName => Platform.isIOS ? 'Apple Health' : 'Health Connect';

  String get _platformDescription => Platform.isIOS
      ? 'Connect to Apple Health to automatically sync your workouts and activities.'
      : 'Connect to Health Connect to automatically sync your workouts and activities.';

  IconData get _platformIcon => Platform.isIOS ? Icons.favorite : LucideIcons.heartPulse;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final service = ref.read(onboardingServiceProvider);
    final hasPermissions = await service.hasHealthPermissions();
    if (mounted) {
      setState(() {
        _hasPermissions = hasPermissions;
      });
    }
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isRequesting = true;
    });

    try {
      final service = ref.read(onboardingServiceProvider);
      final granted = await service.requestHealthPermissions();

      if (mounted) {
        setState(() {
          _hasPermissions = granted;
          _isRequesting = false;
        });

        if (granted) {
          // Update the preference
          await ref.read(preferencesStateProvider.notifier).setHealthSyncEnabled(true);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$_platformName connected successfully'),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _openSettings() async {
    // Opens the app's settings page where users can manage permissions
    await AppSettings.openAppSettings();
  }

  Future<void> _disableSync() async {
    await ref.read(preferencesStateProvider.notifier).setHealthSyncEnabled(false);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preferencesAsync = ref.watch(preferencesStateProvider);

    final healthSyncEnabled = switch (preferencesAsync) {
      AsyncData(:final value) => value.healthSyncEnabled,
      _ => false,
    };

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _platformIcon,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            _hasPermissions == true && healthSyncEnabled ? '$_platformName Connected' : 'Connect to $_platformName',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            _platformDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Benefits list
          const _BenefitItem(
            icon: LucideIcons.refreshCw,
            text: 'Auto-sync workouts and activities',
          ),
          const SizedBox(height: 8),
          const _BenefitItem(
            icon: LucideIcons.trendingUp,
            text: 'Get more accurate insights',
          ),
          const SizedBox(height: 8),
          const _BenefitItem(
            icon: LucideIcons.lock,
            text: 'Your data stays private and secure',
          ),

          const SizedBox(height: 24),

          // Action buttons based on state
          if (_hasPermissions == null)
            const CircularProgressIndicator()
          else if (_hasPermissions == true && healthSyncEnabled)
            // Already connected - show sync controls
            _ConnectedSyncControls(
              onDisableSync: _disableSync,
            )
          else if (_hasPermissions == true && !healthSyncEnabled)
            // Has permissions but sync disabled - enable it
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await ref.read(preferencesStateProvider.notifier).setHealthSyncEnabled(true);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Enable Health Sync'),
              ),
            )
          else
            // No permissions - show connect button and settings link
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isRequesting ? null : _requestPermissions,
                    child: _isRequesting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Connect $_platformName'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You may need to enable access in Settings.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _openSettings,
                  child: const Text('Open Settings'),
                ),
              ],
            ),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
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
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Widget showing sync controls when health is connected.
class _ConnectedSyncControls extends ConsumerWidget {
  const _ConnectedSyncControls({
    required this.onDisableSync,
  });

  final VoidCallback onDisableSync;

  /// Minimum date for syncing (January 1, 2015).
  static final DateTime _minimumSyncDate = DateTime(2015);

  Future<void> _handleSyncTap(BuildContext context, WidgetRef ref) async {
    final syncState = ref.read(healthSyncStateProvider);

    // If this is the first sync, show the date selection dialog
    if (syncState.lastSyncDate == null) {
      final selectedDate = await _showFirstSyncDialog(context);
      if (selectedDate != null) {
        ref.read(healthSyncStateProvider.notifier).sync(fromDate: selectedDate);
      }
    } else {
      // Regular sync - use last sync date
      ref.read(healthSyncStateProvider.notifier).sync();
    }
  }

  void _showNoActivitiesDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          LucideIcons.searchX,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        title: const Text('No Workouts Found'),
        content: Text(
          "We couldn't find any workouts to sync. If you were expecting some, "
          'you may need to grant Logly access to your health data in Settings.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _showFirstSyncDialog(BuildContext context) async {
    final theme = Theme.of(context);

    return showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('First Time Sync'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How far back would you like to sync your workout history?',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Note: Syncing a large history may take longer.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 30)),
                firstDate: _minimumSyncDate,
                lastDate: DateTime.now(),
                helpText: 'Sync workouts from this date',
              );
              if (pickedDate != null && context.mounted) {
                Navigator.of(context).pop(pickedDate);
              }
            },
            child: const Text('Pick a Date'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_minimumSyncDate),
            child: const Text('Sync All History'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final syncState = ref.watch(healthSyncStateProvider);

    // Show feedback when sync completes
    ref.listen(healthSyncStateProvider, (previous, next) {
      if (previous?.isSyncing == true && !next.isSyncing) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (next.lastSyncResult != null) {
          // If no activities were synced, show a dialog
          if (next.lastSyncResult!.total == 0) {
            _showNoActivitiesDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(next.lastSyncResult!.summary),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });

    final isFirstSync = syncState.lastSyncDate == null;

    return Column(
      children: [
        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleCheck,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Health sync is enabled',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Progress, last sync date, or first sync message
        if (syncState.isSyncing && syncState.showProgress)
          // Show progress when syncing multiple months
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: LinearProgressIndicator(value: syncState.progress),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isFirstSync ? LucideIcons.info : LucideIcons.clock,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isFirstSync
                        ? 'Tap Sync Now to import your workout history'
                        : 'Last synced: ${timeago.format(syncState.lastSyncDate!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        // Sync now button
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: syncState.isSyncing ? null : () => _handleSyncTap(context, ref),
            icon: syncState.isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.refreshCw),
            label: Text(syncState.isSyncing ? 'Syncing...' : 'Sync Now'),
          ),
        ),

        const SizedBox(height: 12),

        // Disable sync button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: syncState.isSyncing ? null : onDisableSync,
            child: const Text('Disable Sync'),
          ),
        ),
      ],
    );
  }
}
