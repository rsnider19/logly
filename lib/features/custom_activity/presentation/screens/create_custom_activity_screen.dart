import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/custom_activity/domain/activity_detail_config.dart';
import 'package:logly/features/custom_activity/presentation/providers/create_custom_activity_form_provider.dart';
import 'package:logly/features/custom_activity/presentation/widgets/activity_name_input.dart';
import 'package:logly/features/custom_activity/presentation/widgets/add_detail_section.dart';
import 'package:logly/features/custom_activity/presentation/widgets/category_selector.dart';
import 'package:logly/features/custom_activity/presentation/widgets/detail_card.dart';
import 'package:logly/features/custom_activity/presentation/widgets/distance_detail_form.dart';
import 'package:logly/features/custom_activity/presentation/widgets/duration_detail_form.dart';
import 'package:logly/features/custom_activity/presentation/widgets/environment_detail_form.dart';
import 'package:logly/features/custom_activity/presentation/widgets/number_detail_form.dart';
import 'package:logly/features/custom_activity/presentation/widgets/pace_detail_form.dart';

/// Screen for creating a custom activity.
class CreateCustomActivityScreen extends ConsumerStatefulWidget {
  const CreateCustomActivityScreen({
    this.initialName,
    this.initialDate,
    super.key,
  });

  final String? initialName;
  final DateTime? initialDate;

  @override
  ConsumerState<CreateCustomActivityScreen> createState() => _CreateCustomActivityScreenState();
}

class _CreateCustomActivityScreenState extends ConsumerState<CreateCustomActivityScreen> {
  late TextEditingController _nameController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');

    // Initialize the form state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createCustomActivityFormStateProvider.notifier).init(
            initialName: widget.initialName,
          );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final notifier = ref.read(createCustomActivityFormStateProvider.notifier);
    final success = await notifier.save();

    if (!mounted) return;

    if (success) {
      final state = ref.read(createCustomActivityFormStateProvider);
      final activity = state.createdActivity;

      if (activity != null) {
        // Navigate to log activity screen with the new activity
        LogActivityRoute(
          activityId: activity.activityId,
          date: widget.initialDate?.toIso8601String(),
        ).pushReplacement(context);
      }
    } else {
      // Show error snackbar
      final state = ref.read(createCustomActivityFormStateProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Failed to create activity'),
          backgroundColor: Theme.of(context).colorScheme.error,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Theme.of(context).colorScheme.onError,
            onPressed: _handleSave,
          ),
        ),
      );
    }
  }

  Future<bool> _handleBackPress() async {
    final state = ref.read(createCustomActivityFormStateProvider);

    if (!state.isDirty) {
      return true;
    }

    // Show discard confirmation dialog
    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldDiscard ?? false;
  }

  void _handleAddDetail(ActivityDetailConfig detail) {
    ref.read(createCustomActivityFormStateProvider.notifier).addDetail(detail);

    // Scroll to bottom after adding a detail
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(createCustomActivityFormStateProvider);
    final validation = ref.watch(createCustomActivityValidationProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final canPop = await _handleBackPress();
        if (canPop && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () async {
              final canPop = await _handleBackPress();
              if (canPop && mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Cancel'),
          ),
          leadingWidth: 80,
          title: const Text('Create Activity'),
          actions: [
            TextButton(
              onPressed: validation.canSubmit && !formState.isSaving ? _handleSave : null,
              child: formState.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
        body: Column(
          children: [
            // Scrollable form content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category selector
                    CategorySelector(
                      selectedCategoryId: formState.categoryId,
                      onCategorySelected: (categoryId) {
                        ref.read(createCustomActivityFormStateProvider.notifier).setCategory(categoryId);
                      },
                      hasError: !validation.hasCategorySelected && formState.name.isNotEmpty,
                    ),
                    const SizedBox(height: 24),

                    // Activity name input
                    ActivityNameInput(
                      controller: _nameController,
                      onChanged: (name) {
                        ref.read(createCustomActivityFormStateProvider.notifier).setName(name);
                      },
                      errorText: formState.name.isNotEmpty && !validation.isNameValid
                          ? 'Name must be 2-50 characters'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Detail cards
                    if (formState.details.isNotEmpty) ...[
                      Text(
                        'Details',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...formState.details.map((detail) => _buildDetailCard(detail, formState)),
                    ],

                    // Pace dependency error
                    if (validation.paceDependencyError != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: theme.colorScheme.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                validation.paceDependencyError!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Spacer for sticky bottom
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Sticky add detail section
            AddDetailSection(
              onAddDetail: _handleAddDetail,
              isAtLimit: formState.isAtDetailLimit,
              hasEnvironment: formState.hasEnvironment,
              hasPace: formState.hasPace,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(ActivityDetailConfig detail, CreateCustomActivityFormState formState) {
    final notifier = ref.read(createCustomActivityFormStateProvider.notifier);

    return DetailCard(
      detail: detail,
      onDelete: () => notifier.removeDetail(detail.id),
      child: switch (detail) {
        NumberDetailConfig() => NumberDetailForm(
            config: detail,
            onLabelChanged: (label) => notifier.updateNumberLabel(detail.id, label),
            onIsIntegerChanged: (isInteger) => notifier.updateNumberIsInteger(detail.id, isInteger: isInteger),
            onMaxValueChanged: (maxValue) => notifier.updateNumberMaxValue(detail.id, maxValue),
          ),
        DurationDetailConfig() => DurationDetailForm(
            config: detail,
            onLabelChanged: (label) => notifier.updateDurationLabel(detail.id, label),
            onMaxSecondsChanged: (maxSeconds) => notifier.updateDurationMaxSeconds(detail.id, maxSeconds),
            onUseForPaceChanged: (useForPace) => notifier.updateDurationUseForPace(detail.id, useForPace: useForPace),
            paceEnabled: formState.hasPace || !formState.hasDurationForPace,
          ),
        DistanceDetailConfig() => DistanceDetailForm(
            config: detail,
            onLabelChanged: (label) => notifier.updateDistanceLabel(detail.id, label),
            onIsShortChanged: (isShort) => notifier.updateDistanceIsShort(detail.id, isShort: isShort),
            onMaxValueChanged: (maxValue) => notifier.updateDistanceMaxValue(detail.id, maxValue),
            onUseForPaceChanged: (useForPace) => notifier.updateDistanceUseForPace(detail.id, useForPace: useForPace),
            paceEnabled: formState.hasPace || !formState.hasDistanceForPace,
          ),
        EnvironmentDetailConfig() => EnvironmentDetailForm(
            config: detail,
            onLabelChanged: (label) => notifier.updateEnvironmentLabel(detail.id, label),
          ),
        PaceDetailConfig() => PaceDetailForm(
            config: detail,
            onPaceTypeChanged: (paceType) => notifier.updatePaceType(detail.id, paceType),
            areDependenciesMet: formState.arePaceDependenciesMet,
          ),
      },
    );
  }
}
