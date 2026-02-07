-- Voice activity telemetry table for tracking voice input interactions and errors.
-- Service role only (no client access). Used for analytics and debugging.

-- ============================================================================
-- voice_activity_telemetry table
-- ============================================================================
-- Captures comprehensive telemetry for voice activity logging feature including:
-- - Speech recognition metrics (transcript, confidence, duration)
-- - LLM parsing metrics (model, tokens, latency)
-- - User interaction flow (search results, selected activity, action taken)
-- - Error tracking (type, message, stack trace)
-- - Context metadata (app version, platform, locale)

CREATE TABLE IF NOT EXISTS public.voice_activity_telemetry (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),

  -- Speech recognition data
  transcript text,
  speech_confidence real,
  audio_duration_ms integer,

  -- LLM parsing data
  parsed_json jsonb,
  llm_model text,
  prompt_tokens integer,
  completion_tokens integer,
  total_tokens integer,
  llm_latency_ms integer,

  -- User interaction flow
  activity_search_results jsonb,
  user_action text,
  selected_activity_id uuid,
  user_action_timestamp timestamptz,

  -- Context metadata
  app_version text,
  platform text,
  locale text,

  -- Error tracking
  error_type text,
  error_message text,
  error_stack_trace text
);

-- RLS: Enable but no policies (service_role only)
ALTER TABLE public.voice_activity_telemetry ENABLE ROW LEVEL SECURITY;

-- Index for querying user telemetry by recency
CREATE INDEX idx_voice_activity_telemetry_user_created
  ON public.voice_activity_telemetry (user_id, created_at DESC);

-- Partial index for error analysis (only index rows with errors)
CREATE INDEX idx_voice_activity_telemetry_error
  ON public.voice_activity_telemetry (error_type, created_at DESC)
  WHERE error_type IS NOT NULL;

-- Partial index for user action analysis (only index rows with user actions)
CREATE INDEX idx_voice_activity_telemetry_user_action
  ON public.voice_activity_telemetry (user_action, user_action_timestamp DESC)
  WHERE user_action IS NOT NULL;
