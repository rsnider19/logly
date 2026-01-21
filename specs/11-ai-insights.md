# 11 - AI Insights

## Overview

AI Insights is a premium feature that allows users to ask natural language questions about their activity data. Questions are processed by a Supabase edge function that generates SQL queries, executes them, and returns human-readable responses.

## Requirements

### Functional Requirements

- [ ] Display chat-style interface for insights
- [ ] Show suggested prompts from database
- [ ] Accept free-form natural language queries
- [ ] Process queries via edge function
- [ ] Display AI-generated responses
- [ ] Maintain conversation history
- [ ] Gate feature behind premium subscription

### Non-Functional Requirements

- [ ] Queries must return within 10 seconds
- [ ] Responses must be streamed for perceived performance
- [ ] Chat history persisted per user

## Architecture

### Query Flow

```
User Query → Edge Function → NL-to-SQL (OpenAI)
                                   ↓
                            Execute SQL Query
                                   ↓
                            Friendly Answer (OpenAI)
                                   ↓
                            Stream Response to Client
```

### Edge Function Pipeline

1. **Validate**: Check user authentication and entitlement
2. **NL-to-SQL**: Convert natural language to SQL using OpenAI
3. **Execute**: Run generated SQL against user's data
4. **Respond**: Generate human-readable answer from results
5. **Store**: Log query, SQL, results, and timing for analytics

### Data Security

- Queries are scoped to the authenticated user's data via RLS
- Generated SQL is validated before execution
- No raw SQL exposed to client

## Components

### Files to Create

```
lib/features/ai_insights/
├── data/
│   ├── insights_repository.dart
│   └── suggested_prompts_repository.dart
├── domain/
│   ├── insight_query.dart
│   ├── insight_response.dart
│   ├── suggested_prompt.dart
│   └── insights_exception.dart
└── presentation/
    ├── screens/
    │   └── ai_insights_screen.dart
    ├── widgets/
    │   ├── chat_message_list.dart
    │   ├── user_message_bubble.dart
    │   ├── ai_response_bubble.dart
    │   ├── suggested_prompt_chips.dart
    │   ├── query_input_field.dart
    │   └── typing_indicator.dart
    └── providers/
        ├── insights_provider.dart
        ├── chat_history_provider.dart
        └── insights_service_provider.dart
```

### Key Classes

| Class | Purpose |
|-------|---------|
| `InsightQuery` | User's question |
| `InsightResponse` | AI's answer |
| `SuggestedPrompt` | Pre-defined prompt suggestion |
| `InsightsService` | Orchestrates query flow |
| `ChatHistoryProvider` | Manages conversation state |

## Data Operations

### Get Suggested Prompts

```dart
Future<List<SuggestedPrompt>> getSuggestedPrompts() async {
  final response = await _supabase
      .from('ai_insight_suggested_prompt')
      .select()
      .eq('is_active', true)
      .order('display_order');

  return (response as List).map((e) => SuggestedPrompt.fromJson(e)).toList();
}
```

### Send Query

```dart
Stream<String> sendQuery(String query, {String? previousResponseId}) async* {
  // Check premium entitlement
  final hasFeature = await _subscriptionService.hasFeature(FeatureCode.aiInsights);
  if (!hasFeature) throw PremiumRequiredException('ai_insights');

  // Call edge function with streaming
  final response = await _supabase.functions.invoke(
    'ai-insights',
    body: {
      'query': query,
      'previous_response_id': previousResponseId,
    },
  );

  // Stream response chunks
  await for (final chunk in response.data) {
    yield chunk['text'] as String;
  }
}
```

### Get Chat History

```dart
Future<List<InsightMessage>> getChatHistory() async {
  final response = await _supabase
      .from('user_ai_insight')
      .select()
      .order('created_at', ascending: false)
      .limit(50);

  return (response as List).expand((e) => [
    InsightMessage.user(e['user_query']),
    InsightMessage.ai(e['friendly_answer_resp']['answer']),
  ]).toList();
}
```

## Database Schema Reference

### ai_insight_suggested_prompt

| Column | Type | Description |
|--------|------|-------------|
| prompt_id | uuid | Primary key |
| prompt_text | text | The suggested question |
| display_order | int | Sort order |
| is_active | boolean | Show in UI |

### user_ai_insight

| Column | Type | Description |
|--------|------|-------------|
| user_ai_insight_id | uuid | Primary key |
| user_id | uuid | FK to profile |
| user_query | text | User's question |
| nl_to_sql_resp | jsonb | NL-to-SQL response |
| nl_to_sql_timing_ms | int | NL-to-SQL latency |
| query_results | jsonb | SQL query results |
| query_error | jsonb | SQL error if any |
| query_timing_ms | int | SQL execution time |
| friendly_answer_resp | jsonb | Final answer |
| friendly_answer_timing_ms | int | Answer generation time |
| openai_response_id | text | OpenAI response ID |
| previous_response_id | text | For conversation threading |

## Edge Function Reference

### Endpoint

`POST /functions/v1/ai-insights`

### Request Body

```json
{
  "query": "How many times did I run last month?",
  "previous_response_id": "optional-for-followup"
}
```

### Response (Streaming)

```json
{
  "text": "You went running 12 times last month...",
  "insight_id": "uuid",
  "timing": {
    "nl_to_sql_ms": 1200,
    "query_ms": 45,
    "answer_ms": 800
  }
}
```

## Example Queries

| Query | SQL Pattern |
|-------|-------------|
| "How many times did I run this week?" | COUNT with date filter |
| "What's my longest streak?" | Streak calculation |
| "Show my most popular activities" | GROUP BY with COUNT |
| "Compare this month to last month" | Period comparison |
| "When did I last do yoga?" | MAX date query |

## Integration Points

- **Subscriptions**: Feature gated to premium users
- **Activity Catalog**: Query references activities
- **Profile**: Some insights overlap with profile stats
- **Core**: Uses Supabase edge functions

## Testing Requirements

### Unit Tests

- [ ] InsightsService handles premium gate
- [ ] Chat history loads correctly
- [ ] Suggested prompts filter active only

### Widget Tests

- [ ] Chat messages render correctly
- [ ] Typing indicator shows during query
- [ ] Suggested prompts display as chips
- [ ] Input field handles submission

### Integration Tests

- [ ] Full query flow with edge function
- [ ] Streaming response renders incrementally
- [ ] Errors display user-friendly messages

## Success Criteria

- [ ] Premium gate prevents non-subscribers
- [ ] Suggested prompts display and are tappable
- [ ] Free-form queries accepted
- [ ] Streaming response renders incrementally
- [ ] Typing indicator shows during processing
- [ ] Responses are accurate and helpful
- [ ] Chat history persists
- [ ] Conversation context maintained for follow-ups
- [ ] Errors handled gracefully
- [ ] Query timing logged for analytics
