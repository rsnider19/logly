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
    super.key,
  });

  /// The premium feature this badge represents.
  final FeatureCode feature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitlements = ref.watch(entitlementStateProvider);

    if (entitlements.isLoading || entitlements.hasFeature(feature)) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: ShapeDecoration(
        color: Colors.amber,
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'PRO',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}
