import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/onboarding/application/onboarding_service.dart';

/// Content widget for health permission request, extracted from HealthPermissionScreen.
class HealthContent extends ConsumerStatefulWidget {
  const HealthContent({
    super.key,
    this.onComplete,
  });

  /// Called when the user connects or skips health permissions.
  final VoidCallback? onComplete;

  @override
  ConsumerState<HealthContent> createState() => _HealthContentState();
}

class _HealthContentState extends ConsumerState<HealthContent> {
  bool _isRequesting = false;

  String get _platformName => Platform.isIOS ? 'Apple Health' : 'Health Connect';

  String get _platformDescription => Platform.isIOS
      ? 'Connect to Apple Health to automatically sync your workouts and activities.'
      : 'Connect to Health Connect to automatically sync your workouts and activities.';

  IconData get _platformIcon => Platform.isIOS ? Icons.favorite : LucideIcons.heartPulse;

  String get _analyticsPlatform => Platform.isIOS ? 'apple_health' : 'google_fit';

  Future<void> _requestPermissions() async {
    setState(() => _isRequesting = true);

    final analyticsService = ref.read(analyticsServiceProvider);
    analyticsService.trackHealthPermissionRequested(platform: _analyticsPlatform);

    try {
      final service = ref.read(onboardingServiceProvider);
      final granted = await service.requestHealthPermissions();

      if (granted) {
        analyticsService.trackHealthPermissionGranted(platform: _analyticsPlatform);
      } else {
        analyticsService.trackHealthPermissionDenied(platform: _analyticsPlatform);
      }

      if (mounted) {
        if (!granted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Health permissions were not granted. You can enable them later in Settings.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        widget.onComplete?.call();
      }
    } catch (e) {
      analyticsService.trackHealthPermissionDenied(platform: _analyticsPlatform);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request permissions: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _isRequesting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _platformIcon,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Connect to $_platformName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            _platformDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Benefits list
          const _BenefitItem(
            icon: LucideIcons.refreshCw,
            text: 'Auto-sync workouts and activities',
          ),
          const SizedBox(height: 12),
          const _BenefitItem(
            icon: LucideIcons.trendingUp,
            text: 'Get more accurate insights',
          ),
          const SizedBox(height: 12),
          const _BenefitItem(
            icon: LucideIcons.lock,
            text: 'Your data stays private and secure',
          ),

          const Spacer(),

          // Connect button
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

          // Skip button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _isRequesting ? null : () => widget.onComplete?.call(),
              child: const Text('Skip for now'),
            ),
          ),
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
