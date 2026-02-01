import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:logly/features/onboarding/presentation/widgets/segmented_progress_bar.dart';

/// Top bar for onboarding shells with optional back, progress bar, and skip.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    super.key,
    required this.totalSegments,
    required this.currentSegment,
    this.showBack = true,
    this.showSkip = true,
    this.onBack,
    this.onSkip,
  });

  final int totalSegments;
  final int currentSegment;
  final bool showBack;
  final bool showSkip;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Back button
          SizedBox(
            width: 48,
            child: showBack
                ? IconButton(
                    icon: const Icon(LucideIcons.arrowLeft),
                    onPressed: onBack,
                  )
                : const SizedBox.shrink(),
          ),

          // Progress bar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SegmentedProgressBar(
                totalSegments: totalSegments,
                currentSegment: currentSegment,
              ),
            ),
          ),

          // Skip button
          SizedBox(
            width: 48,
            child: showSkip
                ? TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 48),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onSkip,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
