import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/voice_logging/presentation/widgets/voice_input_sheet.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Floating action button for voice logging.
///
/// When tapped, opens the VoiceInputSheet bottom sheet to capture
/// voice input for activity logging.
class VoiceLogFab extends ConsumerWidget {
  const VoiceLogFab({super.key});

  void _showVoiceInputSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceInputSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showVoiceInputSheet(context),
      tooltip: 'Log with voice',
      child: const Icon(LucideIcons.mic),
    );
  }
}
