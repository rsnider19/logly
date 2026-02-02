-- Per-user rate limiting table for the chat edge function.
-- Tracks request counts per user per hour window (sliding window approximation).

CREATE TABLE IF NOT EXISTS public.chat_rate_limits (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  window_start timestamptz NOT NULL,
  request_count integer NOT NULL DEFAULT 1,
  PRIMARY KEY (user_id, window_start)
);

-- RLS: users can only see their own rate limit records
ALTER TABLE public.chat_rate_limits ENABLE ROW LEVEL SECURITY;

-- Index for cleanup of old windows
CREATE INDEX idx_chat_rate_limits_window ON public.chat_rate_limits (window_start);
