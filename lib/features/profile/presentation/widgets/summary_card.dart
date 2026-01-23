import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/time_period.dart';
import 'package:logly/features/profile/presentation/providers/collapsible_sections_provider.dart';
import 'package:logly/features/profile/presentation/providers/summary_provider.dart';
import 'package:logly/features/profile/presentation/widgets/category_progress_bar.dart';
import 'package:logly/features/profile/presentation/widgets/collapsible_section.dart';

/// Card displaying category summary with time period filter.
class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsNotifier = ref.watch(collapsibleSectionsStateProvider.notifier);
    final isExpanded =
        ref.watch(collapsibleSectionsStateProvider)[ProfileSections.summary] ?? true;
    final summaryAsync = ref.watch(categorySummaryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return CollapsibleSection(
      title: 'Summary',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.summary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TimePeriodSelector(),
          const SizedBox(height: 16),
          summaryAsync.when(
            data: (summaries) {
              if (summaries.isEmpty) {
                return const _EmptyState();
              }

              final maxCount = summaries.map((s) => s.activityCount).fold(0, (a, b) => a > b ? a : b);

              return categoriesAsync.when(
                data: (categories) {
                  final categoryMap = {for (final c in categories) c.activityCategoryId: c};

                  // Sort summaries by category sortOrder
                  final sortedSummaries = [...summaries]..sort((a, b) {
                      final catA = categoryMap[a.activityCategoryId];
                      final catB = categoryMap[b.activityCategoryId];
                      final orderA = catA?.sortOrder ?? 999;
                      final orderB = catB?.sortOrder ?? 999;
                      return orderA.compareTo(orderB);
                    });

                  return Column(
                    children: sortedSummaries.map((summary) {
                      final category = categoryMap[summary.activityCategoryId];
                      final color = category != null
                          ? Color(int.parse('FF${category.hexColor.replaceFirst('#', '')}', radix: 16))
                          : Colors.grey;

                      return CategoryProgressBar(
                        categoryName: category?.name ?? 'Unknown',
                        count: summary.activityCount,
                        maxCount: maxCount,
                        color: color,
                      );
                    }).toList(),
                  );
                },
                loading: () => const _SummaryShimmer(),
                error: (_, _) => const _SummaryShimmer(),
              );
            },
            loading: () => const _SummaryShimmer(),
            error: (error, _) => _SummaryError(
              onRetry: () => ref.invalidate(categorySummaryProvider),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePeriodSelector extends ConsumerWidget {
  const _TimePeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedTimePeriodStateProvider);
    final notifier = ref.watch(selectedTimePeriodStateProvider.notifier);

    return Row(
      children: TimePeriod.values.asMap().entries.map((entry) {
        final index = entry.key;
        final period = entry.value;
        final isSelected = period == selectedPeriod;
        final isLast = index == TimePeriod.values.length - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: FilterChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  _getPeriodLabel(period),
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => notifier.select(period),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getPeriodLabel(TimePeriod period) {
    switch (period) {
      case TimePeriod.oneWeek:
        return '1W';
      case TimePeriod.oneMonth:
        return '1M';
      case TimePeriod.oneYear:
        return '1Y';
      case TimePeriod.all:
        return 'All';
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'No activities logged',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryShimmer extends StatelessWidget {
  const _SummaryShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 80,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryError extends StatelessWidget {
  const _SummaryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load summary',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
