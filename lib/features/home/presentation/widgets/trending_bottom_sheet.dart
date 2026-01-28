import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/home/domain/trending_activity.dart';
import 'package:logly/features/home/presentation/providers/trending_provider.dart';
import 'package:logly/widgets/logly_icons.dart';

/// Bottom sheet displaying global trending activities.
class TrendingBottomSheet extends ConsumerWidget {
  const TrendingBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final trendingAsync = ref.watch(trendingActivitiesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
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
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Trending Activities',
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              // List
              Expanded(
                child: trendingAsync.when(
                  data: (activities) {
                    if (activities.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_flat,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No trending activities yet',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return _TrendingActivityTile(activity: activities[index]);
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load trending activities',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => ref.invalidate(trendingActivitiesProvider),
                            child: const Text('Retry'),
                          ),
                        ],
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
}

/// Tile displaying a single trending activity.
class _TrendingActivityTile extends StatelessWidget {
  const _TrendingActivityTile({required this.activity});

  final TrendingActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activityData = activity.activity;

    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rank number
          SizedBox(
            width: 32,
            child: Text(
              '${activity.currentRank}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          // Activity icon
          if (activityData != null)
            ActivityIcon(activity: activityData)
          else
            const Icon(Icons.category_outlined, size: 24),
        ],
      ),
      title: Text(activityData?.name ?? 'Unknown Activity'),
      trailing: _RankChangeIndicator(rankChange: activity.rankChange),
    );
  }
}

/// Indicator showing rank change direction and magnitude.
class _RankChangeIndicator extends StatelessWidget {
  const _RankChangeIndicator({required this.rankChange});

  final int rankChange;

  @override
  Widget build(BuildContext context) {
    if (rankChange == 0) {
      return Icon(
        Icons.trending_flat,
        size: 24,
        color: Colors.grey[500],
      );
    }

    final isUp = rankChange > 0;
    final color = isUp ? Colors.green : Colors.red;
    final icon = isUp ? Icons.trending_up : Icons.trending_down;

    return Icon(
      icon,
      size: 24,
      color: color,
    );
  }
}
