import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/view_all_chip.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_favorites_provider.dart';
import 'package:logly/features/onboarding/presentation/widgets/selected_favorites_row.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen for selecting favorite activities during onboarding.
class FavoritesSelectionScreen extends ConsumerStatefulWidget {
  const FavoritesSelectionScreen({super.key});

  @override
  ConsumerState<FavoritesSelectionScreen> createState() => _FavoritesSelectionScreenState();
}

class _FavoritesSelectionScreenState extends ConsumerState<FavoritesSelectionScreen> {
  bool _isSaving = false;

  Future<void> _continue() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(onboardingFavoritesStateProvider.notifier).saveFavorites();
      if (mounted) {
        context.go('/onboarding/health');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save favorites: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _toggleActivity(String activityId) {
    ref.read(onboardingFavoritesStateProvider.notifier).toggle(activityId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIdsAsync = ref.watch(onboardingFavoritesStateProvider);
    final popularAsync = ref.watch(popularActivitiesSummaryProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

    final selectedIds = switch (selectedIdsAsync) {
      AsyncData(:final value) => value,
      _ => <String>{},
    };

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: IconButton(
                  icon: const Icon(LucideIcons.arrowLeft),
                  onPressed: () => context.go('/onboarding'),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Choose your\nfavorite activities',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
                onToggle: _toggleActivity,
              ),

              const SizedBox(height: 24),

              // Top 10 global trending section
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
                  onToggle: _toggleActivity,
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

              // Categories sections (showing suggested favorites per category)
              categoriesAsync.when(
                data: (categories) {
                  final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sortedCategories.map((category) {
                      return _CategorySection(
                        category: category,
                        selectedIds: selectedIds,
                        onToggle: _toggleActivity,
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

              const SizedBox(height: 16), // Small space before bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _isSaving ? null : _continue,
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Continue'),
          ),
        ),
      ),
    );
  }
}

/// Displays activities as wrapped chips.
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

/// A category section with title and wrapped activity chips (suggested favorites only).
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    ...activities.map((activity) {
                      final isSelected = selectedIds.contains(activity.activityId);
                      return ActivityChip(
                        activity: activity,
                        isFilled: isSelected,
                        onPressed: () => onToggle(activity.activityId),
                        showIcon: false,
                      );
                    }),
                    ViewAllChip(
                      categoryColor: category.color,
                      onPressed: () => FavoritesCategoryDetailRoute(
                        categoryId: category.activityCategoryId,
                      ).push<void>(context),
                    ),
                  ],
                ),
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
