# Phase 4: Conversation & Discovery - Research

**Researched:** 2026-02-03
**Domain:** Chat history persistence (Supabase + Drift), multi-turn context, follow-up suggestions, starter questions
**Confidence:** HIGH

## Summary

Phase 4 adds four capabilities to the existing chat implementation: (1) multi-turn conversations with context retention, (2) chat history persistence in Supabase with local Drift caching, (3) suggested starter questions on empty chat, and (4) contextual follow-up suggestions after each AI response. The foundation is already solid: the edge function's `previous_response_id` / `previous_conversion_id` mechanism enables multi-turn context (Phase 1), the Flutter client already tracks these IDs in `ChatStreamStateNotifier` (Phase 2), and the empty state UI with suggestion chips exists but uses hardcoded questions (Phase 3).

The primary technical work involves: (1) creating Supabase tables (`chat_conversations`, `chat_messages`) with RLS policies to persist chat history, (2) extending the edge function to return follow-up suggestions in a new SSE event, (3) creating Drift tables to cache conversations locally for offline viewing, (4) fetching starter questions from the existing `ai_insight_suggested_prompt` table instead of hardcoded values, and (5) updating the Flutter UI to display follow-up chips after each response.

**Primary recommendation:** Persist conversations in Supabase (not just locally) to enable cross-device sync and future features (conversation list, search). Use Drift for local caching with a "cache-first, sync-to-server" pattern. Generate follow-up suggestions via structured output in the existing response generation call (no separate API call needed). Reuse the existing `ai_insight_suggested_prompt` table for starter questions.

## Standard Stack

### Core (Already Available)

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `supabase_flutter` | 2.12.0 | Supabase client for conversations/messages tables | Already in project; auto-auth, RLS enforcement |
| `drift` | 2.22.2 | Local SQLite for conversation caching | Already in project with `AppDatabase`; type-safe queries |
| `freezed` / `freezed_annotation` | 3.0.6 / 3.1.0 | Domain models for conversations, messages | Already in project; immutable, serializable |
| `riverpod` / `riverpod_annotation` | any / 4.0.1 | State management for conversation list, history loading | Already in project |
| `flutter_chat_core` | 2.9.0 | Message models used by `flutter_chat_ui` | Already in project; integrates with controller |
| OpenAI SDK (Deno) | 4.103.0 | Structured output for follow-up suggestions | Already used in edge function |

### Supporting (Already Available)

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `uuid` | 4.5.2 | Generate conversation/message IDs | Every new conversation/message |
| `json_annotation` | 4.9.0 | JSON serialization for Supabase data | Domain model serialization |

### No New Dependencies Needed

All required packages are already in `pubspec.yaml`. No additions required.

## Architecture Patterns

### Recommended Project Structure

```
lib/features/chat/
├── domain/
│   ├── chat_event.dart                # [EXISTS] Add ChatFollowUpEvent
│   ├── chat_conversation.dart         # [NEW] Conversation domain model
│   ├── chat_message.dart              # [NEW] Persisted message domain model
│   ├── chat_stream_state.dart         # [EXISTS] Add followUpSuggestions field
│   └── chat_exception.dart            # [EXISTS]
├── data/
│   ├── chat_repository.dart           # [EXISTS]
│   ├── chat_conversation_repository.dart   # [NEW] Supabase CRUD for conversations
│   ├── chat_message_repository.dart        # [NEW] Supabase CRUD for messages
│   ├── chat_suggested_prompt_repository.dart # [NEW] Fetch starter questions
│   └── sse_event_parser.dart          # [EXISTS]
├── application/
│   ├── chat_service.dart              # [EXISTS] Handle follow-up event
│   ├── chat_persistence_service.dart  # [NEW] Orchestrate save/load with sync
│   └── typewriter_buffer.dart         # [EXISTS]
└── presentation/
    ├── providers/
    │   ├── chat_stream_provider.dart         # [EXISTS] Add persistence trigger
    │   ├── chat_ui_provider.dart             # [EXISTS] Add follow-up chips to metadata
    │   ├── chat_conversation_provider.dart   # [NEW] Current conversation state
    │   └── chat_starter_prompts_provider.dart # [NEW] Fetch starter questions
    ├── screens/
    │   └── chat_screen.dart            # [EXISTS] Wire up follow-up chips
    └── widgets/
        ├── chat_empty_state.dart       # [EXISTS] Fetch dynamic prompts
        ├── chat_composer.dart          # [EXISTS]
        └── follow_up_chips.dart        # [NEW] Tappable follow-up suggestions

lib/app/database/
├── drift_database.dart         # [EXISTS] Add chat tables
└── tables/
    ├── cached_data.dart        # [EXISTS]
    ├── chat_conversations.dart # [NEW] Drift table
    └── chat_messages.dart      # [NEW] Drift table

supabase/
├── migrations/
│   └── 20260203XXXXXX_chat_history.sql  # [NEW] Conversations + messages tables
└── functions/chat/
    ├── pipeline.ts             # [EXISTS] Add follow-up event emission
    ├── responseGenerator.ts    # [EXISTS] Return follow-up suggestions
    ├── prompts.ts              # [EXISTS] Add follow-up prompt section
    └── streamHandler.ts        # [EXISTS] Add sendFollowUp method
```

### Pattern 1: Chat History Schema (Supabase)

**What:** Two tables: `chat_conversations` (conversation metadata) and `chat_messages` (individual messages within conversations). Conversations track the latest response/conversion IDs for follow-up chaining.

**When to use:** All persistent storage of chat history.

**Example schema:**
```sql
-- Conversations table
CREATE TABLE public.chat_conversations (
  conversation_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title text, -- Optional: AI-generated or first user question
  last_response_id text, -- OpenAI response ID for follow-up chaining
  last_conversion_id text, -- SQL agent conversion ID for context
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Messages table
CREATE TABLE public.chat_messages (
  message_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES public.chat_conversations(conversation_id) ON DELETE CASCADE,
  role text NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
  content text NOT NULL,
  metadata jsonb, -- Step info, follow-up suggestions, etc.
  created_at timestamptz NOT NULL DEFAULT now()
);

-- RLS: Users can only access their own conversations
ALTER TABLE public.chat_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage own conversations"
  ON public.chat_conversations FOR ALL
  USING (user_id = auth.uid());

CREATE POLICY "Users can manage own messages"
  ON public.chat_messages FOR ALL
  USING (
    conversation_id IN (
      SELECT conversation_id FROM public.chat_conversations
      WHERE user_id = auth.uid()
    )
  );

-- Indexes
CREATE INDEX idx_chat_conversations_user ON public.chat_conversations(user_id, updated_at DESC);
CREATE INDEX idx_chat_messages_conversation ON public.chat_messages(conversation_id, created_at);
```

### Pattern 2: Local Cache Schema (Drift)

**What:** Mirror Supabase tables locally for offline viewing and fast loads. Use cache-first pattern with background sync.

**Example Drift table:**
```dart
// lib/app/database/tables/chat_conversations.dart

import 'package:drift/drift.dart';

/// Local cache of chat conversations.
class ChatConversations extends Table {
  TextColumn get conversationId => text()();
  TextColumn get userId => text()();
  TextColumn get title => text().nullable()();
  TextColumn get lastResponseId => text().nullable()();
  TextColumn get lastConversionId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Server sync status: 'synced', 'pending_upload', 'dirty'
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {conversationId};
}
```

```dart
// lib/app/database/tables/chat_messages.dart

import 'package:drift/drift.dart';

/// Local cache of chat messages.
class ChatMessages extends Table {
  TextColumn get messageId => text()();
  TextColumn get conversationId => text()();
  TextColumn get role => text()(); // 'user', 'assistant', 'system'
  TextColumn get content => text()();
  TextColumn get metadata => text().nullable()(); // JSON string
  DateTimeColumn get createdAt => dateTime()();

  TextColumn get syncStatus => text().withDefault(const Constant('synced'))();

  @override
  Set<Column> get primaryKey => {messageId};
}
```

### Pattern 3: Follow-Up Suggestions via Structured Output

**What:** The response generator includes follow-up suggestions in its structured output. No separate API call needed -- suggestions are generated alongside the response text.

**When to use:** Every AI response.

**Edge function modification:**
```typescript
// In responseGenerator.ts

const FOLLOW_UP_SCHEMA = {
  type: "object",
  properties: {
    followUpQuestions: {
      type: "array",
      items: { type: "string" },
      minItems: 2,
      maxItems: 3,
    },
  },
  required: ["followUpQuestions"],
  additionalProperties: false,
};

// After streaming the response text, make a quick non-streaming call
// to generate follow-up suggestions based on the conversation context.
const followUpResponse = await openai.responses.create({
  model: RESPONSE_MODEL,
  instructions: FOLLOW_UP_INSTRUCTIONS,
  input: `Based on this conversation about the user's Logly data, suggest 2-3 brief follow-up questions (under 40 chars each) they might want to ask next.

User asked: "${query}"
AI answered: "${fullResponse.substring(0, 500)}..."`,
  previous_response_id: responseId,
  text: {
    format: {
      type: "json_schema",
      name: "follow_up_suggestions",
      schema: FOLLOW_UP_SCHEMA,
      strict: true,
    },
  },
  temperature: 0.8,
  max_output_tokens: 150,
  store: false, // Don't store this in conversation chain
});

// Parse and emit as SSE event
const suggestions = JSON.parse(followUpResponse.output_text);
onFollowUp(suggestions.followUpQuestions);
```

**Alternative approach (recommended for v1):** Generate follow-ups in the response prompt itself:

```typescript
// In prompts.ts, add to RESPONSE_INSTRUCTIONS:

FOLLOW-UP SUGGESTIONS:
- At the END of your response, add a JSON block with 2-3 follow-up question suggestions
- Format: <!-- FOLLOW_UPS: ["Question 1?", "Question 2?"] -->
- Keep questions brief (under 40 characters)
- Make them contextually relevant to what was just discussed
- Example: <!-- FOLLOW_UPS: ["How about last month?", "Any patterns in timing?", "What's my streak?"] -->
```

This approach keeps the single streaming call and parses the suggestions from the response text.

### Pattern 4: SSE Event for Follow-Up Suggestions

**What:** New SSE event type `follow_up` containing an array of suggested questions.

**Example:**
```typescript
// In streamHandler.ts

interface ProgressStream {
  // ... existing methods
  sendFollowUp(suggestions: string[]): void;
}

// Event format:
{ "type": "follow_up", "suggestions": ["How about last week?", "Any patterns?", "What's my best day?"] }
```

**Flutter domain model addition:**
```dart
// In chat_event.dart, add:

@FreezedUnionValue('follow_up')
const factory ChatEvent.followUp({
  required List<String> suggestions,
}) = ChatFollowUpEvent;
```

### Pattern 5: Starter Questions from Supabase

**What:** Fetch starter questions from the existing `ai_insight_suggested_prompt` table instead of hardcoded values.

**When to use:** When displaying the empty chat state.

```dart
// chat_suggested_prompt_repository.dart

class ChatSuggestedPromptRepository {
  ChatSuggestedPromptRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<String>> getActivePrompts() async {
    final response = await _supabase
        .from('ai_insight_suggested_prompt')
        .select('prompt_text')
        .eq('is_active', true)
        .order('display_order');

    return (response as List)
        .map((row) => row['prompt_text'] as String)
        .toList();
  }
}
```

### Pattern 6: Conversation Load on App Start

**What:** When the user opens the chat screen, load the most recent conversation (if any) from local Drift cache, then sync with Supabase in background.

**Flow:**
1. `ChatConversationProvider.build()` checks Drift for most recent conversation
2. If found: load messages from Drift, render immediately
3. Background: sync with Supabase, update Drift, notify UI if changes
4. If not found: show empty state with starter questions

### Anti-Patterns to Avoid

- **Persisting to Supabase on every message:** Batch writes. Save after AI response completes, not after each user message or text delta.
- **Storing full OpenAI response objects:** Only store what's needed (text, role, timestamps). OpenAI's `previous_response_id` handles context.
- **Generating follow-ups in a separate API call:** Embed in the response prompt or generate immediately after response (same session). Separate call adds latency.
- **Blocking UI on persistence:** Save async. Show optimistic UI. Handle sync failures gracefully.
- **Over-engineering conversation management for v1:** This phase is about basic persistence and follow-ups. Conversation list/search is v2.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| UUID generation | Manual timestamp/random concatenation | `uuid` package | Guaranteed uniqueness, proper format |
| JSON serialization | Manual `Map<String, dynamic>` construction | `freezed` + `json_serializable` | Type safety, no runtime errors |
| Local SQLite | Raw `sqflite` calls | `drift` | Type-safe queries, migrations, codegen |
| Follow-up prompt formatting | Complex regex extraction | Structured output or delimiter-based parsing | More reliable, handles edge cases |

**Key insight:** The infrastructure for persistence exists (Drift for local, Supabase for server). The work is wiring them together with sync logic, not building storage from scratch.

## Common Pitfalls

### Pitfall 1: Race Condition on Conversation Save

**What goes wrong:** User sends second message before first AI response saves, creating duplicate conversations or message ordering issues.
**Why it happens:** Async save operations complete out of order.
**How to avoid:** Create conversation ID immediately on first message send (optimistic). Use the same ID for subsequent messages. Save happens async but ID is stable.
**Warning signs:** Duplicate messages appearing. Messages in wrong conversation.

### Pitfall 2: Response/Conversion ID Not Persisted

**What goes wrong:** User closes app mid-conversation, reopens, but follow-up chaining breaks because IDs weren't saved.
**Why it happens:** IDs arrive late in the stream (after text). If app closes before stream completes, IDs may not be captured.
**How to avoid:** Update conversation record with IDs as soon as they arrive (not just on stream completion). Use Drift's `insertOnConflictUpdate` for idempotency.
**Warning signs:** Follow-up questions after app restart lose context.

### Pitfall 3: Empty Follow-Up Suggestions

**What goes wrong:** AI returns zero suggestions or malformed JSON.
**Why it happens:** Model doesn't follow instructions perfectly. Structured output schema might reject valid edge cases.
**How to avoid:** Always have fallback suggestions ("Tell me more", "How does that compare to last week?"). Parse with error handling. Log malformed responses.
**Warning signs:** No follow-up chips appearing after successful responses.

### Pitfall 4: Drift Schema Migration on Update

**What goes wrong:** App crashes on startup after adding new Drift tables.
**Why it happens:** Schema version not incremented. Migration strategy missing.
**How to avoid:** Increment `schemaVersion` in `drift_database.dart`. Add `onUpgrade` handler that creates new tables. Test upgrade path.
**Warning signs:** `SqliteException: no such table: chat_conversations`.

### Pitfall 5: Starter Questions Network Fetch Delay

**What goes wrong:** Empty state shows loading spinner instead of suggestions, harming first impression.
**Why it happens:** Waiting for Supabase fetch before showing any content.
**How to avoid:** Cache starter questions locally (Drift or SharedPreferences). Show cached immediately, refresh in background. Hardcode 3 fallback suggestions.
**Warning signs:** Visible loading state on empty chat.

### Pitfall 6: Memory Bloat with Large Conversation History

**What goes wrong:** Loading a conversation with hundreds of messages causes jank or OOM.
**Why it happens:** Loading all messages at once into `InMemoryChatController`.
**How to avoid:** Paginate message loading. Load last 50 messages initially. Implement scroll-up loading for history. Use Drift's `limit()` and `offset()`.
**Warning signs:** Chat screen slow to open. Memory warnings.

## Code Examples

### Example 1: Conversation Domain Model (Freezed)

```dart
// lib/features/chat/domain/chat_conversation.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_conversation.freezed.dart';
part 'chat_conversation.g.dart';

@freezed
abstract class ChatConversation with _$ChatConversation {
  const factory ChatConversation({
    required String conversationId,
    required String userId,
    String? title,
    String? lastResponseId,
    String? lastConversionId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatConversation;

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationFromJson(json);
}
```

### Example 2: Persisting Messages After Response

```dart
// In chat_persistence_service.dart

Future<void> saveCompletedResponse({
  required String conversationId,
  required String userMessage,
  required String aiResponse,
  required String? responseId,
  required String? conversionId,
  required List<String>? followUpSuggestions,
}) async {
  // Save user message
  await _messageRepository.insert(ChatMessage(
    messageId: const Uuid().v4(),
    conversationId: conversationId,
    role: 'user',
    content: userMessage,
    createdAt: DateTime.now(),
  ));

  // Save AI response with follow-ups in metadata
  await _messageRepository.insert(ChatMessage(
    messageId: const Uuid().v4(),
    conversationId: conversationId,
    role: 'assistant',
    content: aiResponse,
    metadata: followUpSuggestions != null
        ? {'followUpSuggestions': followUpSuggestions}
        : null,
    createdAt: DateTime.now(),
  ));

  // Update conversation with latest IDs
  await _conversationRepository.update(
    conversationId,
    lastResponseId: responseId,
    lastConversionId: conversionId,
    updatedAt: DateTime.now(),
  );
}
```

### Example 3: Follow-Up Chips Widget

```dart
// lib/features/chat/presentation/widgets/follow_up_chips.dart

class FollowUpChips extends StatelessWidget {
  const FollowUpChips({
    required this.suggestions,
    required this.onTap,
    super.key,
  });

  final List<String> suggestions;
  final void Function(String question) onTap;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((suggestion) {
          return ActionChip(
            label: Text(suggestion, style: const TextStyle(fontSize: 13)),
            onPressed: () => onTap(suggestion),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            side: BorderSide.none,
          );
        }).toList(),
      ),
    );
  }
}
```

### Example 4: Loading Conversation on Screen Open

```dart
// In chat_screen.dart initState or provider build

Future<void> _loadOrCreateConversation() async {
  final persistence = ref.read(chatPersistenceServiceProvider);

  // Try loading most recent conversation
  final conversation = await persistence.getMostRecentConversation();

  if (conversation != null) {
    // Load messages into chat controller
    final messages = await persistence.getMessages(
      conversation.conversationId,
      limit: 50,
    );
    await _controller.setMessages(
      messages.map(_domainMessageToUiMessage).toList(),
    );

    // Set follow-up context IDs
    ref.read(chatStreamStateProvider.notifier).setConversationContext(
      responseId: conversation.lastResponseId,
      conversionId: conversation.lastConversionId,
    );
  }
  // Else: empty state with starter questions
}
```

### Example 5: Structured Output for Follow-Ups (Edge Function)

```typescript
// prompts.ts addition

export const FOLLOW_UP_INSTRUCTIONS = `
Generate 2-3 brief follow-up questions the user might want to ask based on the conversation.

Rules:
- Keep each question under 40 characters
- Make them contextually relevant
- Vary the question types (comparison, detail, trend)
- Return valid JSON: { "followUpQuestions": ["...", "..."] }

Example good follow-ups for "You ran 15 miles this week":
- "How does that compare to last week?"
- "What was my longest run?"
- "Any patterns in my running?"
`;
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Storing full conversation in client state | Using OpenAI's `previous_response_id` for context | March 2025 (Responses API) | No need to store/send full conversation text |
| Hardcoded starter questions | Database-driven prompts (already exists in `ai_insight_suggested_prompt`) | Already in codebase | Can A/B test prompts without app release |
| No local caching | Drift for offline-first chat | This phase | Better UX on slow networks, offline viewing |
| Separate API call for follow-ups | Inline in response or structured output | Best practice 2025+ | Lower latency, simpler architecture |

**Already established in codebase:**
- `ai_insight_suggested_prompt` table exists -- reuse for starter questions
- `ChatStreamStateNotifier` already tracks `lastResponseId` and `lastConversionId` -- extend to persist
- Drift `AppDatabase` exists -- add new tables

## Open Questions

1. **Conversation title generation**
   - What we know: Could use first user message or AI-generated summary
   - What's unclear: Whether to invest in title generation for v1 (no conversation list yet)
   - Recommendation: Use first user message as title for v1. Simple, no extra API call. Generate better titles in v2 when conversation list is built.

2. **Offline message queueing**
   - What we know: Drift can store pending messages. Supabase sync happens when online.
   - What's unclear: How to handle the SSE streaming requirement when offline. The chat requires server connection.
   - Recommendation: For v1, chat requires network. Local Drift stores completed conversations for offline VIEWING only. Sending messages offline is out of scope.

3. **Follow-up suggestion extraction from streaming response**
   - What we know: Can embed markers (like `<!-- FOLLOW_UPS: [...] -->`) in the response prompt. Can also use a post-response structured output call.
   - What's unclear: Which approach provides better suggestions without impacting response latency.
   - Recommendation: Start with the marker approach (embed in response text, parse client-side). If quality is poor, upgrade to separate structured output call in Phase 5.

4. **Conversation retention policy**
   - What we know: Storing all conversations indefinitely will grow the database.
   - What's unclear: Whether to implement retention limits (e.g., keep last 30 days).
   - Recommendation: Defer to v2. Let conversations accumulate. Add cleanup when needed.

## Sources

### Primary (HIGH confidence)
- Existing codebase: `lib/features/chat/` -- Complete Phase 2-3 implementation showing `ChatStreamState`, `InMemoryChatController`, event flow
- Existing codebase: `supabase/functions/chat/` -- Pipeline structure, SSE events, response generation
- Existing codebase: `lib/app/database/drift_database.dart` -- Drift setup, table pattern, migration strategy
- Existing codebase: `supabase/migrations/20251224103300_ai_insight_suggested_prompts.sql` -- Starter questions table exists
- [Drift documentation](https://drift.simonbinder.eu/docs/getting-started/) -- Table definition, CRUD patterns, migrations
- [OpenAI Structured Outputs](https://platform.openai.com/docs/guides/structured-outputs) -- json_schema format for follow-ups
- [Supabase RLS Docs](https://supabase.com/docs/guides/auth/row-level-security) -- Policy patterns for user-scoped tables

### Secondary (MEDIUM confidence)
- [Flutter Chat Offline Support (Stream)](https://getstream.io/chat/docs/sdk/flutter/guides/adding_local_data_persistence/) -- Drift caching patterns for chat
- [Offline-First Apps with Drift](https://vibe-studio.ai/insights/offline-first-apps-caching-strategies-with-hive-and-drift-in-flutter) -- Sync strategies, cache-first patterns
- [VoltAgent Supabase Persistence](https://github.com/VoltAgent/voltagent/issues/8) -- Agent conversation history schema design

### Tertiary (LOW confidence)
- [OpenAI Community: Structured Outputs](https://community.openai.com/t/how-to-effectively-prompt-for-structured-output/1355135) -- Community patterns for JSON extraction

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- All packages already in project, no new dependencies
- Architecture (Supabase schema): HIGH -- Standard relational design with RLS, follows existing project patterns
- Architecture (Drift caching): HIGH -- Existing Drift setup in project, well-documented patterns
- Follow-up suggestions: MEDIUM -- Two viable approaches (inline vs separate call), needs experimentation
- Starter questions: HIGH -- Existing table, simple fetch

**Research date:** 2026-02-03
**Valid until:** 2026-03-05 (30 days -- stable domain, infrastructure already in place)
