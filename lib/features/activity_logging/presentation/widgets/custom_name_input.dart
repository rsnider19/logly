import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/subscription_service_provider.dart';
import 'package:logly/features/subscriptions/presentation/widgets/pro_badge.dart';

/// A text input for customizing the activity name.
///
/// Premium-gated: users without the [FeatureCode.activityNameOverride]
/// entitlement see a disabled field with a lock icon that opens the paywall.
class CustomNameInput extends ConsumerStatefulWidget {
  const CustomNameInput({
    this.initialValue,
    super.key,
  });

  /// Initial value for edit mode. If null, the field starts empty.
  final String? initialValue;

  @override
  ConsumerState<CustomNameInput> createState() => _CustomNameInputState();
}

class _CustomNameInputState extends ConsumerState<CustomNameInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    ref.read(activityFormStateProvider.notifier).setActivityNameOverride(
          value.isEmpty ? null : value,
        );
  }

  Future<void> _showPaywall() async {
    await ref.read(subscriptionServiceProvider).showPaywall();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAccess = ref.watch(hasActivityNameOverrideProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Custom Name',
              style: theme.textTheme.bodyLarge,
            ),
            ProBadge(feature: FeatureCode.activityNameOverride),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          behavior: !hasAccess ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
          onTap: hasAccess ? null : () => unawaited(_showPaywall()),
          child: IgnorePointer(
            ignoring: !hasAccess,
            child: TextField(
              controller: _controller,
              enabled: hasAccess,
              maxLength: 50,
              decoration: InputDecoration(
                hintText: 'e.g. Morning Run',
                border: const OutlineInputBorder(),
                counterText: hasAccess ? null : '',
                suffixIcon: null,
              ),
              onChanged: hasAccess ? _onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
