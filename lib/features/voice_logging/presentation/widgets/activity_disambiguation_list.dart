import 'package:flutter/material.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';

/// A list of activity options for disambiguation.
///
/// Shows when voice input matches multiple activities,
/// allowing the user to select the correct one.
class ActivityDisambiguationList extends StatelessWidget {
  const ActivityDisambiguationList({
    required this.activities,
    required this.onActivitySelected,
    super.key,
  });

  final List<ActivitySummary> activities;
  final void Function(ActivitySummary) onActivitySelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: activities.map((activity) {
        return ActivityChip(
          activity: activity,
          onPressed: () => onActivitySelected(activity),
          showIcon: false,
        );
      }).toList(),
    );
  }
}
