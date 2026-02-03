import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:logly/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:logly/features/chat/presentation/providers/chat_ui_provider.dart';
import 'package:logly/features/chat/presentation/widgets/chat_composer.dart';
import 'package:logly/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Main chat screen that assembles the `flutter_chat_ui` [Chat] widget
/// with custom builders for the composer, empty state, message layout,
/// streaming text, and error messages.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String query) {
    ref.read(chatUiStateProvider.notifier).clearLastErrorQuery();
    _textController.clear();
    unawaited(ref.read(chatUiStateProvider.notifier).sendMessage(query));
  }

  void _handleStopStreaming() {
    ref.read(chatStreamStateProvider.notifier).cancelStream();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(chatUiStateProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.id ?? 'anonymous';
    final theme = Theme.of(context);

    // Listen for error transitions and restore user's question text.
    ref.listen(chatStreamStateProvider, (prev, next) {
      if (next.status == ChatConnectionStatus.error &&
          prev?.status != ChatConnectionStatus.error) {
        final errorQuery = ref.read(chatUiStateProvider.notifier).lastErrorQuery;
        if (errorQuery != null) {
          _textController.text = errorQuery;
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: errorQuery.length),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoglyAI'),
        centerTitle: false,
      ),
      body: Chat(
        currentUserId: userId,
        resolveUser: (id) async => User(id: id),
        chatController: controller,
        theme: ChatTheme.fromThemeData(theme),
        builders: Builders(
          composerBuilder: (_) => ChatComposer(
            controller: _textController,
            onSendMessage: _handleSendMessage,
            onStopStreaming: _handleStopStreaming,
          ),
          emptyChatListBuilder: (_) => ChatEmptyState(
            onSuggestionTap: _handleSendMessage,
          ),
          chatMessageBuilder: _buildChatMessage,
          textMessageBuilder: _buildTextMessage,
          textStreamMessageBuilder: _buildTextStreamMessage,
          systemMessageBuilder: _buildSystemMessage,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Builder: chat message wrapper (flat layout, no bubbles)
  // ---------------------------------------------------------------------------

  Widget _buildChatMessage(
    BuildContext context,
    Message message,
    int index,
    Animation<double> animation,
    Widget child, {
    required bool isSentByMe,
    bool? isRemoved,
    MessageGroupStatus? groupStatus,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: isSentByMe
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.85,
                  ),
                  child: child,
                )
              : child,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Builder: text message (user = card, AI = GptMarkdown)
  // ---------------------------------------------------------------------------

  Widget _buildTextMessage(
    BuildContext context,
    TextMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final theme = Theme.of(context);

    if (isSentByMe) {
      return Card(
        elevation: 0,
        color: theme.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(message.text, style: theme.textTheme.bodyMedium),
        ),
      );
    }

    // AI completed message -- render with step summary + GptMarkdown
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepProgress(message.metadata, theme),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GptMarkdown(message.text, style: theme.textTheme.bodyLarge),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Builder: streaming text message (step progress + FlyerChatTextStreamMessage)
  // ---------------------------------------------------------------------------

  Widget _buildTextStreamMessage(
    BuildContext context,
    TextStreamMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final streamState = ref.watch(chatStreamStateProvider);
    final theme = Theme.of(context);
    final packageStreamState = _mapStreamState(streamState);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepProgress(message.metadata, theme),
        FlyerChatTextStreamMessage(
          message: message,
          index: index,
          streamState: packageStreamState,
          mode: TextStreamMessageMode.instantMarkdown,
          padding: const EdgeInsets.symmetric(vertical: 4),
          borderRadius: BorderRadius.zero,
          receivedBackgroundColor: Colors.transparent,
          receivedTextStyle: theme.textTheme.bodyLarge,
          showTime: false,
          showStatus: false,
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Builder: system message (error container)
  // ---------------------------------------------------------------------------

  Widget _buildSystemMessage(
    BuildContext context,
    SystemMessage message,
    int index, {
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, size: 18, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Maps [ChatStreamState] to the package [StreamState] expected by
  /// [FlyerChatTextStreamMessage].
  StreamState _mapStreamState(ChatStreamState state) {
    return switch (state.status) {
      ChatConnectionStatus.idle => const StreamStateLoading(),
      ChatConnectionStatus.connecting => const StreamStateLoading(),
      ChatConnectionStatus.streaming => StreamStateStreaming(state.displayText),
      ChatConnectionStatus.completing => StreamStateStreaming(state.displayText),
      ChatConnectionStatus.completed => StreamStateCompleted(state.fullText),
      ChatConnectionStatus.error => StreamStateError(
          state.errorMessage ?? 'Something went wrong',
          accumulatedText: state.displayText.isNotEmpty ? state.displayText : null,
        ),
    };
  }

  /// Builds inline step progress from [TextStreamMessage.metadata].
  ///
  /// Shows completed steps with checkmarks, active step with spinner,
  /// and collapses to a summary line when steps are finished.
  Widget _buildStepProgress(Map<String, dynamic>? metadata, ThemeData theme) {
    if (metadata == null) return const SizedBox.shrink();

    final steps = (metadata['steps'] as List<dynamic>?)?.cast<String>() ?? [];
    final currentStepName = metadata['currentStepName'] as String?;
    final currentStepStatus = metadata['currentStepStatus'] as String?;
    final stepsCollapsed = metadata['stepsCollapsed'] as bool? ?? false;
    final stepDurationMs = metadata['stepDurationMs'] as int?;

    if (steps.isEmpty && currentStepName == null) return const SizedBox.shrink();

    if (stepsCollapsed) {
      final duration = stepDurationMs != null ? (stepDurationMs / 1000).toStringAsFixed(1) : '?';
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          'Processed in ${steps.length} steps ($duration' 's)',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final step in steps)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(LucideIcons.check, size: 14, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(step, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          if (currentStepName != null && currentStepStatus == 'start')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(currentStepName, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
