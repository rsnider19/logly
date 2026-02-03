import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:logly/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart' as provider;

/// Custom composer for the chat screen with floating rounded input
/// and send/stop button toggle.
///
/// Reports its height to [ComposerHeightNotifier] so the
/// `flutter_chat_ui` Chat widget can reserve correct padding
/// for the message list.
///
/// The [TextEditingController] is owned by the parent (ChatScreen)
/// so it persists across rebuilds and supports error text restoration.
class ChatComposer extends ConsumerStatefulWidget {
  const ChatComposer({
    required this.controller,
    required this.onSendMessage,
    required this.onStopStreaming,
    super.key,
  });

  /// External text editing controller owned by the parent widget.
  final TextEditingController controller;

  /// Callback when the user submits a message.
  final void Function(String query) onSendMessage;

  /// Callback to stop the current streaming response.
  final VoidCallback onStopStreaming;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final GlobalKey _composerKey = GlobalKey();
  bool _hasText = false;

  TextEditingController get _textController => widget.controller;

  @override
  void initState() {
    super.initState();
    _hasText = _textController.text.trim().isNotEmpty;
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    widget.onSendMessage(text);
    _textController.clear();
    setState(() => _hasText = false);
  }

  void _measureAndReportHeight() {
    final renderBox = _composerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      final height = renderBox.size.height;
      final bottomSafeArea = MediaQuery.of(context).padding.bottom;
      provider.Provider.of<ComposerHeightNotifier>(context, listen: false).setHeight(height - bottomSafeArea);
    }
  }

  @override
  Widget build(BuildContext context) {
    final streamState = ref.watch(chatStreamStateProvider);
    final isStreaming = streamState.status == ChatConnectionStatus.streaming ||
        streamState.status == ChatConnectionStatus.connecting ||
        streamState.status == ChatConnectionStatus.completing;

    final theme = Theme.of(context);

    // Report height after each build so the chat list reserves
    // the correct bottom padding (matches flutter_chat_ui Composer pattern).
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndReportHeight());

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        key: _composerKey,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  enabled: !isStreaming,
                  maxLines: 5,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: isStreaming ? 'Waiting for response...' : 'Ask about your activities...',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (isStreaming)
                IconButton.filled(
                  icon: const Icon(LucideIcons.square, size: 18),
                  onPressed: widget.onStopStreaming,
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                )
              else
                IconButton.filled(
                  icon: const Icon(LucideIcons.sendHorizontal, size: 18),
                  onPressed: _hasText ? _handleSend : null,
                  style: IconButton.styleFrom(
                    backgroundColor:
                        _hasText ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                    foregroundColor:
                        _hasText ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
