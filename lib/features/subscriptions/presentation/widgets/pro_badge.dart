import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';

/// A small "PRO" badge that appears next to labels for premium features.
///
/// Self-contained visibility: returns [SizedBox.shrink] when the user
/// already has access to [feature] or while entitlements are loading.
class ProBadge extends ConsumerWidget {
  const ProBadge({
    required this.feature,
    this.margin,
    super.key,
  });

  /// The premium feature this badge represents.
  final FeatureCode feature;

  /// Optional margin to apply to the badge.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementStateProvider);
    final theme = Theme.of(context);

    if (entitlements.isLoading || entitlements.hasFeature(feature)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: MediaQuery.withNoTextScaling(
        child: DecoratedBox(
          decoration: const ShapeDecoration(
            color: Colors.amber,
            shape: StadiumBorder(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'PRO',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
