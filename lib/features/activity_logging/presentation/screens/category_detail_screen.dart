import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
import 'package:logly/features/activity_catalog/presentation/providers/category_provider.dart';
import 'package:logly/features/home/presentation/widgets/activity_chip.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen showing all activities in a category.
///
/// Activities are displayed as outlined chips in a scrollable Wrap.
/// Selecting an activity replaces the entire modal stack with LogActivityScreen.
class CategoryDetailScreen extends ConsumerStatefulWidget {
  const CategoryDetailScreen({
    required this.categoryId,
    this.initialDate,
    this.entryPoint,
    super.key,
  });

  /// The ID of the category to display.
  final String categoryId;

  /// Optional initial date for logging activities.
  final DateTime? initialDate;

  /// Analytics entry point tracking.
  final String? entryPoint;

  @override
  ConsumerState<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends ConsumerState<CategoryDetailScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
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
    // Replace entire modal stack with LogActivityScreen
    // This ensures save just pops once to return to initial screen
    LogActivityRoute(
      activityId: activity.activityId,
      date: _selectedDate.toIso8601String(),
      entryPoint: widget.entryPoint,
    ).pushReplacement(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryAsync = ref.watch(categoryByIdProvider(widget.categoryId));
    final activitiesAsync = ref.watch(activitiesByCategorySummaryProvider(widget.categoryId));

    return Scaffold(
      appBar: AppBar(
        title: categoryAsync.when(
          data: (category) => Text(category.name),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Category'),
        ),
        actions: [
          TextButton(
            onPressed: _pickDate,
            child: Text(DateFormat.yMMMd().format(_selectedDate)),
          ),
        ],
      ),
      body: activitiesAsync.when(
        data: (activities) {
          if (activities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.layoutGrid,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activities in this category',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Align(
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleAlert,
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load activities',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(activitiesByCategorySummaryProvider(widget.categoryId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
