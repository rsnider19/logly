import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_favorites_provider.dart';
import 'package:logly/features/onboarding/presentation/widgets/selected_favorites_row.dart';

/// Content widget for favorites selection, extracted from FavoritesSelectionScreen.
class FavoritesContent extends ConsumerWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIdsAsync = ref.watch(onboardingFavoritesStateProvider);
    final popularAsync = ref.watch(popularActivitiesSummaryProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

    final selectedIds = switch (selectedIdsAsync) {
      AsyncData(:final value) => value,
      _ => <String>{},
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Text(
              'Choose your\nfavorite activities',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              'We recommend at least 3 activities. You can edit this later in your settings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // Selected favorites placeholders
          SelectedFavoritesRow(
            selectedIds: selectedIds,
            onToggle: (id) => ref.read(onboardingFavoritesStateProvider.notifier).toggle(id),
          ),

          const SizedBox(height: 24),

          // Popular activities
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Here are a few popular ones',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          popularAsync.when(
            data: (activities) => _ActivityChipsWrap(
              activities: activities.take(10).toList(),
              selectedIds: selectedIds,
              onToggle: (id) => ref.read(onboardingFavoritesStateProvider.notifier).toggle(id),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load activities',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Categories
          categoriesAsync.when(
            data: (categories) {
              final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: sortedCategories.map((category) {
                  return _CategorySection(
                    category: category,
                    selectedIds: selectedIds,
                    onToggle: (id) => ref.read(onboardingFavoritesStateProvider.notifier).toggle(id),
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load categories',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ActivityChipsWrap extends StatelessWidget {
  const _ActivityChipsWrap({
    required this.activities,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<ActivitySummary> activities;
  final Set<String> selectedIds;
  final void Function(String activityId) onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        children: activities.map((activity) {
          final isSelected = selectedIds.contains(activity.activityId);
          return ActivityChip(
            activity: activity,
            isFilled: isSelected,
            onPressed: () => onToggle(activity.activityId),
            showIcon: false,
          );
        }).toList(),
      ),
    );
  }
}

class _CategorySection extends ConsumerWidget {
  const _CategorySection({
    required this.category,
    required this.selectedIds,
    required this.onToggle,
  });

  final ActivityCategory category;
  final Set<String> selectedIds;
  final void Function(String activityId) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(suggestedFavoritesByCategorySummaryProvider(category.activityCategoryId));

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  category.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _ActivityChipsWrap(
                activities: activities,
                selectedIds: selectedIds,
                onToggle: onToggle,
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
    );
  }
}
