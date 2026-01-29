import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/profile/domain/category_summary.dart';
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

    return CollapsibleSection(
      title: 'Summary',
      isExpanded: isExpanded,
      onToggle: () => sectionsNotifier.toggle(ProfileSections.summary),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TimePeriodSelector(),
          SizedBox(height: 16),
          _SummaryContent(),
        ],
      ),
    );
  }
}

/// Content widget that maintains previous data during loading transitions
/// to enable smooth animations between time periods.
class _SummaryContent extends ConsumerStatefulWidget {
  const _SummaryContent();

  @override
  ConsumerState<_SummaryContent> createState() => _SummaryContentState();
}

class _SummaryContentState extends ConsumerState<_SummaryContent> {
  /// Cached summary data to show during loading transitions.
  List<CategorySummary>? _cachedSummaries;

  /// Cached max count for consistent scaling during transitions.
  int _cachedMaxCount = 1;

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(categorySummaryProvider);
    final categoriesAsync = ref.watch(activityCategoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        // Get current or cached summaries
        final summaries = summaryAsync.value ?? _cachedSummaries;
        final isLoading = summaryAsync.isLoading && _cachedSummaries != null;
        final hasError = summaryAsync.hasError && _cachedSummaries == null;

        // Update cache when we have new data
        if (summaryAsync.hasValue) {
          _cachedSummaries = summaryAsync.value;
          _cachedMaxCount = summaryAsync.value!.isEmpty
              ? 1
              : summaryAsync.value!.map((s) => s.activityCount).fold(0, (int a, int b) => a > b ? a : b);
        }

        // Show shimmer only on initial load
        if (summaries == null) {
          return const _SummaryShimmer();
        }

        // Show error only if we have no cached data
        if (hasError) {
          return _SummaryError(
            onRetry: () => ref.invalidate(categorySummaryProvider),
          );
        }

        // Create a map of category ID to activity count
        final summaryMap = {for (final s in summaries) s.activityCategoryId: s.activityCount};

        // Use cached max count during loading to prevent bar scaling jumps
        final maxCount = isLoading
            ? _cachedMaxCount
            : (summaries.isEmpty
                ? 1
                : summaries.map((s) => s.activityCount).fold(0, (int a, int b) => a > b ? a : b));

        // Sort categories by sortOrder
        final sortedCategories = [...categories]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

        return Column(
          children: sortedCategories.map((category) {
            final count = summaryMap[category.activityCategoryId] ?? 0;
            final color = Color(int.parse('FF${category.hexColor.replaceFirst('#', '')}', radix: 16));

            return CategoryProgressBar(
              // Key ensures Flutter updates existing widget instead of rebuilding
              key: ValueKey(category.activityCategoryId),
              categoryName: category.name,
              count: count,
              maxCount: maxCount,
              color: color,
            );
          }).toList(),
        );
      },
      loading: () => const _SummaryShimmer(),
      error: (_, __) => const _SummaryShimmer(),
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
            LucideIcons.circleAlert,
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
