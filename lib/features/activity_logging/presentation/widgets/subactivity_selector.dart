import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

/// Multi-select chip list for choosing subactivities.
///
/// Uses [ActivityFormStateNotifier.toggleSubActivity] to update selection.
class SubActivitySelector extends ConsumerWidget {
  const SubActivitySelector({
    required this.subActivities,
    super.key,
  });

  final List<SubActivity> subActivities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final selectedIds = formState.selectedSubActivityIds;

    if (subActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subActivities.map((subActivity) {
            final isSelected = selectedIds.contains(subActivity.subActivityId);
            return FilterChip(
              label: Text(subActivity.name),
              selected: isSelected,
              onSelected: (_) {
                ref.read(activityFormStateProvider.notifier).toggleSubActivity(
                      subActivity.subActivityId,
                    );
              },
              showCheckmark: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }
}
