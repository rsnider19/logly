import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_favorites_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen showing all activities in a category for favorite selection.
///
/// Used from both the onboarding and settings favorites flows.
/// Activities are displayed as chips that toggle filled/unfilled
/// based on whether they are in the user's selected favorites.
class FavoritesCategoryDetailScreen extends ConsumerWidget {
  const FavoritesCategoryDetailScreen({
    required this.categoryId,
    super.key,
  });

  /// The ID of the category to display.
  final String categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoryAsync = ref.watch(categoryByIdProvider(categoryId));
    final activitiesAsync = ref.watch(activitiesByCategorySummaryProvider(categoryId));
    final selectedIdsAsync = ref.watch(onboardingFavoritesStateProvider);

    final selectedIds = switch (selectedIdsAsync) {
      AsyncData(:final value) => value,
      _ => <String>{},
    };

    return Scaffold(
      appBar: AppBar(
        title: categoryAsync.when(
          data: (category) => Text(category.name),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Category'),
        ),
      ),
      body: activitiesAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.layoutGrid,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activities in this category',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 8,
                children: activities.map((activity) {
                  final isSelected = selectedIds.contains(activity.activityId);
                  return ActivityChip(
                    activity: activity,
                    isFilled: isSelected,
                    showIcon: false,
                    onPressed: () {
                      ref.read(onboardingFavoritesStateProvider.notifier).toggle(activity.activityId);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleAlert,
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load activities',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(activitiesByCategorySummaryProvider(categoryId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
