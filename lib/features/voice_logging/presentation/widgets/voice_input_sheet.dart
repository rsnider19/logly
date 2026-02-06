import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/voice_logging/presentation/providers/voice_input_provider.dart';
import 'package:logly/features/voice_logging/presentation/widgets/activity_disambiguation_list.dart';
import 'package:logly/app/router/routes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Bottom sheet for voice input.
///
/// Handles the full voice logging flow:
/// 1. Permission request
/// 2. Listening with visual feedback
/// 3. Processing
/// 4. Disambiguation (if multiple matches)
/// 5. Navigation to LogActivityScreen
class VoiceInputSheet extends ConsumerStatefulWidget {
  const VoiceInputSheet({super.key});

  @override
  ConsumerState<VoiceInputSheet> createState() => _VoiceInputSheetState();
}

class _VoiceInputSheetState extends ConsumerState<VoiceInputSheet> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Auto-start listening when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceInputStateNotifierProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    // Cancel any ongoing listening when sheet closes
    ref.read(voiceInputStateNotifierProvider.notifier).cancel();
    super.dispose();
  }

  void _onActivitySelected(ActivitySummary activity) {
    final parsedData = ref.read(voiceInputStateNotifierProvider).parsedData;
    if (parsedData != null) {
      ref.read(voicePrepopulationProvider.notifier).set(parsedData);
    }

    // Close the sheet
    Navigator.of(context).pop();

    // Navigate to log activity screen
    LogActivityRoute(
      activityId: activity.activityId,
      date: parsedData?.date?.iso,
    ).push<void>(context);
  }

  void _onRetry() {
    ref.read(voiceInputStateNotifierProvider.notifier).reset();
    ref.read(voiceInputStateNotifierProvider.notifier).startListening();
  }

  void _onOpenSettings() {
    unawaited(AppSettings.openAppSettings());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(voiceInputStateNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Content based on state
              _buildContent(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, VoiceInputState state) {
    return switch (state.status) {
      VoiceInputStatus.idle || VoiceInputStatus.requestingPermission => _buildLoadingState(context),
      VoiceInputStatus.permissionDenied => _buildPermissionDeniedState(context, state),
      VoiceInputStatus.listening => _buildListeningState(context, state),
      VoiceInputStatus.processing => _buildProcessingState(context, state),
      VoiceInputStatus.showingResults => _buildResultsState(context, state),
      VoiceInputStatus.error => _buildErrorState(context, state),
    };
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 40),
        CircularProgressIndicator(),
        SizedBox(height: 24),
        Text('Initializing...'),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPermissionDeniedState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          LucideIcons.micOff,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Microphone Access Required',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.errorMessage ?? 'Voice logging requires microphone access',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _onOpenSettings,
              child: const Text('Open Settings'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildListeningState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Animated microphone
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1 + (_pulseController.value * 0.2)),
              ),
              child: Icon(
                LucideIcons.mic,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Listening...',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (state.partialTranscript != null && state.partialTranscript!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${state.partialTranscript}"',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Text(
            'Try saying "I ran 5 miles"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 24),
        FilledButton.tonal(
          onPressed: () {
            ref.read(voiceInputStateNotifierProvider.notifier).stopListening();
          },
          child: const Text('Done'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProcessingState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          'Processing...',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (state.finalTranscript != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${state.finalTranscript}"',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultsState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);
    final activities = state.matchedActivities ?? [];

    if (activities.isEmpty) {
      return _buildNoMatchState(context, state);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.finalTranscript != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '"${state.finalTranscript}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          activities.length == 1 ? 'Found activity:' : 'Select an activity:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ActivityDisambiguationList(
          activities: activities,
          onActivitySelected: _onActivitySelected,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: _onRetry,
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }

  Widget _buildNoMatchState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          LucideIcons.searchX,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text(
          'No matching activity found',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (state.finalTranscript != null)
          Text(
            '"${state.finalTranscript}"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, VoiceInputState state) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(
          LucideIcons.circleAlert,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Something went wrong',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.errorMessage ?? 'An unexpected error occurred',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
