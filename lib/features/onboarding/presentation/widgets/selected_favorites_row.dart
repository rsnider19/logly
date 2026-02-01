import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';

/// Displays a grid of selected favorite activities with placeholder slots.
/// Shows up to 10 slots in a wrapped layout.
class SelectedFavoritesRow extends ConsumerWidget {
  const SelectedFavoritesRow({
    required this.selectedIds,
    required this.onToggle,
    super.key,
  });

  final Set<String> selectedIds;
  final void Function(String activityId) onToggle;

  static const _maxSlots = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedList = selectedIds.toList();
    final emptySlots = math.max(_maxSlots - selectedList.length, 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        // runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Show selected activities as ActivityChips
          ...selectedList.map((activityId) {
            return _SelectedActivityChip(
              activityId: activityId,
              onTap: () => onToggle(activityId),
            );
          }),
          // Show empty placeholder slots
          ...List.generate(emptySlots, (index) => const _EmptyPlaceholder()),
        ],
      ),
    );
  }
}

/// A selected activity chip using ActivityChip.
class _SelectedActivityChip extends ConsumerWidget {
  const _SelectedActivityChip({
    required this.activityId,
    required this.onTap,
  });

  final String activityId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(_activitySummaryByIdProvider(activityId));

    return activityAsync.when(
      data: (activity) => ActivityChip.filled(
        activity: activity,
        onPressed: onTap,
        showIcon: false,
      ),
      loading: () => const _LoadingPlaceholder(),
      error: (_, _) => const _ErrorPlaceholder(),
    );
  }
}

/// An empty placeholder slot with dotted border.
class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ActivityChip(
      activity: _emptySummary,
      showIcon: false,
    );
  }
}

/// A loading placeholder chip.
class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ActivityChip(
      activity: _emptySummary,
      showIcon: false,
    );
  }
}

/// An error placeholder chip.
class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ActivityChip(
      activity: _emptySummary,
      showIcon: false,
    );
  }
}

const _emptySummary = ActivitySummary(
  activityId: '',
  activityCategoryId: '',
  name: '          ',
  activityCode: '',
  activityDateType: ActivityDateType.single,
);

/// Internal provider to fetch activity summary by ID for chip display.
// ignore: specify_nonobvious_property_types
final _activitySummaryByIdProvider = FutureProvider.autoDispose.family<ActivitySummary, String>((
  ref,
  activityId,
) async {
  final service = ref.watch(catalogServiceProvider);
  final activity = await service.getActivityById(activityId);
  return ActivitySummary(
    activityId: activity.activityId,
    activityCategoryId: activity.activityCategoryId,
    name: activity.name,
    activityCode: activity.activityCode,
    description: activity.description,
    activityDateType: activity.activityDateType,
    isSuggestedFavorite: activity.isSuggestedFavorite,
    activityCategory: activity.activityCategory,
  );
});
