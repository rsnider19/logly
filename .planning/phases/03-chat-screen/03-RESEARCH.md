# Phase 3: Chat Screen - Research

**Researched:** 2026-02-02
**Domain:** Flutter Chat UI with streaming AI responses, markdown rendering, custom message layouts
**Confidence:** HIGH

## Summary

Phase 3 builds the chat screen UI layer on top of the existing Phase 2 stream client infrastructure. The core challenge is bridging the existing `ChatStreamStateNotifier` (which manages SSE stream lifecycle, typewriter buffer, and step progress) with `flutter_chat_ui` v2's `ChatController` + `Builders` system, while delivering a flat (no-bubble) ChatGPT/Claude-inspired layout.

The standard approach uses `flutter_chat_ui` v2 (already in `pubspec.yaml` at v2.11.1) with custom builders to override the default bubble-based message rendering. The `flyer_chat_text_stream_message` package (already at v2.3.0) provides the streaming text widget with `gpt_markdown` integration. The key architectural challenge is that `flutter_chat_ui` uses `provider` internally for its widget tree, while the app uses Riverpod -- these must coexist correctly through the `composerBuilder`, `textStreamMessageBuilder`, `chatMessageBuilder`, and `emptyChatListBuilder` overrides.

Step progress indicators (spinners, checkmarks, collapsed summary) are NOT part of `flutter_chat_ui`'s message model -- they must be implemented as custom widgets rendered alongside the AI message, either via the `chatMessageBuilder` wrapper or a custom message type using `Message.custom` with `customMessageBuilder`.

**Primary recommendation:** Use `flutter_chat_ui`'s `Chat` widget with heavy builder customization: custom `composerBuilder` for the floating rounded input with stop/send toggle, custom `chatMessageBuilder` for flat layout (removing bubble styling), custom `textStreamMessageBuilder` for streaming markdown, custom `emptyChatListBuilder` for the welcome screen, and a separate step progress widget composed above the streaming message content.

## Standard Stack

### Core (Already in pubspec.yaml)
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `flutter_chat_ui` | 2.11.1 | Chat UI scaffold -- animated list, message lifecycle, scroll management | Official Flyer Chat package, built for AI streaming use cases |
| `flutter_chat_core` | 2.9.0 | Message models (`TextMessage`, `TextStreamMessage`), `ChatController`, `ChatTheme`, `Builders` | Required foundation for `flutter_chat_ui` |
| `flyer_chat_text_stream_message` | 2.3.0 | Streaming text widget with `gpt_markdown` integration, fade-in animations, shimmer loading | Official companion package for AI streaming text in Flyer Chat |
| `gpt_markdown` | 1.1.5 | Markdown rendering (bold, italic, lists, headers, code blocks, tables) | User-specified; replacement for deprecated `flutter_markdown`; optimized for AI output |
| `provider` | 6.1.5+1 (transitive) | Used internally by `flutter_chat_ui` for widget-level context (`ChatTheme`, `Builders`, `UserID`) | Required by `flutter_chat_ui` -- no action needed, already resolved via pub |

### Supporting (Already in pubspec.yaml)
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `lucide_icons_flutter` | 3.1.9 | Icons for send, stop, checkmark, spinner UI elements | All chat UI icons |
| `shimmer` | 3.0.0 | Loading shimmer for step progress and initial streaming state | Streaming "Thinking..." state |
| `uuid` | 4.5.2 | Generate unique message IDs for `ChatController` | Every message insertion |
| `go_router` + `go_router_builder` | 17.0.1 / 4.1.3 | Typed navigation to chat screen route | Route definition and navigation |

### No New Dependencies Needed
All required packages are already in `pubspec.yaml`. No `pub add` commands required.

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `flutter_chat_ui` builders | Build chat list from scratch with `ListView` | Lose animated insertions, scroll management, keyboard handling. Not worth it. |
| `flyer_chat_text_stream_message` | Custom `GptMarkdown` widget directly | Lose chunk fade-in animations, loading shimmer, and stream state management. Reinventing the wheel. |
| `gpt_markdown` | `flutter_markdown` | `flutter_markdown` is being discontinued. `gpt_markdown` is the user's choice and already used by `flyer_chat_text_stream_message`. |
| `Message.custom` for step progress | Separate widget outside `Chat` | Lose scroll synchronization with messages. Steps should flow in the chat list. |

## Architecture Patterns

### Recommended Project Structure
```
lib/features/chat/
├── application/
│   ├── chat_service.dart              # [EXISTS] Business logic, stream orchestration
│   ├── chat_service.g.dart            # [EXISTS] Generated
│   └── typewriter_buffer.dart         # [EXISTS] Character-by-character drip
├── data/
│   ├── chat_repository.dart           # [EXISTS] SSE edge function client
│   ├── chat_repository.g.dart         # [EXISTS] Generated
│   └── sse_event_parser.dart          # [EXISTS] SSE stream transformer
├── domain/
│   ├── chat_event.dart                # [EXISTS] SSE event types
│   ├── chat_exception.dart            # [EXISTS] Exception hierarchy
│   ├── chat_stream_state.dart         # [EXISTS] Stream lifecycle state
│   ├── chat_message_data.dart         # [NEW] Local message model bridging ChatStreamState to UI
│   └── *.freezed.dart / *.g.dart      # [EXISTS] Generated
└── presentation/
    ├── providers/
    │   ├── chat_stream_provider.dart   # [EXISTS] Riverpod notifier for stream state
    │   ├── chat_controller_provider.dart # [NEW] Riverpod provider wrapping InMemoryChatController
    │   └── chat_ui_provider.dart       # [NEW] Bridge provider: listens to stream state, drives controller
    ├── screens/
    │   └── chat_screen.dart            # [NEW] Main screen with Chat widget + route
    └── widgets/
        ├── chat_composer.dart          # [NEW] Custom composer (floating, rounded, stop button)
        ├── chat_empty_state.dart       # [NEW] Welcome screen with suggestion chips
        ├── step_progress_widget.dart   # [NEW] Spinner/checkmark step indicators
        ├── step_summary_widget.dart    # [NEW] Collapsed "Processed in N steps" summary
        ├── user_message_widget.dart    # [NEW] Flat card for user messages
        └── ai_message_widget.dart      # [NEW] Flat (no card) AI message with steps + streaming text
```

### Pattern 1: Bridge Pattern -- Riverpod State to ChatController
**What:** A Riverpod provider that listens to `chatStreamStateProvider` and translates state changes into `ChatController` operations (insert, update, remove).
**When to use:** This is THE core pattern for Phase 3. The existing `ChatStreamStateNotifier` emits `ChatStreamState` updates, but `flutter_chat_ui`'s `Chat` widget reads from a `ChatController`. A bridge is needed.
**Why it matters:** `flutter_chat_ui` uses `provider` (the package) internally, but the app uses Riverpod. The `Chat` widget manages its own provider context. The bridge runs at the Riverpod level, inserting/updating messages in the `InMemoryChatController` which the `Chat` widget observes.

```dart
// Bridge provider pattern
// Source: Codebase architecture analysis + flutter_chat_ui v2 source code

@Riverpod(keepAlive: true)
class ChatUiStateNotifier extends _$ChatUiStateNotifier {
  late final InMemoryChatController _controller;

  @override
  InMemoryChatController build() {
    _controller = InMemoryChatController();

    // Listen to ChatStreamState changes and drive the ChatController
    ref.listen(chatStreamStateProvider, (previous, next) {
      _onStreamStateChanged(previous, next);
    });

    ref.onDispose(() => _controller.dispose());
    return _controller;
  }

  void _onStreamStateChanged(ChatStreamState? prev, ChatStreamState next) {
    // Map stream state transitions to ChatController operations:
    // - connecting -> insert TextStreamMessage placeholder
    // - streaming (steps) -> update metadata on the TextStreamMessage
    // - streaming (text) -> update StreamState for FlyerChatTextStreamMessage
    // - completed -> replace TextStreamMessage with TextMessage
    // - error -> remove AI message, emit error in chat flow
  }
}
```

### Pattern 2: Custom Builder Composition for Flat Layout
**What:** Override `chatMessageBuilder` to remove bubble alignment/animation defaults. Override individual message builders (`textMessageBuilder`, `textStreamMessageBuilder`) to render flat cards vs plain text.
**When to use:** Every message rendering in the chat.
**Key insight:** The `ChatMessage` widget applies alignment (left/right based on sender), animation, and padding. For a flat layout, we override `chatMessageBuilder` to keep animation but change alignment to always left-aligned, full-width.

```dart
// Source: flutter_chat_ui v2 builders.dart + ChatMessage source code

Chat(
  chatController: controller,
  currentUserId: userId,
  resolveUser: _resolveUser,
  theme: ChatTheme.fromThemeData(Theme.of(context)).copyWith(
    shape: BorderRadius.zero, // No bubble radius
  ),
  builders: Builders(
    chatMessageBuilder: (context, message, index, animation, child,
        {isRemoved, required isSentByMe, groupStatus}) {
      // Full-width, left-aligned -- no sender-based alignment
      return ChatMessage(
        message: message,
        index: index,
        animation: animation,
        child: child,
        isRemoved: isRemoved,
        groupStatus: groupStatus,
        // Override alignment to always left
        sentMessageAlignment: AlignmentDirectional.centerStart,
        receivedMessageAlignment: AlignmentDirectional.centerStart,
        sentMessageColumnAlignment: CrossAxisAlignment.start,
        receivedMessageColumnAlignment: CrossAxisAlignment.start,
        horizontalPadding: 16,
        verticalPadding: 16,
      );
    },
    textMessageBuilder: _buildUserOrAiTextMessage,
    textStreamMessageBuilder: _buildStreamingMessage,
    composerBuilder: (_) => const ChatComposer(),
    emptyChatListBuilder: (_) => const ChatEmptyState(),
  ),
)
```

### Pattern 3: StreamState Bridge for FlyerChatTextStreamMessage
**What:** The `FlyerChatTextStreamMessage` widget expects a `StreamState` object (from `flyer_chat_text_stream_message` package). The existing `ChatStreamState` must be mapped to this.
**When to use:** When rendering the AI's streaming response.

```dart
// Source: flyer_chat_text_stream_message v2.3.0 stream_state.dart

// Mapping from our ChatStreamState -> package's StreamState:
// ChatConnectionStatus.connecting  -> StreamStateLoading()
// ChatConnectionStatus.streaming   -> StreamStateStreaming(state.displayText)
// ChatConnectionStatus.completing  -> StreamStateStreaming(state.displayText)
// ChatConnectionStatus.completed   -> StreamStateCompleted(state.fullText)
// ChatConnectionStatus.error       -> StreamStateError(state.errorMessage)
```

### Pattern 4: Step Progress as Custom Message Metadata
**What:** Steps are rendered as part of the AI message widget, not as separate messages. The `TextStreamMessage.metadata` map stores step data, and the custom `textStreamMessageBuilder` renders steps above the streaming text.
**When to use:** During the streaming lifecycle of each AI response.
**Why:** Steps are visually part of the AI's response. Using `metadata` keeps them attached to the message without needing a separate `Message.custom` entry.

### Pattern 5: Error as Chat Message with Input Restoration
**What:** On error, insert an error message into chat (using `Message.system` or `Message.custom`), remove the user's original message, and restore the text to the input field.
**When to use:** When `ChatStreamState.status == error`.

### Anti-Patterns to Avoid
- **Mixing Provider and Riverpod for the same state:** `flutter_chat_ui` uses `provider` internally -- do NOT try to provide Riverpod-managed state through `provider`. Instead, use the bridge pattern where Riverpod drives the `ChatController`, and `flutter_chat_ui` reads from the controller.
- **Rebuilding the Chat widget on every stream state change:** The `Chat` widget should NOT be rebuilt. Instead, the `ChatController` should be updated (which triggers its internal animations).
- **Storing step progress in the Riverpod state only:** Steps must also be reflected in the `ChatController` message metadata so the custom builder can access them.
- **Using `Message.text` while still streaming:** Use `Message.textStream` during streaming, then replace with `Message.text` on completion. This triggers the correct builder.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Animated message list with insert/remove animations | Custom `AnimatedList` or `SliverAnimatedList` | `flutter_chat_ui`'s `ChatAnimatedList` | Handles scroll position preservation, keyboard avoidance, composer height offset, message grouping |
| Streaming text with fade-in chunk animations | Custom `RichText` with `AnimationController` per chunk | `FlyerChatTextStreamMessage` with `TextStreamMessageMode.instantMarkdown` or `animatedOpacity` | Manages segment tracking, animation disposal, state transitions |
| Markdown rendering for AI responses | Custom regex-based parser | `GptMarkdown` widget from `gpt_markdown` package | Handles bold, italic, lists, headers, code blocks, tables, links, LaTeX |
| Scroll-to-bottom button | Custom `ScrollController` listener | `flutter_chat_ui`'s built-in scroll-to-bottom via `scrollToBottomBuilder` | Handles visibility animation, scroll position tracking |
| Message ID generation | Custom incrementing counter | `uuid` package (v4) | Guarantees uniqueness across sessions |
| Keyboard avoidance | Custom `MediaQuery.of(context).viewInsets` logic | `flutter_chat_ui`'s built-in keyboard handling in `Composer` | Handles safe area, animated transitions |

**Key insight:** `flutter_chat_ui` v2 was designed for exactly this use case (AI chat with streaming). Using its infrastructure with custom builders is far more robust than building from scratch.

## Common Pitfalls

### Pitfall 1: ChatController Message Identity for Updates
**What goes wrong:** `ChatController.updateMessage(oldMessage, newMessage)` finds messages by ID internally, but the v2 docs emphasize that the `oldMessage` parameter should match the *current* instance in the controller, not a stale copy.
**Why it happens:** When updating a `TextStreamMessage` rapidly (streaming text deltas), holding a stale reference causes the update operation to fail silently or skip.
**How to avoid:** Always fetch the current message from `controller.messages` by ID before calling `updateMessage`. The `InMemoryChatController` does handle lookup by ID internally, but the emitted `ChatOperation.update` uses the exact instance from the list.
**Warning signs:** Messages not updating in the UI despite state changes.

### Pitfall 2: TextStreamMessage to TextMessage Replacement Timing
**What goes wrong:** The `TextStreamMessage` must be replaced with a `TextMessage` when streaming completes. If done too early (before typewriter drains), the `FlyerChatTextStreamMessage` widget disappears mid-animation. If done too late, the message stays in streaming mode.
**Why it happens:** The existing `TypewriterBuffer` drains at 1ms/char after `markDone()`. The `ChatStreamState` transitions: `completing` -> `completed`. The replacement should happen at `completed`.
**How to avoid:** Only convert `TextStreamMessage` -> `TextMessage` when `ChatStreamState.status == ChatConnectionStatus.completed` (not `completing`). During `completing`, keep updating `StreamStateStreaming` with `displayText`.
**Warning signs:** Text flickering or disappearing at end of stream.

### Pitfall 3: Provider/Riverpod Coexistence
**What goes wrong:** `flutter_chat_ui`'s `Chat` widget wraps its children in a `MultiProvider` (from the `provider` package). Riverpod's `ProviderScope` is at the app root. If you try to use `ref.watch()` inside a builder callback that's called from within the `Chat` widget's provider tree, it works fine -- Riverpod operates independently. But if you try to `context.read<SomeRiverpodProvider>()` (provider-package syntax) it will fail because Riverpod providers are not in the provider-package context.
**Why it happens:** Two separate DI systems operating in the same widget tree.
**How to avoid:** Use Riverpod (`ref.watch`/`ref.read`) in `ConsumerWidget`/`ConsumerStatefulWidget` that wrap the `Chat` widget. Pass data DOWN to builders via closures that capture Riverpod state, not via `context.read()` inside builders. The `composerBuilder` should return a `ConsumerWidget` that can access Riverpod.
**Warning signs:** `ProviderNotFoundException` errors at runtime.

### Pitfall 4: InMemoryChatController Lifecycle with Riverpod
**What goes wrong:** If the `InMemoryChatController` is created in a Riverpod provider with `keepAlive: true`, it persists across navigations. Messages from a previous chat session appear when returning to the screen.
**Why it happens:** `keepAlive: true` means the provider never disposes.
**How to avoid:** Either (a) use auto-dispose and recreate controller per screen visit, or (b) call `controller.setMessages([])` when starting a new session or on screen entry. For Phase 3 (single conversation, no persistence), auto-dispose is simpler but the `ChatStreamStateNotifier` is `keepAlive`. Consider calling `resetConversation()` + clearing the controller when navigating to the chat screen.
**Warning signs:** Stale messages appearing on screen re-entry.

### Pitfall 5: Custom Composer Must Report Height
**What goes wrong:** `flutter_chat_ui` uses a `ComposerHeightNotifier` (via `provider`) to know how much space the composer takes, so the `ChatAnimatedList` can offset its bottom padding. If using a custom `composerBuilder`, the custom composer must read the `ComposerHeightNotifier` from context and report its height.
**Why it happens:** The built-in `Composer` does this automatically via `_measure()`. Custom composers don't.
**How to avoid:** In the custom composer widget, use `WidgetsBinding.instance.addPostFrameCallback` to measure the rendered height and call `context.read<ComposerHeightNotifier>().setHeight(height)`.
**Warning signs:** Messages hidden behind the composer, or large gap between last message and composer.

### Pitfall 6: Dual State for Step Progress
**What goes wrong:** Steps need to be visible in the UI (through the custom builder) AND tracked in Riverpod state (for the collapsed summary timer calculation). If only tracked in one place, either the UI doesn't update or the summary can't calculate duration.
**Why it happens:** The bridge pattern means state flows Riverpod -> ChatController. Steps must flow through both.
**How to avoid:** Store step data in `TextStreamMessage.metadata` (for builder access) AND in the `ChatStreamState` (for business logic). The bridge provider translates between them.
**Warning signs:** Steps visible but summary shows wrong count, or steps not visible but state tracks them.

### Pitfall 7: Empty Chat List Builder Conflicts with Chat Widget Layout
**What goes wrong:** The `emptyChatListBuilder` renders when `controller.messages` is empty. But it renders inside the `Chat` widget's `Stack`, alongside the `Composer`. If the empty state widget doesn't account for composer space, it gets hidden behind it.
**Why it happens:** The `Chat` widget uses a `Stack` with the `ChatAnimatedList` and `Composer` as children.
**How to avoid:** Add bottom padding to the empty state widget equal to the composer height (or use `SafeArea` + enough margin). The welcome screen should be centered in the available space above the composer.
**Warning signs:** Welcome screen partially hidden behind the input field.

## Code Examples

### Example 1: Chat Screen Route Definition
```dart
// Source: Existing routes.dart pattern in codebase

@TypedGoRoute<ChatRoute>(path: '/chat')
class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatScreen();
  }
}
```

### Example 2: Chat Widget Setup with Custom Builders
```dart
// Source: flutter_chat_ui v2 Chat widget API + builders.dart

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(chatUiStateProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LoglyAI')),
      body: Chat(
        currentUserId: userId,
        resolveUser: (id) async => User(id: id),
        chatController: controller,
        theme: ChatTheme.fromThemeData(Theme.of(context)),
        builders: Builders(
          composerBuilder: (_) => const ChatComposer(),
          emptyChatListBuilder: (_) => const ChatEmptyState(),
          chatMessageBuilder: _buildChatMessage,
          textMessageBuilder: _buildTextMessage,
          textStreamMessageBuilder: _buildTextStreamMessage,
        ),
      ),
    );
  }
}
```

### Example 3: Inserting Messages into ChatController
```dart
// Source: InMemoryChatController API from flutter_chat_core v2.9.0

// Insert user message
await controller.insertMessage(
  Message.text(
    id: const Uuid().v4(),
    authorId: userId,
    text: query,
    createdAt: DateTime.now(),
  ),
);

// Insert AI stream placeholder
await controller.insertMessage(
  Message.textStream(
    id: aiMessageId,
    authorId: 'logly-ai',
    streamId: streamId,
    createdAt: DateTime.now(),
  ),
);

// On stream complete, replace with final text message
final streamMsg = controller.messages.firstWhere((m) => m.id == aiMessageId);
await controller.updateMessage(
  streamMsg,
  Message.text(
    id: aiMessageId,
    authorId: 'logly-ai',
    text: finalText,
    createdAt: streamMsg.createdAt,
  ),
);
```

### Example 4: StreamState Mapping for FlyerChatTextStreamMessage
```dart
// Source: flyer_chat_text_stream_message v2.3.0 StreamState classes

StreamState mapToStreamState(ChatStreamState state) {
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
```

### Example 5: Step Progress Widget
```dart
// Source: Custom implementation following context decisions

class StepProgressWidget extends StatelessWidget {
  final List<ChatCompletedStep> completedSteps;
  final String? currentStepName;
  final String? currentStepStatus;
  final bool isCollapsed;
  final Duration? totalDuration;

  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Text(
        'Processed in ${completedSteps.length} steps '
        '(${totalDuration?.inMilliseconds ?? 0 / 1000}s)',
        style: theme.textTheme.bodySmall,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final step in completedSteps)
          Row(children: [
            Icon(LucideIcons.check, size: 16),
            SizedBox(width: 8),
            Text(step.name),
          ]),
        if (currentStepName != null && currentStepStatus == 'start')
          Row(children: [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 8),
            Text(currentStepName!),
          ]),
      ],
    );
  }
}
```

### Example 6: Custom Composer with Stop Button
```dart
// Source: flutter_chat_ui Composer pattern + context decisions

class ChatComposer extends ConsumerStatefulWidget {
  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final streamState = ref.watch(chatStreamStateProvider);
    final isStreaming = streamState.status == ChatConnectionStatus.streaming ||
                        streamState.status == ChatConnectionStatus.connecting ||
                        streamState.status == ChatConnectionStatus.completing;

    return Positioned(
      left: 0, right: 0, bottom: 0,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !isStreaming,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: isStreaming
                    ? 'Waiting for response...'
                    : 'Ask about your activities...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            if (isStreaming)
              IconButton(
                icon: Icon(LucideIcons.square),
                onPressed: _handleStop,
              )
            else
              IconButton(
                icon: Icon(LucideIcons.sendHorizontal),
                onPressed: _handleSend,
              ),
          ],
        ),
      ),
    );
  }
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `flutter_markdown` for markdown rendering | `gpt_markdown` package | 2025 (flutter_markdown discontinued) | `gpt_markdown` is the standard for AI output rendering in Flutter |
| `flutter_chat_ui` v1 (monolithic, limited customization) | `flutter_chat_ui` v2 (modular, builder-based, `ChatController`) | v2.0.0 release (2024) | Complete rewrite enabling AI streaming, custom layouts, backend-agnostic |
| Manual `SliverAnimatedList` for chat | `ChatAnimatedList` from `flutter_chat_ui` | v2.0.0 | Handles scroll position, keyboard avoidance, animations automatically |
| Separate state management for chat messages | `InMemoryChatController` as single source of truth | v2.0.0 | Centralized message state with operation-based updates |

**Deprecated/outdated:**
- `flutter_markdown`: Being discontinued, replaced by `gpt_markdown`
- `flutter_chat_ui` v1: Completely replaced by v2 (different API, different architecture)
- Direct `ListView` for chat messages: Missing scroll position preservation, animation, keyboard handling

## Open Questions

1. **Stop/Cancel Stream Implementation**
   - What we know: The context decisions specify a stop button that "cancels request and keeps any partial text displayed." The existing `ChatService.sendQuestion` runs as an async `await for` loop with no cancellation mechanism.
   - What's unclear: How to cancel the SSE stream mid-flight. The repository's `sendQuestion` is an `async*` generator yielding from a byte stream. Cancellation likely requires closing the underlying HTTP response.
   - Recommendation: Add a `CancelToken` or `StreamSubscription.cancel()` mechanism to `ChatService`. The stop button should cancel the subscription, mark the typewriter as done, and transition to `completed` status with partial text. This may require modifying Phase 2 code -- the planner should include a task for adding cancellation support to the service/repository.

2. **Step Duration Tracking for Collapsed Summary**
   - What we know: The collapsed summary format is "Processed in N steps (X.Xs)". The existing `ChatStreamState` tracks `completedSteps` and `currentStepName` but not timestamps.
   - What's unclear: Where to record the start time of the first step and end time of the last step.
   - Recommendation: Track a `stepStartTime` (set when first step event arrives) in the bridge/UI provider. Calculate duration as `completed_time - stepStartTime`. This is UI-layer concern, not service-layer.

3. **TextStreamMessage Mode Selection**
   - What we know: `FlyerChatTextStreamMessage` has two modes: `animatedOpacity` (fade-in per chunk using `RichText`) and `instantMarkdown` (full `GptMarkdown` re-render per update). The context decisions say "typewriter effect using existing TypewriterBuffer."
   - What's unclear: Which mode works best with the existing TypewriterBuffer. `animatedOpacity` mode does its own chunk-based fade animation, which may conflict with the TypewriterBuffer's character-by-character drip. `instantMarkdown` mode re-renders the full accumulated text with GptMarkdown on each update -- this pairs naturally with TypewriterBuffer since each emission is the full text so far.
   - Recommendation: Use `TextStreamMessageMode.instantMarkdown` to match the TypewriterBuffer pattern (each emission is full accumulated text). The typewriter drip IS the animation; adding chunk fade-in on top would be redundant and potentially janky.

4. **User Message Style: Card vs No Card via flutter_chat_ui**
   - What we know: User messages should be in a flat card (0 elevation), AI messages without a card. Both use `flutter_chat_ui` message types.
   - What's unclear: How exactly to style messages differently by sender in the custom builders.
   - Recommendation: The `textMessageBuilder` receives `isSentByMe` parameter. Use this to conditionally wrap user messages in a `Card(elevation: 0)` and leave AI messages unwrapped. The `chatMessageBuilder` already provides sender-aware layout.

## Sources

### Primary (HIGH confidence)
- `flutter_chat_core` v2.9.0 source code -- `/Users/robsnider/.pub-cache/hosted/pub.dev/flutter_chat_core-2.9.0/` -- Message models, ChatController, Builders, ChatTheme
- `flutter_chat_ui` v2.11.1 source code -- `/Users/robsnider/.pub-cache/hosted/pub.dev/flutter_chat_ui-2.11.1/` -- Chat widget, Composer, ChatMessage, ChatAnimatedList
- `flyer_chat_text_stream_message` v2.3.0 source code -- `/Users/robsnider/.pub-cache/hosted/pub.dev/flyer_chat_text_stream_message-2.3.0/` -- FlyerChatTextStreamMessage, StreamState, TextStreamMessageMode
- `gpt_markdown` v1.1.5 source code -- `/Users/robsnider/.pub-cache/hosted/pub.dev/gpt_markdown-1.1.5/` -- GptMarkdown widget API
- Existing codebase Phase 2 files -- `lib/features/chat/` -- ChatStreamState, ChatService, TypewriterBuffer, ChatRepository, ChatStreamStateNotifier

### Secondary (MEDIUM confidence)
- Flyer Chat official documentation -- https://flyer.chat/docs/flutter/introduction -- Architecture overview, customization guide
- Flyer Chat Gemini example -- https://github.com/flyerhq/flutter_chat_ui/tree/main/examples/flyer_chat/lib -- `gemini.dart`, `gemini_stream_manager.dart` -- AI streaming integration pattern
- `gpt_markdown` pub.dev -- https://pub.dev/packages/gpt_markdown -- Version info, feature list, theming support

### Tertiary (LOW confidence)
- `flutter_markdown` discontinuation discussion -- https://github.com/flutter/flutter/issues/162966 -- Confirms `gpt_markdown` as replacement direction

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- All packages already in pubspec.yaml, source code verified locally in pub cache
- Architecture: HIGH -- Based on direct reading of flutter_chat_ui v2 source code + existing codebase patterns
- Pitfalls: HIGH -- Derived from source code analysis of ChatController, InMemoryChatController, provider/Riverpod interaction patterns
- Code examples: MEDIUM -- Based on API analysis but untested; specific builder compositions may need adjustment during implementation

**Research date:** 2026-02-02
**Valid until:** 2026-03-02 (30 days -- packages are stable, no major releases expected)
