import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/subscription_service_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// A widget that gates content behind a premium feature.
///
/// Shows [child] when the user has access to the specified [feature].
/// Shows [lockedChild] (or a default upgrade prompt) when the user doesn't have access.
class PremiumGate extends ConsumerWidget {
  const PremiumGate({
    required this.feature,
    required this.child,
    this.lockedChild,
    this.showShimmerWhileLoading = true,
    super.key,
  });

  /// The premium feature required to view the content.
  final FeatureCode feature;

  /// The widget to show when the user has access to the feature.
  final Widget child;

  /// The widget to show when the user doesn't have access.
  /// If null, a default upgrade prompt is shown.
  final Widget? lockedChild;

  /// Whether to show a shimmer effect while checking entitlement.
  final bool showShimmerWhileLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementStateProvider);

    if (entitlements.isLoading) {
      if (showShimmerWhileLoading) {
        return const _LoadingShimmer();
      }
      return child; // Optimistically show content while loading
    }

    if (entitlements.hasFeature(feature)) {
      return child;
    }

    return lockedChild ?? _DefaultLockedContent(feature: feature);
  }
}

/// A badge indicating premium content.
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({
    this.size = 16,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: size - 4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Default locked content widget with upgrade prompt.
class _DefaultLockedContent extends ConsumerWidget {
  const _DefaultLockedContent({required this.feature});

  final FeatureCode feature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showPaywall(ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.lock,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const PremiumBadge(),
            const SizedBox(height: 12),
            Text(
              'Unlock ${_getFeatureDisplayName(feature)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to upgrade and access this feature',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getFeatureDisplayName(FeatureCode feature) {
    switch (feature) {
      case FeatureCode.aiInsights:
        return 'AI Insights';
      case FeatureCode.createCustomActivity:
        return 'Custom Activities';
      case FeatureCode.activityNameOverride:
        return 'Custom Naming';
      case FeatureCode.locationServices:
        return 'Location Services';
      case FeatureCode.pro:
        return 'Premium Features';
    }
  }

  Future<void> _showPaywall(WidgetRef ref) async {
    await ref.read(subscriptionServiceProvider).showPaywall(source: 'premium_gate');
    // No need to manually invalidate - the StateNotifier listens for updates
  }
}

/// Loading shimmer while checking entitlements.
class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
