import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/sub_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';

/// Multi-select chip list for choosing subactivities.
///
/// Uses [ActivityFormStateNotifier.toggleSubActivity] to update selection.
/// Displayed in a collapsible section that is collapsed by default.
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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final selectedIds = formState.selectedSubActivityIds;
    final activityColor = formState.activity?.getColor(context);

    if (widget.subActivities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Type',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                Icon(
                  _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              children: widget.subActivities.map((subActivity) {
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
              }).toList(),
            ),
          ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
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
