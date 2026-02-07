import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:logly/features/activity_catalog/domain/activity_date_type.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail.dart';
import 'package:logly/features/activity_catalog/domain/activity_detail_type.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/activity_catalog/presentation/providers/activity_provider.dart';
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
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/settings/domain/user_preferences.dart';
import 'package:logly/features/settings/presentation/providers/preferences_provider.dart';
import 'package:logly/features/voice_logging/domain/voice_parse_response.dart';
import 'package:logly/features/voice_logging/presentation/providers/voice_input_provider.dart';
import 'package:logly/widgets/logly_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Screen for logging a new activity.
///
/// Fetches the full [Activity] by ID on load, then renders
/// dynamic detail fields based on the activity's configuration.
class LogActivityScreen extends ConsumerStatefulWidget {
  const LogActivityScreen({
    required this.activityId,
    this.initialDate,
    this.entryPoint,
    super.key,
  });

  final String activityId;
  final DateTime? initialDate;
  final String? entryPoint;

  @override
  ConsumerState<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends ConsumerState<LogActivityScreen> {
  late TextEditingController _commentsController;
  bool _formInitialized = false;

  @override
  void initState() {
    super.initState();
    _commentsController = TextEditingController();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void _initFormIfNeeded(Activity activity) {
    if (!_formInitialized) {
      _formInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final prefsState = ref.read(preferencesStateProvider);
        final isMetric = prefsState.whenOrNull(
              data: (prefs) => prefs.unitSystem == UnitSystem.metric,
            ) ??
            true;

        final notifier = ref.read(activityFormStateProvider.notifier);
        notifier.initForCreate(
          activity,
          initialDate: widget.initialDate,
          isMetric: isMetric,
        );

        // Apply voice prepopulation if available
        final voicePrepop = ref.read(voicePrepopulationProvider);
        if (voicePrepop != null) {
          _applyVoicePrepopulation(notifier, activity, voicePrepop);
          ref.read(voicePrepopulationProvider.notifier).clear();
        }
      });
    }
  }

  void _applyVoicePrepopulation(
    ActivityFormStateNotifier notifier,
    Activity activity,
    VoiceParsedData prepop,
  ) {
    // Apply duration to first duration detail
    if (prepop.duration != null) {
      final durationDetail = activity.activityDetail
          .where((d) => d.activityDetailType == ActivityDetailType.duration)
          .firstOrNull;
      if (durationDetail != null) {
        notifier.setDurationValue(durationDetail.activityDetailId, prepop.duration!.seconds);
      }
    }

    // Apply distance to first distance detail
    if (prepop.distance != null) {
      final distanceDetail = activity.activityDetail
          .where((d) => d.activityDetailType == ActivityDetailType.distance)
          .firstOrNull;
      if (distanceDetail != null) {
        notifier.setDistanceValue(distanceDetail.activityDetailId, prepop.distance!.meters);
      }
    }

    // Apply date if provided
    if (prepop.date != null) {
      final parsedDate = DateTime.tryParse(prepop.date!.iso);
      if (parsedDate != null) {
        notifier.setActivityDate(parsedDate);
      }
    }

    // Apply comments if there's leftover text
    if (prepop.comments != null && prepop.comments!.isNotEmpty) {
      notifier.setComments(prepop.comments);
      _commentsController.text = prepop.comments!;
    }
  }

  void _trackActivityLogged(Activity activity) {
    final formState = ref.read(activityFormStateProvider);
    ref.read(analyticsServiceProvider).trackActivityLogged(
      category: activity.activityCategory?.name ?? 'unknown',
      activityName: activity.name,
      isCustom: false,
      isHealthSync: false,
      hasNotes: formState.comments != null && formState.comments!.isNotEmpty,
      detailTypes: activity.activityDetail.map((d) => d.activityDetailType.name).toList(),
      entryPoint: widget.entryPoint ?? 'unknown',
    );
  }

  Future<void> _saveActivity() async {
    final notifier = ref.read(activityFormStateProvider.notifier);

    // Try optimistic save for single-day creates
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      final request = notifier.prepareOptimisticSave(currentUser.id);
      if (request != null) {
        ref.read(pendingSaveStateProvider.notifier).submitOptimistic(request);
        _trackActivityLogged(request.activity);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Activity logged'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
          context.pop(true);
        }
        return;
      }
    }

    // Fallback: synchronous save for edits / multi-day / no user
    final result = await notifier.submit();

    if (!mounted) return;

    switch (result) {
      case SubmitResult.success:
        final activity = ref.read(activityFormStateProvider).activity;
        if (activity != null) _trackActivityLogged(activity);
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
    final favState = ref.read(favoriteStateProvider);
    final isFavorited = favState.whenOrNull(data: (ids) => ids.contains(widget.activityId)) ?? false;
    final activity = ref.read(activityFormStateProvider).activity;

    unawaited(ref.read(favoriteStateProvider.notifier).toggle(widget.activityId));

    if (activity != null) {
      ref.read(analyticsServiceProvider).trackFavoriteToggled(
        activityName: activity.name,
        category: activity.activityCategory?.name ?? 'unknown',
        isFavorited: !isFavorited, // Track the NEW state after toggle
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activityAsync = ref.watch(activityByIdProvider(widget.activityId));

    return activityAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Log Activity')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Log Activity')),
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
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => ref.invalidate(activityByIdProvider(widget.activityId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (activity) {
        _initFormIfNeeded(activity);
        return _buildForm(context, activity);
      },
    );
  }

  Widget _buildForm(BuildContext context, Activity activity) {
    final theme = Theme.of(context);
    final formState = ref.watch(activityFormStateProvider);
    final favoritesState = ref.watch(favoriteStateProvider);
    final isFavorited =
        favoritesState.whenOrNull(
          data: (ids) => ids.contains(widget.activityId),
        ) ??
        false;

    final sortedDetails = List<ActivityDetail>.from(activity.activityDetail)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final showDateRange = activity.activityDateType == ActivityDateType.range;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Activity'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : null,
            ),
            tooltip: isFavorited ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            theme.textTheme.headlineMedium!.fontSize! * theme.textTheme.headlineMedium!.height! + 8,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              children: [
                ActivityIcon(
                  activity: activity,
                ),
                const SizedBox(width: 8),
                Text(
                  activity.name,
                  textAlign: TextAlign.start,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: formState.activity == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        const CustomNameInput(),

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
                          'Comments',
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _commentsController,
                          maxLines: 6,
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
                // Save button - hidden when keyboard is open
                if (MediaQuery.of(context).viewInsets.bottom == 0)
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
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter ${detail.label.toLowerCase()}',
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
