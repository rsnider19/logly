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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activityDetail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        SegmentedButton<EnvironmentType?>(
          segments: const [
            ButtonSegment(
              value: EnvironmentType.indoor,
              label: Text('Indoor'),
              icon: Icon(Icons.home_outlined),
            ),
            ButtonSegment(
              value: EnvironmentType.outdoor,
              label: Text('Outdoor'),
              icon: Icon(Icons.park_outlined),
            ),
          ],
          selected: selectedEnvironment != null ? {selectedEnvironment} : {},
          onSelectionChanged: (Set<EnvironmentType?> selection) {
            final value = selection.firstOrNull;
            ref.read(activityFormStateProvider.notifier).setEnvironmentValue(
                  activityDetail.activityDetailId,
                  value,
                );
          },
          emptySelectionAllowed: true,
          showSelectedIcon: false,
        ),
      ],
    );
  }
}
