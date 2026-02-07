import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/search_provider.dart';
import 'package:logly/features/activity_logging/domain/favorite_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/favorites_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/search_section_expansion_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/already_logged_section.dart';
import 'package:logly/features/activity_logging/presentation/widgets/search_section_tile.dart';
import 'package:logly/features/activity_logging/presentation/widgets/view_all_chip.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:logly/features/subscriptions/domain/feature_code.dart';
import 'package:logly/features/subscriptions/presentation/providers/entitlement_provider.dart';
import 'package:logly/features/subscriptions/presentation/providers/subscription_service_provider.dart';
import 'package:logly/features/subscriptions/presentation/widgets/pro_badge.dart';
import 'package:logly/widgets/logly_icons.dart' show ActivityCategoryIcon;
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen for searching and selecting an activity to log.
///
/// Shows search results, favorites section, and category sections.
/// Uses push replacement navigation to LogActivityScreen.
class ActivitySearchScreen extends ConsumerStatefulWidget {
  const ActivitySearchScreen({
    this.initialDate,
    this.entryPoint,
    super.key,
  });

  final DateTime? initialDate;
  final String? entryPoint;

  @override
  ConsumerState<ActivitySearchScreen> createState() => _ActivitySearchScreenState();
}

class _ActivitySearchScreenState extends ConsumerState<ActivitySearchScreen> {
  late TextEditingController _searchController;
  late DateTime _selectedDate;
  final FocusNode _searchFocusNode = FocusNode();
  String? _lastTrackedQuery;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedDate = widget.initialDate ?? DateTime.now();
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectActivity(ActivitySummary activity) {
    // Use push replacement to navigate to LogActivityScreen
    // This replaces the search screen so save just pops once
    LogActivityRoute(
      activityId: activity.activityId,
      date: _selectedDate.toIso8601String(),
      entryPoint: widget.entryPoint,
    ).pushReplacement(context);
  }

  void _navigateToCategory(ActivityCategory category) {
    ref.read(analyticsServiceProvider).trackCategoryBrowsed(categoryName: category.name);
    CategoryDetailRoute(
      categoryId: category.activityCategoryId,
      date: _selectedDate.toIso8601String(),
      entryPoint: widget.entryPoint,
    ).pushReplacement(context);
  }

  void _navigateToCreateActivity(String searchQuery) {
    CreateCustomActivityRoute(
      name: searchQuery,
      date: _selectedDate.toIso8601String(),
    ).pushReplacement(context);
  }

  /// Checks if there's an exact match (case-insensitive) in the search results.
  bool _hasExactMatch(List<ActivitySummary> activities, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    return activities.any((a) => a.name.toLowerCase() == normalizedQuery);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final favoritesAsync = ref.watch(favoriteActivitiesProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

    final isSearching = searchQuery.trim().length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Activity'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: _pickDate,
            icon: const Icon(LucideIcons.calendar),
            label: Text(DateFormat.yMMMd().format(_selectedDate)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search activities...',
                prefixIcon: const Icon(LucideIcons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(LucideIcons.x),
                        onPressed: _clearSearch,
                      )
                    : null,
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

  Widget _buildSearchResults(AsyncValue<List<ActivitySummary>> searchResultsAsync) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(searchQueryProvider);

    return searchResultsAsync.when(
      data: (activities) {
        if (searchQuery != _lastTrackedQuery) {
          _lastTrackedQuery = searchQuery;
          ref.read(analyticsServiceProvider).trackActivitySearchPerformed(
            query: searchQuery,
            resultCount: activities.length,
          );
        }
        final showCreateOption = searchQuery.trim().length >= 2 && !_hasExactMatch(activities, searchQuery);

        if (activities.isEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Empty state
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Icon(
                        LucideIcons.searchX,
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
                        'Try a different search term or create a custom activity',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Create custom activity option (below empty state)
                if (showCreateOption) ...[
                  const SizedBox(height: 16),
                  _buildCreateActivityTile(searchQuery),
                ],
              ],
            ),
          );
        }

        // Display search results with create option at top if no exact match
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity chips
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 8,
                  children: activities.map((activity) {
                    return ActivityChip(
                      activity: activity,
                      showIcon: false,
                      onPressed: () => _selectActivity(activity),
                    );
                  }).toList(),
                ),
              ),

              // Create custom activity option (below search results)
              if (showCreateOption) ...[
                const SizedBox(height: 16),
                _buildCreateActivityTile(searchQuery),
              ],
            ],
          ),
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

  Widget _buildCreateActivityTile(String searchQuery) {
    final theme = Theme.of(context);
    final hasAccess = ref.watch(hasCreateCustomActivityProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(
          'Create "$searchQuery"',
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create a custom activity',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const ProBadge(
              feature: FeatureCode.createCustomActivity,
              margin: EdgeInsets.only(left: 8),
            ),
          ],
        ),
        trailing: const Icon(LucideIcons.chevronRight),
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        onTap: hasAccess
            ? () => _navigateToCreateActivity(searchQuery)
            : () => ref.read(subscriptionServiceProvider).showPaywall(source: 'create_custom_activity'),
      ),
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
          // Already logged section (hidden when empty)
          AlreadyLoggedSection(selectedDate: _selectedDate),

          // Favorites section (hidden when empty)
          favoritesAsync.when(
            data: (favorites) {
              // Filter out favorites with null activities
              final validFavorites = favorites.where((f) => f.activity != null).toList();
              if (validFavorites.isEmpty) {
                return const SizedBox.shrink();
              }

              return SearchSectionTile(
                sectionId: favoritesSectionId,
                title: 'Favorites',
                leading: const Icon(Icons.favorite, color: Colors.red, size: 24),
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 8,
                      children: validFavorites.map((favorite) {
                        return ActivityChip(
                          activity: favorite.activity!,
                          showIcon: false,
                          onPressed: () => _selectActivity(favorite.activity!),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Category sections
          categoriesAsync.when(
            data: (categories) => Column(
              children: categories.map((category) {
                return _CategorySection(
                  category: category,
                  onActivitySelected: _selectActivity,
                  onViewAll: () => _navigateToCategory(category),
                );
              }).toList(),
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
                      LucideIcons.circleAlert,
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

/// A category section showing suggested favorite activities.
class _CategorySection extends ConsumerWidget {
  const _CategorySection({
    required this.category,
    required this.onActivitySelected,
    required this.onViewAll,
  });

  final ActivityCategory category;
  final void Function(ActivitySummary) onActivitySelected;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(
      suggestedFavoritesByCategorySummaryProvider(category.activityCategoryId),
    );

    return SearchSectionTile(
      sectionId: categorySectionId(category.activityCategoryId),
      title: category.name,
      leading: ActivityCategoryIcon(activityCategory: category),
      children: [
        activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'No activities in this category',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  // Activity chips
                  ...activities.map((activity) {
                    return ActivityChip(
                      activity: activity,
                      showIcon: false,
                      onPressed: () => onActivitySelected(activity),
                    );
                  }),
                  // View all chip at the end
                  ViewAllChip(
                    categoryColor: category.color,
                    onPressed: onViewAll,
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Failed to load activities',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
