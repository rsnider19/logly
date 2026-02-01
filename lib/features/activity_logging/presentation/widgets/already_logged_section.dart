import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/already_logged_provider.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/widgets/skeleton_loader.dart';

/// Displays activities already logged for the selected date.
///
/// Shows filled [UserActivityChip] widgets with a context-aware header.
/// Tapping a chip navigates to the Edit Activity Screen.
/// Renders nothing when no activities are logged for the date.
class AlreadyLoggedSection extends ConsumerWidget {
  const AlreadyLoggedSection({
    required this.selectedDate,
    super.key,
  });

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(alreadyLoggedActivitiesProvider(selectedDate));

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) return const SizedBox.shrink();
        return _buildSection(context, ref, activities);
      },
      loading: () => _buildLoadingState(context),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(BuildContext context, WidgetRef ref, List<UserActivity> activities) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _headerText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: activities.map((activity) {
                return UserActivityChip(
                  userActivity: activity,
                  onPressed: () async {
                    await EditActivityRoute(userActivityId: activity.userActivityId).push<void>(context);
                    ref.invalidate(alreadyLoggedActivitiesProvider(selectedDate));
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _headerText,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ).withSkeleton(placeholderText: 'Logged today'),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Skelly(
                  isLoading: true,
                  builder: (context) => UserActivityChip(userActivity: UserActivity.empty(name: 'Charizard')),
                ),
                Skelly(
                  isLoading: true,
                  builder: (context) => UserActivityChip(userActivity: UserActivity.empty(name: 'Blastoise')),
                ),
                Skelly(
                  isLoading: true,
                  builder: (context) => UserActivityChip(userActivity: UserActivity.empty(name: 'Venusaur')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String get _headerText {
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
    if (isToday) return 'Logged today';
    return 'Logged on ${DateFormat('EEE MM/dd').format(selectedDate)}';
  }
}
