import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_logging/domain/environment_type.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

/// Segmented control for selecting indoor/outdoor environment.
///
/// Stores via [ActivityFormStateNotifier.setEnvironmentValue].
class EnvironmentSelector extends ConsumerWidget {
  const EnvironmentSelector({
    required this.activityDetail,
    super.key,
  });

  final ActivityDetail activityDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[activityDetail.activityDetailId];
    final selectedEnvironment = detailValue?.environmentValue;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            activityDetail.label,
            style: theme.textTheme.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: CupertinoSlidingSegmentedControl<EnvironmentType>(
            groupValue: selectedEnvironment,
            children: const {
              EnvironmentType.indoor: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Indoor'),
              ),
              EnvironmentType.outdoor: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Outdoor'),
              ),
            },
            onValueChanged: (EnvironmentType? value) {
              ref.read(activityFormStateProvider.notifier).setEnvironmentValue(
                    activityDetail.activityDetailId,
                    value,
                  );
            },
          ),
        ),
      ],
    );
  }
}
