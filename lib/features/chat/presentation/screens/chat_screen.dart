import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:logly/app/router/routes.dart';
import 'package:logly/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:logly/features/chat/data/chat_message_repository.dart';
import 'package:logly/features/chat/domain/chat_conversation.dart';
import 'package:logly/features/chat/domain/chat_message.dart' as domain;
import 'package:logly/features/chat/domain/chat_stream_state.dart';
import 'package:logly/features/chat/presentation/providers/chat_stream_provider.dart';
import 'package:logly/features/chat/presentation/providers/chat_ui_provider.dart';
import 'package:logly/features/chat/presentation/widgets/chat_composer.dart';
import 'package:logly/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:logly/features/chat/presentation/widgets/follow_up_chips.dart';
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
  void initState() {
    super.initState();
    // Reset to empty state when screen initializes (navigating to chat)
    // Uses addPostFrameCallback to avoid modifying providers during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewChat();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String query) {
    ref.read(chatUiStateProvider.notifier).clearLastErrorQuery();
    _textController.clear();
    // Clear loaded suggestions when user sends a message
    _loadedFollowUpSuggestions = [];
    setState(() {});
    unawaited(ref.read(chatUiStateProvider.notifier).sendMessage(query));
  }

  void _handleStopStreaming() {
    ref.read(chatStreamStateProvider.notifier).cancelStream();
  }

  Future<void> _openHistory() async {
    final selectedConversation = await const ChatHistoryRoute().push<ChatConversation>(context);
    if (selectedConversation != null && mounted) {
      await _loadConversation(selectedConversation);
    }
  }

  void _startNewChat() {
    // Clear loaded suggestions and trigger rebuild
    setState(() {
      _loadedFollowUpSuggestions = [];
    });
    // Clear current messages from UI and reset stream state
    unawaited(ref.read(chatUiStateProvider.notifier).clearMessages());
  }

  Future<void> _loadConversation(ChatConversation conversation) async {
    // Clear current messages
    await ref.read(chatUiStateProvider.notifier).clearMessages();

    // Set the conversation context for follow-up chaining
    ref
        .read(chatStreamStateProvider.notifier)
        .setConversationContext(
          responseId: conversation.lastResponseId,
          conversionId: conversation.lastConversionId,
          conversationId: conversation.conversationId,
        );

    // Load messages from Supabase
    final messageRepo = ref.read(chatMessageRepositoryProvider);
    final messages = await messageRepo.getByConversation(conversation.conversationId);

    // Add messages to UI controller
    final controller = ref.read(chatUiStateProvider);
    final user = ref.watch(currentUserProvider);
    final currentUserId = user?.id ?? 'anonymous';

    for (final msg in messages) {
      final uiMessage = _domainToUiMessage(msg, currentUserId);
      await controller.insertMessage(uiMessage);
    }

    // If last message is from assistant and has follow-ups, show them
    if (messages.isNotEmpty && messages.last.role == domain.ChatMessageRole.assistant) {
      final lastMetadata = messages.last.metadata;
      if (lastMetadata?.followUpSuggestions != null && lastMetadata!.followUpSuggestions!.isNotEmpty) {
        // Manually update state with follow-up suggestions by triggering a state update
        // We need to access the notifier's internal state - but we can't directly set followUpSuggestions
        // The follow-up suggestions are part of ChatStreamState, which is separate from the messages
        // For loaded conversations, we need to store the suggestions separately
        _loadedFollowUpSuggestions = lastMetadata.followUpSuggestions!;
        if (mounted) setState(() {});
      }
    }
  }

  /// Follow-up suggestions from a loaded conversation (not from stream state).
  List<String> _loadedFollowUpSuggestions = [];

  Message _domainToUiMessage(domain.ChatMessage msg, String currentUserId) {
    final authorId = msg.role == domain.ChatMessageRole.user ? currentUserId : kLoglyAiUserId;

    if (msg.role == domain.ChatMessageRole.system) {
      return Message.system(
        id: msg.messageId,
        authorId: kSystemUserId,
        text: msg.content,
        createdAt: msg.createdAt,
      );
    }

    return Message.text(
      id: msg.messageId,
      authorId: authorId,
      text: msg.content,
      createdAt: msg.createdAt,
      metadata: msg.metadata != null
          ? {
              'followUpSuggestions': msg.metadata!.followUpSuggestions,
              'steps': msg.metadata!.steps,
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(chatUiStateProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.id ?? 'anonymous';
    final theme = Theme.of(context);

    // Listen for error transitions and restore user's question text.
    ref.listen(chatStreamStateProvider, (prev, next) {
      if (next.status == ChatConnectionStatus.error && prev?.status != ChatConnectionStatus.error) {
        // Defer to next frame to ensure _handleError has set lastErrorQuery
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final errorQuery = ref.read(chatUiStateProvider.notifier).lastErrorQuery;
          if (errorQuery != null && mounted) {
            _textController.text = errorQuery;
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: errorQuery.length),
            );
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoglyAI'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.history),
            tooltip: 'Chat History',
            onPressed: _openHistory,
          ),
          IconButton(
            icon: const Icon(LucideIcons.squarePen),
            tooltip: 'New Chat',
            onPressed: _startNewChat,
          ),
        ],
      ),
      body: Chat(
        currentUserId: userId,
        resolveUser: (id) async => User(id: id),
        chatController: controller,
        theme: ChatTheme.fromThemeData(theme),
        builders: Builders(
          composerBuilder: (_) => _buildComposer(),
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
  // Builder: composer
  // ---------------------------------------------------------------------------

  Widget _buildComposer() {
    final theme = Theme.of(context);

    // The composerBuilder in flutter_chat_ui expects a widget that will be placed
    // inside a Stack (positioned at bottom). We return a Positioned wrapping the
    // composer area.
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: ChatComposer(
          controller: _textController,
          onSendMessage: _handleSendMessage,
          onStopStreaming: _handleStopStreaming,
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

    // Determine if this AI message should show follow-up chips.
    // Chips show if: the message has follow-up suggestions AND it's the last AI message
    // (i.e., the user hasn't sent another message yet).
    final followUpSuggestions = _getFollowUpSuggestionsForMessage(message, index);

    // AI completed message -- render with step summary + GptMarkdown + optional follow-up chips
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepProgress(message.metadata, theme),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GptMarkdown(message.text, style: theme.textTheme.bodyLarge),
        ),
        if (followUpSuggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FollowUpChips(
              suggestions: followUpSuggestions,
              onTap: _handleSendMessage,
            ),
          ),
      ],
    );
  }

  /// Returns follow-up suggestions for an AI message if it should display chips.
  ///
  /// Shows chips only for the most recent AI message that has suggestions,
  /// and only when no newer user message exists after it (i.e., the conversation
  /// hasn't continued yet).
  List<String> _getFollowUpSuggestionsForMessage(TextMessage message, int index) {
    final controller = ref.read(chatUiStateProvider);
    final messages = controller.messages;

    // flutter_chat_ui displays messages in reverse chronological order (newest first).
    // Index 0 is the most recent message.
    // We want to show chips only on the LAST AI message (lowest index AI message).

    // If this is not the most recent message (index > 0), check if there are newer messages
    // from the user. If so, hide chips (conversation has continued).
    if (message != messages.last) {
      return [];
    }

    // Get suggestions from message metadata or loaded suggestions (for history)
    final metadata = message.metadata;
    if (metadata != null) {
      final suggestions = metadata['followUpSuggestions'];
      if (suggestions is List && suggestions.isNotEmpty) {
        return suggestions.cast<String>();
      }
    }

    // For loaded conversations, check if this is the last message and use loaded suggestions
    if (index == 0 && _loadedFollowUpSuggestions.isNotEmpty) {
      return _loadedFollowUpSuggestions;
    }

    return [];
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
          'Processed in ${steps.length} steps ($duration'
          's)',
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
