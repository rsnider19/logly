-- =============================================================================
-- Observability Report Queries for chat_telemetry_log
-- =============================================================================
-- Run these queries in Supabase Dashboard SQL Editor for monitoring
-- and reporting on AI chat interactions.
--
-- Metrics available:
--   - Token cost (calculated from stored counts using current prices)
--   - Latency per step with percentiles
--   - Error rate breakdown
--   - Per-user usage
--   - SQL pattern analysis
--   - Off-topic rate
--   - Model comparison
-- =============================================================================


-- =============================================================================
-- 1. TOTAL TOKEN COST OVER TIME RANGE
-- =============================================================================
-- Calculates daily aggregates of token usage and estimated USD cost.
-- Uses gpt-4o-mini pricing: $0.15/1M input, $0.60/1M output
-- Cached tokens billed at 50% discount.
--
-- Adjust date range in WHERE clause as needed.

WITH token_prices AS (
  -- gpt-4o-mini pricing as of Feb 2026
  -- Update these values if model pricing changes
  SELECT
    0.15 AS input_price_per_million,
    0.60 AS output_price_per_million,
    0.50 AS cached_discount  -- 50% discount for cached tokens
)
SELECT
  date_trunc('day', created_at) AS day,
  COUNT(*) AS total_requests,
  -- Token counts
  COALESCE(SUM(sql_input_tokens), 0) + COALESCE(SUM(response_input_tokens), 0) AS total_input_tokens,
  COALESCE(SUM(sql_output_tokens), 0) + COALESCE(SUM(response_output_tokens), 0) AS total_output_tokens,
  COALESCE(SUM(sql_cached_tokens), 0) + COALESCE(SUM(response_cached_tokens), 0) AS total_cached_tokens,
  -- Calculate estimated cost
  ROUND(
    (
      -- Uncached input tokens
      (
        (COALESCE(SUM(sql_input_tokens), 0) - COALESCE(SUM(sql_cached_tokens), 0)) +
        (COALESCE(SUM(response_input_tokens), 0) - COALESCE(SUM(response_cached_tokens), 0))
      ) / 1000000.0 * p.input_price_per_million
      -- Cached input tokens (discounted)
      + (COALESCE(SUM(sql_cached_tokens), 0) + COALESCE(SUM(response_cached_tokens), 0))
        / 1000000.0 * p.input_price_per_million * (1 - p.cached_discount)
      -- Output tokens (no caching)
      + (COALESCE(SUM(sql_output_tokens), 0) + COALESCE(SUM(response_output_tokens), 0))
        / 1000000.0 * p.output_price_per_million
    )::numeric,
    4
  ) AS estimated_cost_usd
FROM chat_telemetry_log, token_prices p
WHERE created_at >= NOW() - INTERVAL '7 days'
GROUP BY 1, p.input_price_per_million, p.output_price_per_million, p.cached_discount
ORDER BY 1 DESC;


-- =============================================================================
-- 2. AVERAGE LATENCY PER STEP WITH PERCENTILES
-- =============================================================================
-- Shows p50, p95, p99 for each step of the pipeline.
-- Filters to successful requests only (no errors).

SELECT
  -- NL-to-SQL step
  ROUND(AVG(nl_to_sql_duration_ms)) AS avg_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p50_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p95_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p99_sql_gen_ms,

  -- SQL execution step
  ROUND(AVG(sql_execution_duration_ms)) AS avg_exec_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p50_exec_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p95_exec_ms,
  ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p99_exec_ms,

  -- Response generation step
  ROUND(AVG(response_generation_duration_ms)) AS avg_resp_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY response_generation_duration_ms)) AS p50_resp_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY response_generation_duration_ms)) AS p95_resp_ms,
  ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY response_generation_duration_ms)) AS p99_resp_ms,

  -- Time to first byte (user-perceived latency)
  ROUND(AVG(ttfb_ms)) AS avg_ttfb_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ttfb_ms)) AS p50_ttfb_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ttfb_ms)) AS p95_ttfb_ms,
  ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY ttfb_ms)) AS p99_ttfb_ms
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND error_type IS NULL;


-- =============================================================================
-- 3. ERROR RATE BREAKDOWN
-- =============================================================================
-- Shows count and percentage by error type and failed step.
-- Helps identify which step is most problematic.

WITH total AS (
  SELECT COUNT(*) AS total_count
  FROM chat_telemetry_log
  WHERE created_at >= NOW() - INTERVAL '7 days'
),
errors AS (
  SELECT COUNT(*) AS error_count
  FROM chat_telemetry_log
  WHERE created_at >= NOW() - INTERVAL '7 days'
    AND error_type IS NOT NULL
)
SELECT
  'Overall Error Rate' AS metric,
  errors.error_count AS count,
  total.total_count AS total,
  ROUND(errors.error_count::numeric / NULLIF(total.total_count, 0) * 100, 2) AS error_rate_pct
FROM total, errors

UNION ALL

SELECT
  error_type || ' / ' || COALESCE(failed_step, 'unknown') AS metric,
  COUNT(*) AS count,
  (SELECT COUNT(*) FROM chat_telemetry_log WHERE created_at >= NOW() - INTERVAL '7 days') AS total,
  ROUND(
    COUNT(*)::numeric /
    NULLIF((SELECT COUNT(*) FROM chat_telemetry_log WHERE created_at >= NOW() - INTERVAL '7 days'), 0) * 100,
    2
  ) AS error_rate_pct
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND error_type IS NOT NULL
GROUP BY error_type, failed_step
ORDER BY count DESC;


-- =============================================================================
-- 4. PER-USER USAGE AND COST
-- =============================================================================
-- Shows usage metrics per user for the last 30 days.
-- Useful for identifying heavy users and per-user cost attribution.

WITH token_prices AS (
  SELECT
    0.15 AS input_price_per_million,
    0.60 AS output_price_per_million,
    0.50 AS cached_discount
)
SELECT
  user_id,
  COUNT(*) AS total_requests,
  COALESCE(SUM(sql_input_tokens), 0) + COALESCE(SUM(response_input_tokens), 0) AS total_input_tokens,
  COALESCE(SUM(sql_output_tokens), 0) + COALESCE(SUM(response_output_tokens), 0) AS total_output_tokens,
  COUNT(*) FILTER (WHERE error_type IS NOT NULL) AS error_count,
  COUNT(*) FILTER (WHERE is_off_topic) AS off_topic_count,
  -- Estimated cost per user
  ROUND(
    (
      (
        (COALESCE(SUM(sql_input_tokens), 0) - COALESCE(SUM(sql_cached_tokens), 0)) +
        (COALESCE(SUM(response_input_tokens), 0) - COALESCE(SUM(response_cached_tokens), 0))
      ) / 1000000.0 * p.input_price_per_million
      + (COALESCE(SUM(sql_cached_tokens), 0) + COALESCE(SUM(response_cached_tokens), 0))
        / 1000000.0 * p.input_price_per_million * (1 - p.cached_discount)
      + (COALESCE(SUM(sql_output_tokens), 0) + COALESCE(SUM(response_output_tokens), 0))
        / 1000000.0 * p.output_price_per_million
    )::numeric,
    4
  ) AS estimated_cost_usd
FROM chat_telemetry_log, token_prices p
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY user_id, p.input_price_per_million, p.output_price_per_million, p.cached_discount
ORDER BY total_input_tokens DESC
LIMIT 50;


-- =============================================================================
-- 5. TOP SQL PATTERNS BY FINGERPRINT
-- =============================================================================
-- Groups queries by their normalized fingerprint to identify common patterns.
-- Shows occurrence count, example SQL, average execution time, and row count.

SELECT
  sql_fingerprint,
  COUNT(*) AS occurrences,
  MIN(generated_sql) AS example_sql,  -- One example (MIN to get deterministic result)
  ROUND(AVG(sql_execution_duration_ms)) AS avg_exec_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p95_exec_ms,
  ROUND(AVG(result_row_count)) AS avg_rows,
  MAX(result_row_count) AS max_rows
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND sql_fingerprint IS NOT NULL
GROUP BY sql_fingerprint
ORDER BY occurrences DESC
LIMIT 20;


-- =============================================================================
-- 6. OFF-TOPIC RATE OVER TIME
-- =============================================================================
-- Daily breakdown of total requests vs off-topic detections.
-- Helps understand how often users ask non-data questions.

SELECT
  date_trunc('day', created_at) AS day,
  COUNT(*) AS total_requests,
  COUNT(*) FILTER (WHERE is_off_topic) AS off_topic_count,
  ROUND(
    COUNT(*) FILTER (WHERE is_off_topic)::numeric / NULLIF(COUNT(*), 0) * 100,
    2
  ) AS off_topic_pct
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY 1
ORDER BY 1 DESC;


-- =============================================================================
-- 7. MODEL COMPARISON
-- =============================================================================
-- Compares performance and cost across different models.
-- Useful if multiple models are used for different steps.

SELECT
  sql_model,
  response_model,
  COUNT(*) AS total_requests,
  -- Latency comparison
  ROUND(AVG(nl_to_sql_duration_ms)) AS avg_sql_gen_ms,
  ROUND(AVG(sql_execution_duration_ms)) AS avg_exec_ms,
  ROUND(AVG(response_generation_duration_ms)) AS avg_resp_ms,
  ROUND(AVG(ttfb_ms)) AS avg_ttfb_ms,
  -- Token comparison
  COALESCE(SUM(sql_input_tokens), 0) + COALESCE(SUM(response_input_tokens), 0) AS total_input_tokens,
  COALESCE(SUM(sql_output_tokens), 0) + COALESCE(SUM(response_output_tokens), 0) AS total_output_tokens,
  -- Error rate by model
  ROUND(
    COUNT(*) FILTER (WHERE error_type IS NOT NULL)::numeric / NULLIF(COUNT(*), 0) * 100,
    2
  ) AS error_rate_pct
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
GROUP BY sql_model, response_model
ORDER BY total_requests DESC;
