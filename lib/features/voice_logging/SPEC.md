# Voice Activity Logging Telemetry

## Overview

This feature adds telemetry tracking for the voice-to-activity logging flow to capture parsing outcomes, enable LLM prompt optimization, and build training datasets. The telemetry system tracks speech-to-text conversion results, LLM parsing details, and user actions (activity selection, dismissal, retry) in a custom Supabase table.

The system is designed to be non-blocking, fire-and-forget, and will store complete transcription and parsing data for analysis while maintaining user privacy through anonymization.

## Requirements

### Functional Requirements

1. **Edge Function Telemetry Logging**
   - Edge function (`parse-voice-activity`) creates a telemetry record after parsing completes
   - Store complete transcription text from speech-to-text
   - Store full LLM response JSON (parsed activity data)
   - Capture LLM metadata: token usage (prompt, completion, total), model name, latency
   - Generate UUID for each telemetry record and return it in response
   - Log errors with full error details (type, message, stack trace) when parsing fails
   - Async fire-and-forget: do not block edge function response waiting for telemetry insert

2. **Flutter App Telemetry Updates**
   - Update existing telemetry record when user takes action on results
   - Track user action: `activity_selected`, `dismissed`, `retry`
   - Store selected activity ID when user chooses from disambiguation list
   - Update is fire-and-forget: do not block UI or show errors if update fails
   - Include client-side context: app version, platform, locale

3. **Data Capture Granularity**
   - Store full transcription text exactly as received from speech-to-text service
   - Store complete parsed JSON response from LLM
   - Store speech-to-text confidence score if available
   - Track which specific activities were returned in search results
   - No sampling: capture 100% of voice parsing attempts
   - No retention policy: keep data indefinitely for training datasets

4. **Privacy & Security**
   - Service-role only access: no RLS policies, only edge function and server can access
   - Always collect telemetry (no opt-out) as operational data for service improvement
   - User data is associated with user_id but considered anonymized for aggregate analysis

### Non-Functional Requirements

1. **Performance**
   - Telemetry insert must not block edge function response to client
   - Use async/fire-and-forget pattern in both edge function and Flutter app
   - Target <50ms overhead for telemetry operations (async, non-blocking)

2. **Reliability**
   - Fire-and-forget: if telemetry fails, log error but do not retry or alert user
   - Accept potential data loss for telemetry to maintain UX performance
   - Telemetry failures should not affect core voice logging functionality

3. **Scalability**
   - Indexed on `user_id + created_at` for efficient time-range queries
   - Flat schema with nullable fields for simple queries and inserts
   - Designed for analytics workloads (batch queries over historical data)

## Architecture

### System Flow

```
1. User speaks → Flutter app captures audio
2. Speech-to-text conversion → transcript
3. Flutter sends transcript to edge function
4. Edge function:
   a. Calls OpenAI GPT-4o-mini for parsing
   b. Performs hybrid search for activities
   c. Inserts telemetry record (async, non-blocking)
   d. Returns response with telemetry_id
5. Flutter displays results to user
6. User takes action (select/dismiss/retry)
7. Flutter updates telemetry record (async, non-blocking)
```

### Data Storage

**Supabase Table**: `voice_activity_telemetry`

**Access Pattern**: Service-role only, no RLS policies

**Primary Use Cases**:
- Analyze parsing failures to improve LLM prompts
- Export data for training datasets or ML model development
- Monitor service health (success rates, latency, error patterns)
- Identify which activity types work well/poorly with voice input

## Components

### Database Schema

**Table**: `voice_activity_telemetry`

```sql
CREATE TABLE voice_activity_telemetry (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ,

  -- Speech-to-text data
  transcript TEXT NOT NULL,
  speech_confidence DOUBLE PRECISION,
  audio_duration_ms INTEGER,

  -- LLM parsing data
  parsed_json JSONB NOT NULL,
  llm_model TEXT NOT NULL,
  prompt_tokens INTEGER NOT NULL,
  completion_tokens INTEGER NOT NULL,
  total_tokens INTEGER NOT NULL,
  llm_latency_ms INTEGER,

  -- Search results
  activity_search_results JSONB, -- Array of activity IDs returned

  -- User action (updated by Flutter app)
  user_action TEXT, -- 'activity_selected', 'dismissed', 'retry', NULL
  selected_activity_id UUID REFERENCES activity(id) ON DELETE SET NULL,
  user_action_timestamp TIMESTAMPTZ,

  -- Client context (updated by Flutter app)
  app_version TEXT,
  platform TEXT,
  locale TEXT,

  -- Error tracking
  error_type TEXT,
  error_message TEXT,
  error_stack_trace TEXT
);

-- Index for time-range queries per user
CREATE INDEX idx_voice_telemetry_user_created
  ON voice_activity_telemetry(user_id, created_at DESC);

-- No RLS policies: service-role only access
ALTER TABLE voice_activity_telemetry ENABLE ROW LEVEL SECURITY;
-- (no policies created)
```

### Edge Function Changes

**File**: `supabase/functions/parse-voice-activity/index.ts`

**Changes**:
1. Add telemetry insert function (async, non-blocking)
2. Call telemetry insert after parsing completes (success or failure)
3. Return `telemetry_id` in response JSON
4. Capture token usage from OpenAI response
5. Track latency of LLM call
6. Store activity IDs from search results

**Method Signature**:
```typescript
async function insertTelemetry(params: {
  userId: string;
  transcript: string;
  speechConfidence?: number;
  audioDurationMs?: number;
  parsedJson: object;
  llmModel: string;
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
  llmLatencyMs: number;
  activitySearchResults: string[]; // activity IDs
  errorType?: string;
  errorMessage?: string;
  errorStackTrace?: string;
}): Promise<string>; // returns telemetry_id
```

### Flutter App Changes

#### Domain Model

**File**: `lib/features/voice_logging/domain/voice_parse_response.dart`

Add `telemetryId` field to `VoiceParseResponse`:

```dart
@freezed
abstract class VoiceParseResponse with _$VoiceParseResponse {
  const factory VoiceParseResponse({
    required VoiceParsedData parsed,
    required List<ActivitySummary> activities,
    String? telemetryId, // NEW: UUID from edge function
  }) = _VoiceParseResponse;

  factory VoiceParseResponse.fromJson(Map<String, dynamic> json) =>
      _$VoiceParseResponseFromJson(json);
}
```

#### Repository

**File**: `lib/features/voice_logging/data/voice_parse_repository.dart`

No changes needed (telemetry_id flows through existing `parseAndSearch` method).

#### Service

**File**: `lib/features/voice_logging/application/voice_telemetry_service.dart` (NEW)

```dart
class VoiceTelemetryService {
  VoiceTelemetryService(this._supabase, this._logger, this._packageInfo);

  final SupabaseClient _supabase;
  final Logger _logger;
  final PackageInfo _packageInfo;

  /// Updates a telemetry record with user action.
  /// Fire-and-forget: does not throw, does not wait for response.
  Future<void> updateUserAction({
    required String telemetryId,
    required String userAction,
    String? selectedActivityId,
  }): Future<void>;
}

@Riverpod(keepAlive: true)
VoiceTelemetryService voiceTelemetryService(VoiceTelemetryServiceRef ref);
```

#### Provider

**File**: `lib/features/voice_logging/presentation/providers/voice_input_provider.dart`

**Changes**:
1. Store `telemetryId` in `VoiceInputState` after parsing
2. Call `VoiceTelemetryService.updateUserAction` when user selects activity, dismisses, or retries
3. Include app version, platform, locale in telemetry update

#### UI

**File**: `lib/features/voice_logging/presentation/widgets/voice_input_sheet.dart`

**Changes**:
1. When user taps activity in disambiguation list → update telemetry with `activity_selected`
2. When user dismisses bottom sheet → update telemetry with `dismissed`
3. When user taps "Try Again" → update telemetry with `retry`

## Data Operations

### Edge Function: Insert Telemetry

```typescript
// After OpenAI call completes
const telemetryId = await insertTelemetry({
  userId: user.id,
  transcript: transcript,
  parsedJson: parsed,
  llmModel: 'gpt-4o-mini',
  promptTokens: parseResponse.usage.prompt_tokens,
  completionTokens: parseResponse.usage.completion_tokens,
  totalTokens: parseResponse.usage.total_tokens,
  llmLatencyMs: llmLatency,
  activitySearchResults: activities.map(a => a.id),
});

// Return telemetry_id in response
return new Response(
  JSON.stringify({
    parsed,
    activities,
    telemetry_id: telemetryId, // NEW
  }),
  { headers: { 'Content-Type': 'application/json' } }
);
```

### Edge Function: Insert Telemetry on Error

```typescript
catch (error) {
  // Log telemetry even for failures
  await insertTelemetry({
    userId: user.id,
    transcript: transcript,
    parsedJson: {},
    llmModel: 'gpt-4o-mini',
    promptTokens: 0,
    completionTokens: 0,
    totalTokens: 0,
    llmLatencyMs: 0,
    activitySearchResults: [],
    errorType: error.name,
    errorMessage: error.message,
    errorStackTrace: error.stack,
  });

  throw error;
}
```

### Flutter: Update Telemetry on User Action

```dart
// When user selects activity
await ref.read(voiceTelemetryServiceProvider).updateUserAction(
  telemetryId: state.telemetryId!,
  userAction: 'activity_selected',
  selectedActivityId: selectedActivity.id,
);

// When user dismisses sheet
await ref.read(voiceTelemetryServiceProvider).updateUserAction(
  telemetryId: state.telemetryId!,
  userAction: 'dismissed',
);

// When user taps retry
await ref.read(voiceTelemetryServiceProvider).updateUserAction(
  telemetryId: state.telemetryId!,
  userAction: 'retry',
);
```

## Integration

### Dependencies

**Flutter**:
- `package_info_plus` - for app version in telemetry updates
- Existing: `supabase_flutter`, `riverpod`, `logger`

**Edge Function**:
- Existing: `openai`, `@supabase/functions-js`

### Environment Variables

No new environment variables required. Uses existing Supabase service role key.

### Database Migration

**File**: `supabase/migrations/YYYYMMDDHHMMSS_create_voice_activity_telemetry.sql`

```sql
-- Create telemetry table
CREATE TABLE voice_activity_telemetry (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ,
  transcript TEXT NOT NULL,
  speech_confidence DOUBLE PRECISION,
  audio_duration_ms INTEGER,
  parsed_json JSONB NOT NULL,
  llm_model TEXT NOT NULL,
  prompt_tokens INTEGER NOT NULL,
  completion_tokens INTEGER NOT NULL,
  total_tokens INTEGER NOT NULL,
  llm_latency_ms INTEGER,
  activity_search_results JSONB,
  user_action TEXT,
  selected_activity_id UUID REFERENCES activity(id) ON DELETE SET NULL,
  user_action_timestamp TIMESTAMPTZ,
  app_version TEXT,
  platform TEXT,
  locale TEXT,
  error_type TEXT,
  error_message TEXT,
  error_stack_trace TEXT
);

-- Index for analytics queries
CREATE INDEX idx_voice_telemetry_user_created
  ON voice_activity_telemetry(user_id, created_at DESC);

-- Enable RLS but create no policies (service-role only)
ALTER TABLE voice_activity_telemetry ENABLE ROW LEVEL SECURITY;

-- Grant access to service role
GRANT ALL ON voice_activity_telemetry TO service_role;
```

### Config.toml

No changes needed (telemetry uses existing `parse-voice-activity` edge function).

## Testing Requirements

### Unit Tests

1. **VoiceTelemetryService**
   - Test `updateUserAction` with all action types
   - Verify fire-and-forget behavior (no exceptions thrown)
   - Mock Supabase client to verify correct data sent
   - Test with/without selected activity ID

2. **Edge Function**
   - Test telemetry insert on successful parse
   - Test telemetry insert on parsing error
   - Verify telemetry_id is returned in response
   - Verify token counts are captured correctly
   - Verify activity IDs are stored in search results

### Integration Tests

1. **End-to-End Voice Flow**
   - User speaks → verify telemetry record created
   - User selects activity → verify record updated with action
   - User dismisses → verify record updated with dismissed action
   - User retries → verify record updated with retry action

2. **Error Scenarios**
   - LLM parsing fails → verify telemetry record created with error details
   - Telemetry insert fails → verify edge function still returns success
   - Telemetry update fails → verify UI still works normally

### Manual Testing

1. Complete voice logging flow and verify telemetry record in database
2. Test all user actions (select, dismiss, retry) and verify updates
3. Trigger parsing error and verify error details captured
4. Verify telemetry does not impact perceived latency

## Future Considerations

### Analytics Dashboard

- Build admin dashboard to view telemetry metrics (success rate, avg latency, common failures)
- Export telemetry data for ML training datasets
- Visualize activity type success rates by category

### Enhanced Telemetry

- Capture confidence scores from LLM (if exposed by OpenAI)
- Track ambient noise level during recording (if available from speech service)
- Store intermediate embeddings for similarity analysis
- Add A/B testing support (different prompts, models)

### Privacy Enhancements

- Add ability to bulk-delete user telemetry on account deletion
- Implement data retention policy (delete after N months)
- Add telemetry opt-out setting in app (if required by privacy regulations)

### Performance Optimization

- Batch telemetry updates from Flutter app (collect multiple events, send in batch)
- Implement telemetry sampling (capture 10% of events if volume becomes too high)
- Use separate database or analytics warehouse for telemetry at scale

## Success Criteria

- [ ] Database migration creates `voice_activity_telemetry` table
- [ ] Database migration creates index on `user_id + created_at`
- [ ] Database migration enables RLS with no policies
- [ ] Edge function inserts telemetry record on successful parse
- [ ] Edge function inserts telemetry record on parsing error
- [ ] Edge function returns `telemetry_id` in response
- [ ] Edge function captures token usage from OpenAI response
- [ ] Edge function tracks LLM latency
- [ ] Edge function stores activity IDs from search results
- [ ] `VoiceParseResponse` domain model includes `telemetryId` field
- [ ] `VoiceTelemetryService` created with `updateUserAction` method
- [ ] `VoiceTelemetryService` uses fire-and-forget pattern (no exceptions)
- [ ] `VoiceInputState` stores `telemetryId` after parsing
- [ ] Voice input provider calls telemetry service on activity selection
- [ ] Voice input provider calls telemetry service on dismiss
- [ ] Voice input provider calls telemetry service on retry
- [ ] Telemetry update includes app version, platform, locale
- [ ] Telemetry operations do not block UI or edge function response
- [ ] Unit tests for `VoiceTelemetryService`
- [ ] Integration tests for edge function telemetry insert
- [ ] End-to-end test for complete voice telemetry flow
- [ ] Manual testing confirms telemetry data is captured correctly
- [ ] Manual testing confirms telemetry failures do not affect UX

## Items to Complete

- [ ] Create database migration for `voice_activity_telemetry` table
- [ ] Update edge function to insert telemetry (success case)
- [ ] Update edge function to insert telemetry (error case)
- [ ] Update edge function to return `telemetry_id` in response
- [ ] Add `telemetryId` field to `VoiceParseResponse` domain model
- [ ] Run code generation for updated domain model
- [ ] Create `VoiceTelemetryService` service class
- [ ] Create `VoiceTelemetryService` provider
- [ ] Add `telemetryId` to `VoiceInputState`
- [ ] Update `voice_input_provider` to store telemetry ID from response
- [ ] Update `voice_input_provider` to call telemetry service on activity selection
- [ ] Update `voice_input_provider` to call telemetry service on dismiss
- [ ] Update `voice_input_provider` to call telemetry service on retry
- [ ] Add `package_info_plus` dependency if not already present
- [ ] Write unit tests for `VoiceTelemetryService`
- [ ] Write integration tests for edge function telemetry
- [ ] Write end-to-end test for voice telemetry flow
- [ ] Perform manual testing of complete flow
- [ ] Document telemetry schema in Supabase schema.ts (if auto-generated)
