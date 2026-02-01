import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/features/activity_logging/application/activity_logging_service.dart';
import 'package:logly/features/activity_logging/domain/user_activity.dart';
import 'package:logly/features/activity_logging/presentation/providers/activity_form_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/favorites_provider.dart';
import 'package:logly/features/activity_logging/presentation/providers/pending_save_provider.dart';
import 'package:logly/features/activity_logging/presentation/widgets/custom_name_input.dart';
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
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen for editing an existing logged activity.
///
/// Loads the [UserActivity] by ID and populates the form for editing.
class EditActivityScreen extends ConsumerStatefulWidget {
  const EditActivityScreen({
    required this.userActivityId,
    super.key,
  });

  final String userActivityId;

  @override
  ConsumerState<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<EditActivityScreen> {
  late TextEditingController _commentsController;
  bool _isLoading = true;
  bool _isDeleting = false;
  String? _loadError;
  UserActivity? _userActivity;

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();
    unawaited(_loadActivity());
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _loadActivity() async {
    try {
      final service = ref.read(activityLoggingServiceProvider);
      final userActivity = await service.getUserActivityById(widget.userActivityId);

      if (mounted) {
        setState(() {
          _userActivity = userActivity;
          _isLoading = false;
          _commentsController.text = userActivity.comments ?? '';
        });

        // Initialize form state
        ref.read(activityFormStateProvider.notifier).initForEdit(userActivity);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadError = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveActivity() async {
    final notifier = ref.read(activityFormStateProvider.notifier);

    // Try optimistic update first
    final request = notifier.prepareOptimisticUpdate();
    if (request != null) {
      ref.read(pendingSaveStateProvider.notifier).submitOptimisticUpdate(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Activity updated'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ),
        );
        context.pop(true);
      }
      return;
    }

    // Fallback to sync save
    final result = await notifier.submit();

    if (!mounted) return;

    // Editing only supports single day, so we only care about success or failure
    if (result == SubmitResult.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop(true);
    }
    // On failure, error is shown in the form UI
  }

  Future<void> _deleteActivity() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text(
          'Are you sure you want to delete this activity? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isDeleting = true);

      try {
        final service = ref.read(activityLoggingServiceProvider);
        await service.deleteActivity(widget.userActivityId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Activity deleted'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isDeleting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _toggleFavorite() {
    if (_userActivity?.activity != null) {
      unawaited(ref.read(favoriteStateProvider.notifier).toggle(_userActivity!.activity!.activityId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Activity')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Activity')),
        body: Center(
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
                  'Failed to load activity',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _loadError = null;
                    });
                    unawaited(_loadActivity());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final activity = _userActivity!.activity;
    if (activity == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Activity')),
        body: const Center(child: Text('Activity not found')),
      );
    }

    final favoritesState = ref.watch(favoriteStateProvider);
    final isFavorited =
        favoritesState.whenOrNull(
          data: (ids) => ids.contains(activity.activityId),
        ) ??
        false;

    final activityColor = activity.getColor(context);
    final sortedDetails = List<ActivityDetail>.from(activity.activityDetail)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final showDateRange = activity.activityDateType == ActivityDateType.range;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ActivityStatisticsRoute(
                activityId: activity.activityId,
                activityName: activity.name,
                initialMonth: _userActivity!.activityTimestamp.toIso8601String(),
                colorHex: activity.activityCategory?.hexColor,
              ).push<void>(context);
            },
            icon: const Icon(LucideIcons.chartNoAxesCombined),
            tooltip: 'View statistics',
          ),
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : null,
            ),
            tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
          ),
          IconButton(
            onPressed: _isDeleting ? null : _deleteActivity,
            icon: _isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.trash2),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _userActivity!.displayName,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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

                  // Custom name
                  CustomNameInput(initialValue: _userActivity!.activityNameOverride),

                  const SizedBox(height: 24),

                  // Subactivity selector
                  if (activity.subActivity.isNotEmpty) ...[
                    SubActivitySelector(subActivities: activity.subActivity),
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
                  if (activity.paceType != null) ...[
                    PaceDisplay(paceType: activity.paceType!),
                    const SizedBox(height: 24),
                  ],

                  // Comments field
                  Text(
                    'Notes',
                    style: theme.textTheme.bodyLarge,
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
                            LucideIcons.circleAlert,
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
                      : const Text('Save Changes'),
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
    final formState = ref.watch(activityFormStateProvider);
    final detailValue = formState.detailValues[detail.activityDetailId];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: detailValue?.textValue,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail.label,
          style: theme.textTheme.bodyLarge,
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
                LucideIcons.mapPin,
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
