import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/search_provider.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/favorites_provider.dart';
import 'package:logly/features/activity_logging/presentation/screens/log_activity_screen.dart';

/// Screen for searching and selecting an activity to log.
///
/// Shows search results, categories, and favorite activities.
class ActivitySearchScreen extends ConsumerStatefulWidget {
  const ActivitySearchScreen({
    this.initialDate,
    super.key,
  });

  final DateTime? initialDate;

  @override
  ConsumerState<ActivitySearchScreen> createState() => _ActivitySearchScreenState();
}

class _ActivitySearchScreenState extends ConsumerState<ActivitySearchScreen> {
  late TextEditingController _searchController;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).update(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  void _selectActivity(Activity activity) {
    unawaited(
      Navigator.push(
        context,
        MaterialPageRoute<bool>(
          builder: (context) => LogActivityScreen(
            activity: activity,
            initialDate: widget.initialDate,
          ),
        ),
      ).then((result) {
        if (result == true && mounted) {
          Navigator.pop(context, true);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final favoritesAsync = ref.watch(favoriteActivitiesProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    final isSearching = searchQuery.trim().length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Activity'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          Expanded(
            child: isSearching
                ? _buildSearchResults(searchResultsAsync)
                : _buildBrowseView(favoritesAsync, categoriesAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<List<Activity>> searchResultsAsync) {
    final theme = Theme.of(context);

    return searchResultsAsync.when(
      data: (activities) {
        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No activities found',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _ActivityListTile(
              activity: activity,
              onTap: () => _selectActivity(activity),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) {
        // Ignore "Query changed" errors from debouncing
        if (error.toString().contains('Query changed')) {
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: Text(
            'Search failed: $error',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        );
      },
    );
  }

  Widget _buildBrowseView(
    AsyncValue<List<FavoriteActivity>> favoritesAsync,
    AsyncValue<List<ActivityCategory>> categoriesAsync,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorites section
          favoritesAsync.when(
            data: (favorites) {
              if (favorites.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Favorites',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = favorites[index];
                        if (favorite.activity == null) return const SizedBox.shrink();
                        return _FavoriteActivityCard(
                          activity: favorite.activity!,
                          onTap: () => _selectActivity(favorite.activity!),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Categories section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Categories',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          categoriesAsync.when(
            data: (categories) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return _CategoryExpansionTile(
                  category: category,
                  onActivitySelected: _selectActivity,
                );
              },
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load categories',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ActivityListTile extends StatelessWidget {
  const _ActivityListTile({
    required this.activity,
    required this.onTap,
  });

  final Activity activity;
  final VoidCallback onTap;

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(activity.effectiveColor);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: activity.effectiveIcon != null
              ? Text(activity.effectiveIcon!, style: const TextStyle(fontSize: 18))
              : Icon(Icons.fitness_center, color: color),
        ),
        title: Text(activity.name),
        subtitle: activity.activityCategory != null
            ? Text(
                activity.activityCategory!.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _FavoriteActivityCard extends StatelessWidget {
  const _FavoriteActivityCard({
    required this.activity,
    required this.onTap,
  });

  final Activity activity;
  final VoidCallback onTap;

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(activity.effectiveColor);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                radius: 20,
                child: activity.effectiveIcon != null
                    ? Text(activity.effectiveIcon!, style: const TextStyle(fontSize: 16))
                    : Icon(Icons.fitness_center, color: color, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                activity.name,
                style: theme.textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryExpansionTile extends ConsumerWidget {
  const _CategoryExpansionTile({
    required this.category,
    required this.onActivitySelected,
  });

  final ActivityCategory category;
  final void Function(Activity) onActivitySelected;

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = _parseColor(category.hexColor);

    return ExpansionTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Text(category.icon, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(category.name),
      children: [
        Consumer(
          builder: (context, ref, _) {
            final activitiesAsync = ref.watch(activitiesByCategoryProvider(category.activityCategoryId));

            return activitiesAsync.when(
              data: (activities) {
                if (activities.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No activities in this category',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return Column(
                  children: activities.map((activity) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 72, right: 16),
                      leading: activity.icon != null
                          ? Text(activity.icon!, style: const TextStyle(fontSize: 18))
                          : null,
                      title: Text(activity.name),
                      onTap: () => onActivitySelected(activity),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                    );
                  }).toList(),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Failed to load: $error',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
