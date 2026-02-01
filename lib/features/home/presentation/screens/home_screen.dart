import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/core/utils/extensions.dart';
import 'package:logly/features/home/domain/daily_activity_summary.dart';
import 'package:logly/features/home/presentation/providers/daily_activities_provider.dart';
import 'package:logly/features/home/presentation/providers/home_navigation_provider.dart';
import 'package:logly/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:logly/features/home/presentation/widgets/daily_activity_row.dart';
import 'package:logly/widgets/skeleton_loader.dart';

/// The main home screen displaying a chronological list of days with activities.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // Load more when near the bottom
      unawaited(ref.read(dailyActivitiesStateProvider.notifier).loadMore());
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(dailyActivitiesStateProvider.notifier).refresh();
  }

  void scrollToTop() {
    unawaited(
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  /// Generates placeholder summaries for loading state.
  List<DailyActivitySummary> _generatePlaceholders() {
    final now = DateTime.now();
    return List.generate(15, (index) {
      return DailyActivitySummary(
        activityDate: now.subtract(Duration(days: index)),
        activityCount: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeScrollToTopTriggerProvider, (previous, next) {
      if (previous != next) scrollToTop();
    });

    final dailyActivitiesAsync = ref.watch(dailyActivitiesStateProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Activities',
      ),
      body: SkellyWrapper(
        isLoading: dailyActivitiesAsync.isFirstLoad,
        child: dailyActivitiesAsync.when(
          // Keep showing previous data during refresh
          skipLoadingOnRefresh: true,
          data: (state) => RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.summaries.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.summaries.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return DailyActivityRow(summary: state.summaries[index]);
              },
            ),
          ),
          loading: () => ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return DailyActivityRow(summary: _generatePlaceholders()[index]);
            },
          ),
          error: (error, stackTrace) => _ErrorState(
            error: error,
            onRetry: () => ref.invalidate(dailyActivitiesStateProvider),
          ),
        ),
      ),
    );
  }
}

/// Error state with retry button.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.circleAlert,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load activities',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(LucideIcons.refreshCw),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
