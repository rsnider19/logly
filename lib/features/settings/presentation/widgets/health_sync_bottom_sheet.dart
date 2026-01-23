import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';

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

  IconData get _platformIcon => Platform.isIOS ? Icons.favorite : Icons.monitor_heart;

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
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

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
            _hasPermissions == true && healthSyncEnabled
                ? '$_platformName Connected'
                : 'Connect to $_platformName',
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
          _BenefitItem(
            icon: Icons.sync,
            text: 'Auto-sync workouts and activities',
          ),
          const SizedBox(height: 8),
          _BenefitItem(
            icon: Icons.trending_up,
            text: 'Get more accurate insights',
          ),
          const SizedBox(height: 8),
          _BenefitItem(
            icon: Icons.lock_outline,
            text: 'Your data stays private and secure',
          ),

          const SizedBox(height: 24),

          // Action buttons based on state
          if (_hasPermissions == null)
            const CircularProgressIndicator()
          else if (_hasPermissions == true && healthSyncEnabled)
            // Already connected - show disable option
            Column(
              children: [
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
                        Icons.check_circle,
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
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _disableSync,
                    child: const Text('Disable Sync'),
                  ),
                ),
              ],
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
