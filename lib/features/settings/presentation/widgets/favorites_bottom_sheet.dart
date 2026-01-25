import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_favorites_provider.dart';

/// Bottom sheet for selecting favorite activities from settings.
class FavoritesBottomSheet extends ConsumerStatefulWidget {
  const FavoritesBottomSheet({super.key});

  @override
  ConsumerState<FavoritesBottomSheet> createState() => _FavoritesBottomSheetState();
}

class _FavoritesBottomSheetState extends ConsumerState<FavoritesBottomSheet> {
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(onboardingFavoritesStateProvider.notifier).saveFavorites();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Favorites saved'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
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
    final popularAsync = ref.watch(popularActivitiesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final selectedIds = switch (selectedIdsAsync) {
      AsyncData(:final value) => value,
      _ => <String>{},
    };

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Everything scrollable
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Select Favorites',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Choose the activities you want quick access to.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Selected favorites
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _SelectedFavoritesWrap(
                        selectedIds: selectedIds,
                        onToggle: _toggleActivity,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Popular activities section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: Text(
                        'Popular',
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

                    const SizedBox(height: 16),

                    // Categories sections
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

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Save button (fixed at bottom)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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

  final List<Activity> activities;
  final Set<String> selectedIds;
  final void Function(String activityId) onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
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

/// A category section with title and wrapped activity chips.
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
    final activitiesAsync = ref.watch(suggestedFavoritesByCategoryProvider(category.activityCategoryId));

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
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

/// Displays selected favorites as wrapped chips (without internal padding).
class _SelectedFavoritesWrap extends ConsumerWidget {
  const _SelectedFavoritesWrap({
    required this.selectedIds,
    required this.onToggle,
  });

  final Set<String> selectedIds;
  final void Function(String activityId) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedList = selectedIds.toList();

    if (selectedList.isEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(3, (_) => _EmptyPlaceholder()),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...selectedList.map((activityId) {
          return _SelectedActivityChip(
            activityId: activityId,
            onTap: () => onToggle(activityId),
          );
        }),
      ],
    );
  }
}

/// A selected activity chip.
class _SelectedActivityChip extends ConsumerWidget {
  const _SelectedActivityChip({
    required this.activityId,
    required this.onTap,
  });

  final String activityId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(_activityByIdProvider(activityId));

    return activityAsync.when(
      data: (activity) => ActivityChip.filled(
        activity: activity,
        onPressed: onTap,
        showIcon: false,
      ),
      loading: () => _EmptyPlaceholder(),
      error: (_, __) => _EmptyPlaceholder(),
    );
  }
}

/// An empty placeholder chip.
class _EmptyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ActivityChip(
      activity: Activity.empty(name: '          '),
      showIcon: false,
    );
  }
}

/// Provider to fetch activity by ID.
final _activityByIdProvider = FutureProvider.autoDispose.family<Activity, String>((ref, activityId) async {
  final service = ref.watch(catalogServiceProvider);
  return service.getActivityById(activityId);
});
