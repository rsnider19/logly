-- =============================================================================
-- chat_telemetry_log: Observability table for AI chat interactions
-- =============================================================================
-- Single denormalized table capturing all metrics from each chat request.
-- Design decisions from CONTEXT.md:
--   - One row per request with flat columns (not JSONB, not normalized steps)
--   - All timing and token columns NULLABLE for partial failures
--   - Service role only access (no user-facing reads)
--   - Keep indefinitely (no auto-deletion)
-- =============================================================================

CREATE TABLE public.chat_telemetry_log (
  -- Primary key and identifiers
  log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  conversation_id uuid REFERENCES public.chat_conversations(conversation_id) ON DELETE SET NULL,
  response_id text,  -- OpenAI response ID

  -- Request timestamp
  created_at timestamptz NOT NULL DEFAULT now(),

  -- Content captured (per CONTEXT.md decisions)
  user_question text NOT NULL,
  ai_response text,  -- NULL if error before response generated
  generated_sql text,  -- NULL if off-topic or error before SQL generation
  sql_fingerprint text,  -- md5 hash of normalized SQL for pattern grouping
  result_row_count integer,  -- Row count only, never actual data (privacy)
  follow_up_suggestions jsonb,  -- Array of strings offered to user

  -- Error tracking
  error_type text,  -- 'sql_generation', 'sql_validation', 'sql_execution', 'response_generation', 'unexpected'
  error_message text,
  failed_step text,  -- Which step failed: 'understanding', 'looking_up', 'response'

  -- Off-topic flag
  is_off_topic boolean NOT NULL DEFAULT false,

  -- Model tracking
  sql_model text,  -- e.g., 'gpt-4o-mini'
  response_model text,  -- e.g., 'gpt-4o-mini'

  -- Timing (all in milliseconds, integer, NULLABLE for partial failures)
  nl_to_sql_duration_ms integer,  -- Time to generate SQL from natural language
  sql_execution_duration_ms integer,  -- Time to run query against database
  response_generation_duration_ms integer,  -- Time to generate natural language response
  ttfb_ms integer,  -- Time to first byte (first SSE event with text)

  -- Token tracking: SQL generation step (NULLABLE for partial failures)
  sql_input_tokens integer,
  sql_output_tokens integer,
  sql_cached_tokens integer,  -- From input_tokens_details.cached_tokens

  -- Token tracking: Response generation step (NULLABLE for partial failures)
  response_input_tokens integer,
  response_output_tokens integer,
  response_cached_tokens integer
);

-- =============================================================================
-- Indexes (per CONTEXT.md: time range, user_id, error status, sql_fingerprint)
-- =============================================================================

-- Primary time-based queries (dashboard, trends)
CREATE INDEX idx_chat_telemetry_created_at
  ON public.chat_telemetry_log (created_at DESC);

-- Per-user filtering with time ordering
CREATE INDEX idx_chat_telemetry_user_id
  ON public.chat_telemetry_log (user_id, created_at DESC);

-- Error analysis (partial index for efficiency)
CREATE INDEX idx_chat_telemetry_error
  ON public.chat_telemetry_log (error_type)
  WHERE error_type IS NOT NULL;

-- SQL pattern grouping (partial index, only when fingerprint exists)
CREATE INDEX idx_chat_telemetry_fingerprint
  ON public.chat_telemetry_log (sql_fingerprint)
  WHERE sql_fingerprint IS NOT NULL;

-- =============================================================================
-- Trigger: Auto-compute sql_fingerprint on INSERT
-- =============================================================================
-- Fingerprint = md5 of normalized SQL (lowercase, collapsed whitespace)
-- Computed server-side so edge function doesn't need to hash

CREATE OR REPLACE FUNCTION compute_sql_fingerprint()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.generated_sql IS NOT NULL THEN
    NEW.sql_fingerprint := md5(lower(regexp_replace(NEW.generated_sql, '\s+', ' ', 'g')));
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_compute_sql_fingerprint
  BEFORE INSERT ON public.chat_telemetry_log
  FOR EACH ROW
  EXECUTE FUNCTION compute_sql_fingerprint();

-- =============================================================================
-- Row Level Security: Service role only (no user access)
-- =============================================================================
-- Per CONTEXT.md: "Admin only via service role -- users cannot see their own telemetry logs"

ALTER TABLE public.chat_telemetry_log ENABLE ROW LEVEL SECURITY;

-- No SELECT/INSERT/UPDATE/DELETE policies for authenticated users.
-- Service role bypasses RLS, so it can read/write.
-- This table is intentionally invisible to regular users.

COMMENT ON TABLE public.chat_telemetry_log IS
  'Observability log for AI chat interactions. Service role only access. One row per request with denormalized metrics.';
