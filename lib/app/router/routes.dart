import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/core/services/env_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_category.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/activity_logging/presentation/screens/activity_search_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/edit_activity_screen.dart';
import 'package:logly/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'routes.g.dart';

/// Home route - main screen of the app.
@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _ConnectionTestScreen();
  }
}

/// Auth route - authentication screen.
@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

/// Activity search route - search and select activities to log.
@TypedGoRoute<ActivitySearchRoute>(path: '/activities/search')
class ActivitySearchRoute extends GoRouteData with $ActivitySearchRoute {
  const ActivitySearchRoute({this.date});

  /// Optional initial date for the activity (ISO 8601 string).
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? initialDate;
    if (date != null) {
      initialDate = DateTime.tryParse(date!);
    }
    return ActivitySearchScreen(initialDate: initialDate);
  }
}

/// Edit activity route - edit an existing logged activity.
@TypedGoRoute<EditActivityRoute>(path: '/activities/edit/:userActivityId')
class EditActivityRoute extends GoRouteData with $EditActivityRoute {
  const EditActivityRoute({required this.userActivityId});

  final String userActivityId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditActivityScreen(userActivityId: userActivityId);
  }
}

/// Screen to test Supabase connection.
class _ConnectionTestScreen extends ConsumerStatefulWidget {
  const _ConnectionTestScreen();

  @override
  ConsumerState<_ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends ConsumerState<_ConnectionTestScreen> {
  String _status = 'Testing connection...';
  int? _trendingCount;
  String? _error;
  bool _isSigningOut = false;

  @override
  void initState() {
    super.initState();
    unawaited(_testConnection());
  }

  Future<void> _testConnection() async {
    try {
      final response = await Supabase.instance.client
          .from('trending_activity')
          .select('activity_id')
          .limit(100);

      final count = (response as List).length;
      setState(() {
        _trendingCount = count;
        _status = count > 0 ? 'Connected' : 'Connected (RLS active)';
        _error = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Failed';
        _error = e.toString();
      });
    }
  }

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
      }
    }
  }

  void _showActivitiesSheet(ActivityCategory category) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ActivitiesBottomSheet(category: category),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Connection Test')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Icon(
                        _error == null ? Icons.check_circle : Icons.error,
                        size: 64,
                        color: _error == null ? Colors.green : Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _status,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      if (user != null) ...[
                        Text(
                          user.email ?? 'No email',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_trendingCount != null) ...[
                        Text(
                          'Trending activities: $_trendingCount',
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (_trendingCount == 0)
                          Text(
                            '(RLS blocking anonymous access - expected)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          'URL: ${EnvService.supabaseUrl}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _testConnection,
                        child: const Text('Retry'),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _isSigningOut ? null : _signOut,
                        child: _isSigningOut
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Sign Out'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text('Categories', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (categories) => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: categories.map((category) {
                    final color = _parseColor(category.hexColor);
                    return ActionChip(
                      avatar: CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          category.icon,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      label: Text(category.name),
                      onPressed: () => _showActivitiesSheet(category),
                    );
                  }).toList(),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, _) => Text(
                  'Failed to load categories: $error',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

/// Bottom sheet showing activities for a category.
class _ActivitiesBottomSheet extends ConsumerWidget {
  const _ActivitiesBottomSheet({required this.category});

  final ActivityCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(activitiesByCategoryProvider(category.activityCategoryId));
    final color = _parseColor(category.hexColor);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      child: Text(category.icon),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.name,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              Expanded(
                child: activitiesAsync.when(
                  data: (activities) {
                    final displayActivities = activities.take(10).toList();
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: displayActivities.length,
                      itemBuilder: (context, index) {
                        final activity = displayActivities[index];
                        return _ActivityTile(activity: activity);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Failed to load activities: $error',
                        style: TextStyle(color: theme.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

/// Tile displaying a single activity.
class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _parseColor(activity.effectiveColor);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: activity.icon != null
            ? Text(activity.icon!, style: const TextStyle(fontSize: 18))
            : Icon(Icons.fitness_center, color: color),
      ),
      title: Text(activity.name),
      subtitle: activity.description != null
          ? Text(
              activity.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (activity.activityDetail.isNotEmpty)
            Text(
              '${activity.activityDetail.length} details',
              style: theme.textTheme.bodySmall,
            ),
          if (activity.subActivity.isNotEmpty)
            Text(
              '${activity.subActivity.length} sub-activities',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
