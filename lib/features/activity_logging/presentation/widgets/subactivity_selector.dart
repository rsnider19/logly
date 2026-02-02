import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/ordered_sub_activities_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/view_all_chip.dart';

/// The number of sub-activities to show before requiring "View all".
const _initialDisplayCount = 5;

/// Multi-select chip list for choosing subactivities.
///
/// Shows the top [_initialDisplayCount] most-used sub-activities upfront,
/// plus a "View all" chip to reveal the rest. Auto-expands if any
/// pre-selected IDs fall outside the top group (e.g. in edit mode).
class SubActivitySelector extends ConsumerStatefulWidget {
  const SubActivitySelector({
    required this.subActivities,
    super.key,
  });

  final List<SubActivity> subActivities;

  @override
  ConsumerState<SubActivitySelector> createState() => _SubActivitySelectorState();
}

class _SubActivitySelectorState extends ConsumerState<SubActivitySelector> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final selectedIds = formState.selectedSubActivityIds;
    final activityColor = formState.activity?.getColor(context);

    if (widget.subActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    final orderedAsync = ref.watch(orderedSubActivitiesProvider);

    // Use frequency-ordered list when available, fall back to original order
    final orderedSubActivities = orderedAsync.value ?? widget.subActivities;

    // Auto-expand if any selected sub-activity is outside the top group
    final needsAutoExpand = orderedSubActivities.length > _initialDisplayCount &&
        selectedIds.any(
          (id) => !orderedSubActivities.take(_initialDisplayCount).any((sa) => sa.subActivityId == id),
        );

    final shouldShowAll = _showAll || needsAutoExpand || orderedSubActivities.length <= _initialDisplayCount;

    final visibleSubActivities = shouldShowAll ? orderedSubActivities : orderedSubActivities.take(_initialDisplayCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Type',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: 8,
            children: [
              ...visibleSubActivities.map((subActivity) {
                final isSelected = selectedIds.contains(subActivity.subActivityId);
                return SubActivityChip(
                  subActivity: subActivity,
                  isSelected: isSelected,
                  selectedColor: activityColor,
                  onPressed: () {
                    ref.read(activityFormStateProvider.notifier).toggleSubActivity(
                          subActivity.subActivityId,
                        );
                  },
                );
              }),
              if (!shouldShowAll)
                ViewAllChip(
                  categoryColor: null,
                  onPressed: () => setState(() => _showAll = true),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A chip displaying a subactivity name.
///
/// Filled with activity color when selected, outlined when not selected.
class SubActivityChip extends StatelessWidget {
  const SubActivityChip({
    required this.subActivity,
    required this.isSelected,
    this.selectedColor,
    this.onPressed,
    super.key,
  });

  final SubActivity subActivity;
  final bool isSelected;
  final Color? selectedColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      label: Text(subActivity.name),
      shape: const StadiumBorder(),
      backgroundColor: isSelected ? selectedColor : null,
      side: BorderSide(
        color: theme.colorScheme.onSurface.withAlpha(Color.getAlphaFromOpacity(0.25)),
      ),
      onPressed: onPressed,
    );
  }
}
