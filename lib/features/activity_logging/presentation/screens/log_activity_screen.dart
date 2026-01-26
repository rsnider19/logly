import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/favorites_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/date_picker_field.dart';
import 'package:logly/features/activity_logging/presentation/widgets/date_range_picker.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/distance_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/duration_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/environment_selector.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/liquid_volume_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/numeric_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/detail_inputs/weight_input.dart';
import 'package:logly/features/activity_logging/presentation/widgets/pace_display.dart';
import 'package:logly/features/activity_logging/presentation/widgets/subactivity_selector.dart';
import 'package:logly/widgets/logly_icons.dart';

/// Screen for logging a new activity.
///
/// Receives an [Activity] and optional initial [DateTime] and renders
/// dynamic detail fields based on the activity's configuration.
class LogActivityScreen extends ConsumerStatefulWidget {
  const LogActivityScreen({
    required this.activity,
    this.initialDate,
    super.key,
  });

  final Activity activity;
  final DateTime? initialDate;

  @override
  ConsumerState<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends ConsumerState<LogActivityScreen> {
  late TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();

    // Initialize form state after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(activityFormStateProvider.notifier)
          .initForCreate(
            widget.activity,
            initialDate: widget.initialDate,
          );
    });
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _saveActivity() async {
    final notifier = ref.read(activityFormStateProvider.notifier);
    final result = await notifier.submit();

    if (!mounted) return;

    switch (result) {
      case SubmitResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity logged successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop(true);
      case SubmitResult.partialSuccess:
        // Show dialog for partial success
        final formState = ref.read(activityFormStateProvider);
        final multiDayResult = formState.multiDayResult;
        if (multiDayResult != null) {
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Partial Success'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${multiDayResult.successCount} of ${multiDayResult.totalDays} days logged successfully.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed days:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...multiDayResult.failures.map(
                    (failure) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${_formatDate(failure.date)}: ${failure.errorMessage}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        // Still pop since some activities were logged
        if (mounted) {
          context.pop(true);
        }
      case SubmitResult.failure:
        // Error is shown in the form UI
        break;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _toggleFavorite() {
    unawaited(ref.read(favoriteStateProvider.notifier).toggle(widget.activity.activityId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final favoritesState = ref.watch(favoriteStateProvider);
    final isFavorited =
        favoritesState.whenOrNull(
          data: (ids) => ids.contains(widget.activity.activityId),
        ) ??
        false;

    final activityColor = widget.activity.getColor(context);
    final sortedDetails = List<ActivityDetail>.from(widget.activity.activityDetail)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final showDateRange = widget.activity.activityDateType == ActivityDateType.range;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ActivityIcon(activity: widget.activity, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.activity.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorited ? Icons.star : Icons.star_border,
              color: isFavorited ? Colors.amber : null,
            ),
            tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: formState.activity == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Activity header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: activityColor.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: activityColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      ActivityIcon(
                        activity: widget.activity,
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.activity.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.activity.activityCategory != null)
                              Text(
                                widget.activity.activityCategory!.name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date picker
                        if (showDateRange) const DateRangePicker() else const DatePickerField(),

                        const SizedBox(height: 24),

                        // Subactivity selector
                        if (widget.activity.subActivity.isNotEmpty) ...[
                          SubActivitySelector(subActivities: widget.activity.subActivity),
                          const SizedBox(height: 24),
                        ],

                        // Dynamic detail inputs
                        ...sortedDetails.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildDetailInput(detail),
                          );
                        }),

                        // Pace display (if applicable)
                        if (widget.activity.paceType != null) ...[
                          PaceDisplay(paceType: widget.activity.paceType!),
                          const SizedBox(height: 24),
                        ],

                        // Comments field
                        Text(
                          'Notes',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentsController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add notes about this activity...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            ref
                                .read(activityFormStateProvider.notifier)
                                .setComments(
                                  value.isEmpty ? null : value,
                                );
                          },
                        ),

                        // Error message
                        if (formState.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    formState.errorMessage!,
                                    style: TextStyle(
                                      color: theme.colorScheme.onErrorContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                // Save button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: formState.isSubmitting ? null : _saveActivity,
                        child: formState.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Activity'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDetailInput(ActivityDetail detail) {
    return switch (detail.activityDetailType) {
      ActivityDetailType.duration => DurationInput(activityDetail: detail),
      ActivityDetailType.distance => DistanceInput(activityDetail: detail),
      ActivityDetailType.integer || ActivityDetailType.double_ => NumericInput(activityDetail: detail),
      ActivityDetailType.environment => EnvironmentSelector(activityDetail: detail),
      ActivityDetailType.liquidVolume => LiquidVolumeInput(activityDetail: detail),
      ActivityDetailType.weight => WeightInput(activityDetail: detail),
      ActivityDetailType.string => _buildTextInput(detail),
      ActivityDetailType.location => _buildLocationInput(detail),
    };
  }

  Widget _buildTextInput(ActivityDetail detail) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter ${detail.label.toLowerCase()}',
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            ref
                .read(activityFormStateProvider.notifier)
                .setTextValue(
                  detail.activityDetailId,
                  value.isEmpty ? null : value,
                );
          },
        ),
      ],
    );
  }

  Widget _buildLocationInput(ActivityDetail detail) {
    final theme = Theme.of(context);
    // Location input is a placeholder - full implementation would use a map picker
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                'Location picker coming soon',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
