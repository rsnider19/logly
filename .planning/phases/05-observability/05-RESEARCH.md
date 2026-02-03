# Phase 5: Observability - Research

**Researched:** 2026-02-03
**Domain:** Server-side telemetry logging, SQL fingerprinting, token tracking, Supabase observability patterns
**Confidence:** HIGH (existing logging patterns in codebase, OpenAI API structure well-documented, PostgreSQL patterns established)

## Summary

This phase implements comprehensive server-side observability for the chat edge function by creating a dedicated telemetry log table with denormalized columns for all metrics. The existing codebase already has partial logging via `user_ai_insight` and `user_ai_insight_step` tables in the `ai-insights` function, but CONTEXT.md specifies a new **single denormalized table** design that differs from the existing normalized step-based approach.

The key technical challenges are: (1) designing a denormalized schema that captures all decided-upon fields without redundancy, (2) capturing timing metrics at each pipeline step with sub-millisecond accuracy, (3) extracting token usage from OpenAI Responses API events (including cached tokens), and (4) generating SQL query fingerprints for pattern analysis.

**Primary recommendation:** Create a new `chat_telemetry_log` table with flat columns for all metrics (not JSONB), modify the chat pipeline to capture timings and token usage during execution, and persist a single log record after each request completes. Use PostgreSQL's built-in `md5()` function for SQL fingerprinting (simple, fast, sufficient for pattern grouping).

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| PostgreSQL `md5()` | Built-in | SQL query fingerprinting | Native Postgres, zero dependencies, 32-char hex suitable for pattern grouping |
| `performance.now()` | Deno built-in | High-resolution timing | Already used in existing `ai-insights` pipeline, sub-millisecond precision |
| Supabase Admin Client | `@supabase/supabase-js@2` | Service role writes to telemetry table | Already used in chat persistence module |
| OpenAI `response.usage` | API response field | Token counts including cached | Source of truth per CONTEXT.md decision |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Deno `TextEncoder` | Built-in | Encoding SQL for hashing | Fingerprint generation |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| PostgreSQL `md5()` | pg_query library for proper AST-based fingerprinting | pg_query requires extension installation; md5 of normalized SQL is sufficient for pattern grouping and works natively |
| Flat columns | JSONB for token/timing data | CONTEXT.md explicitly decided "Separate columns per step (not JSON)" for queryability |
| Separate steps table | Single denormalized row | CONTEXT.md explicitly decided "Single denormalized table -- one row per request" |

## Architecture Patterns

### Recommended Project Structure

```
supabase/
├── functions/
│   └── chat/
│       ├── pipeline.ts           # MODIFY: Add telemetry capture
│       ├── telemetry.ts          # NEW: Telemetry types and persistence
│       ├── sqlGenerator.ts       # MODIFY: Return token usage
│       └── responseGenerator.ts  # MODIFY: Return token usage
├── migrations/
│   └── 2026MMDD_create_chat_telemetry_log.sql  # NEW: Telemetry table
└── snippets/
    └── observability_reports.sql # NEW: Example report queries
```

### Pattern 1: Denormalized Telemetry Table Schema

**What:** Single table with one row per chat request, all metrics as flat columns.

**Why this design (per CONTEXT.md):**
- Single denormalized table (vs. existing steps-based normalization)
- Separate columns for each metric (vs. JSONB)
- Captures timing, tokens, SQL, response, error state in one row

**Schema:**
```sql
-- Source: Derived from CONTEXT.md decisions
CREATE TABLE public.chat_telemetry_log (
  -- Primary key and identifiers
  log_id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  conversation_id uuid REFERENCES public.chat_conversations(conversation_id) ON DELETE SET NULL,
  response_id text,  -- OpenAI response ID for follow-up chaining

  -- Request timestamp
  created_at timestamptz NOT NULL DEFAULT now(),

  -- Content captured (per CONTEXT.md decisions)
  user_question text NOT NULL,
  ai_response text,  -- NULL if error before response
  generated_sql text,  -- NULL if off-topic or error
  sql_fingerprint text,  -- md5 hash for pattern grouping
  result_row_count integer,  -- Row count only, never actual data
  follow_up_suggestions jsonb,  -- Array of strings offered

  -- Error tracking
  error_type text,  -- 'sql_generation', 'sql_validation', 'sql_execution', 'response_generation', etc.
  error_message text,
  failed_step text,  -- Which step failed (for partial failures)

  -- Off-topic flag
  is_off_topic boolean NOT NULL DEFAULT false,

  -- Model tracking
  sql_model text,  -- e.g., 'gpt-4o-mini'
  response_model text,  -- e.g., 'gpt-4o-mini'

  -- Timing (all in milliseconds, integer)
  nl_to_sql_duration_ms integer,  -- Time to generate SQL
  sql_execution_duration_ms integer,  -- Time to run query
  response_generation_duration_ms integer,  -- Time to generate response
  ttfb_ms integer,  -- Time to first byte (first SSE event with text)

  -- Token tracking: SQL generation step
  sql_input_tokens integer,
  sql_output_tokens integer,
  sql_cached_tokens integer,  -- From input_tokens_details.cached_tokens

  -- Token tracking: Response generation step
  response_input_tokens integer,
  response_output_tokens integer,
  response_cached_tokens integer
);

-- Indexes per CONTEXT.md: time range, user_id, error status, sql_fingerprint
CREATE INDEX idx_chat_telemetry_created_at ON public.chat_telemetry_log (created_at DESC);
CREATE INDEX idx_chat_telemetry_user_id ON public.chat_telemetry_log (user_id, created_at DESC);
CREATE INDEX idx_chat_telemetry_error ON public.chat_telemetry_log (error_type) WHERE error_type IS NOT NULL;
CREATE INDEX idx_chat_telemetry_fingerprint ON public.chat_telemetry_log (sql_fingerprint) WHERE sql_fingerprint IS NOT NULL;

-- RLS: Admin only via service role (per CONTEXT.md)
ALTER TABLE public.chat_telemetry_log ENABLE ROW LEVEL SECURITY;

-- No SELECT policy for authenticated users - service role only
CREATE POLICY "Service role full access"
  ON public.chat_telemetry_log
  FOR ALL
  USING (true)
  WITH CHECK (true);
```

### Pattern 2: Token Usage Extraction from OpenAI Responses API

**What:** Extract detailed token usage from OpenAI `response.completed` event, including cached tokens.

**OpenAI Usage Object Structure:**
```typescript
// Source: OpenAI API documentation and existing ai-insights code
interface OpenAIUsage {
  input_tokens: number;
  input_tokens_details?: {
    cached_tokens: number;
  };
  output_tokens: number;
  output_tokens_details?: {
    reasoning_tokens?: number;  // Only for reasoning models
  };
  total_tokens: number;
}
```

**Current codebase gap:** The existing `sqlGenerator.ts` and `responseGenerator.ts` do NOT return usage data. They only return `conversionId` and `responseId`. Need to modify to capture and return usage.

**Example modification for sqlGenerator.ts:**
```typescript
// Source: Derived from existing sqlGenerator.ts pattern
export interface GenerateSQLResult {
  parsed: NlToSqlResult;
  conversionId: string;
  usage: {
    inputTokens: number;
    outputTokens: number;
    cachedTokens: number;
  };
}

// In generateSQL function:
const response = await openai.responses.create({...});

// Extract usage from response
const usage = {
  inputTokens: response.usage?.input_tokens ?? 0,
  outputTokens: response.usage?.output_tokens ?? 0,
  cachedTokens: response.usage?.input_tokens_details?.cached_tokens ?? 0,
};

return { parsed, conversionId: response.id, usage };
```

**For streaming (responseGenerator.ts):** Token usage is available in the `response.completed` event, which the existing code already listens for:
```typescript
// Source: Existing responseGenerator.ts
if (event.type === "response.completed") {
  responseId = event.response.id;
  // ADD: Extract usage from completed event
  usage = {
    inputTokens: event.response.usage?.input_tokens ?? 0,
    outputTokens: event.response.usage?.output_tokens ?? 0,
    cachedTokens: event.response.usage?.input_tokens_details?.cached_tokens ?? 0,
  };
}
```

### Pattern 3: Timing Capture with TTFB

**What:** Capture granular timing metrics for each pipeline step, including Time to First Byte.

**Current codebase approach:** The existing `ai-insights/agent.ts` uses `performance.now()` for step timing. The chat pipeline does NOT currently capture timing -- need to add.

**Implementation:**
```typescript
// Source: Derived from existing ai-insights timing pattern
export interface TelemetryTimings {
  nlToSqlDurationMs: number | null;
  sqlExecutionDurationMs: number | null;
  responseGenerationDurationMs: number | null;
  ttfbMs: number | null;  // Time from request start to first text_delta
}

// In pipeline.ts:
const requestStart = performance.now();
let firstTextTime: number | null = null;

// ... NL-to-SQL step
const sqlStart = performance.now();
const sqlResult = await generateSQL({...});
const nlToSqlDurationMs = Math.round(performance.now() - sqlStart);

// ... SQL execution step
const execStart = performance.now();
const queryResult = await executeWithRLS(...);
const sqlExecutionDurationMs = Math.round(performance.now() - execStart);

// ... Response generation with TTFB capture
const respStart = performance.now();
const { responseId, usage } = await generateStreamingResponse({
  ...
  onTextDelta: (delta) => {
    if (firstTextTime === null) {
      firstTextTime = performance.now();
    }
    progress.sendTextDelta(delta);
  },
});
const responseGenerationDurationMs = Math.round(performance.now() - respStart);
const ttfbMs = firstTextTime !== null
  ? Math.round(firstTextTime - requestStart)
  : null;
```

### Pattern 4: SQL Fingerprinting with md5()

**What:** Generate a normalized fingerprint of generated SQL for pattern grouping.

**Why md5() (not pg_query):**
- Native PostgreSQL function, no extension needed
- Sufficient for grouping similar queries (exact collision probability negligible)
- Fast and simple
- CONTEXT.md requires "normalized fingerprint hash" for pattern grouping

**Normalization approach:**
1. Lowercase the SQL
2. Collapse multiple whitespace to single space
3. Remove leading/trailing whitespace
4. Hash the result

**Edge function implementation:**
```typescript
// Source: Standard pattern for SQL normalization
function normalizeSQL(sql: string): string {
  return sql
    .toLowerCase()
    .replace(/\s+/g, ' ')
    .trim();
}

function generateSqlFingerprint(sql: string): string {
  // Use Web Crypto API available in Deno
  const normalized = normalizeSQL(sql);
  const encoder = new TextEncoder();
  const data = encoder.encode(normalized);

  // MD5 via subtle crypto (or use postgres md5() on insert)
  // For simplicity, compute in Postgres on insert:
  // INSERT INTO ... VALUES (..., md5($sql), ...)
  return normalized;  // Pass normalized SQL, hash in Postgres
}
```

**Database-side fingerprinting (simpler):**
```sql
-- Compute fingerprint at insert time
INSERT INTO chat_telemetry_log (
  ...,
  generated_sql,
  sql_fingerprint,
  ...
) VALUES (
  ...,
  $sql,
  md5(lower(regexp_replace($sql, '\s+', ' ', 'g'))),
  ...
);
```

### Pattern 5: Telemetry Persistence Module

**What:** Centralized module for building and persisting telemetry records.

**Why separate module:**
- Single responsibility for telemetry logic
- Easy to extend with additional metrics
- Testable in isolation
- Consistent error handling

**Example:**
```typescript
// Source: Derived from existing persistence.ts pattern
// supabase/functions/chat/telemetry.ts

import { createClient } from "npm:@supabase/supabase-js";

const supabaseAdmin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

export interface TelemetryRecord {
  userId: string;
  conversationId?: string;
  responseId?: string;

  userQuestion: string;
  aiResponse?: string;
  generatedSql?: string;
  resultRowCount?: number;
  followUpSuggestions?: string[];

  errorType?: string;
  errorMessage?: string;
  failedStep?: string;

  isOffTopic: boolean;

  sqlModel?: string;
  responseModel?: string;

  nlToSqlDurationMs?: number;
  sqlExecutionDurationMs?: number;
  responseGenerationDurationMs?: number;
  ttfbMs?: number;

  sqlInputTokens?: number;
  sqlOutputTokens?: number;
  sqlCachedTokens?: number;

  responseInputTokens?: number;
  responseOutputTokens?: number;
  responseCachedTokens?: number;
}

export async function persistTelemetry(record: TelemetryRecord): Promise<void> {
  try {
    const { error } = await supabaseAdmin
      .from("chat_telemetry_log")
      .insert({
        user_id: record.userId,
        conversation_id: record.conversationId,
        response_id: record.responseId,

        user_question: record.userQuestion,
        ai_response: record.aiResponse,
        generated_sql: record.generatedSql,
        sql_fingerprint: record.generatedSql
          ? null  // Let Postgres compute via trigger or on insert
          : null,
        result_row_count: record.resultRowCount,
        follow_up_suggestions: record.followUpSuggestions,

        error_type: record.errorType,
        error_message: record.errorMessage,
        failed_step: record.failedStep,

        is_off_topic: record.isOffTopic,

        sql_model: record.sqlModel,
        response_model: record.responseModel,

        nl_to_sql_duration_ms: record.nlToSqlDurationMs,
        sql_execution_duration_ms: record.sqlExecutionDurationMs,
        response_generation_duration_ms: record.responseGenerationDurationMs,
        ttfb_ms: record.ttfbMs,

        sql_input_tokens: record.sqlInputTokens,
        sql_output_tokens: record.sqlOutputTokens,
        sql_cached_tokens: record.sqlCachedTokens,

        response_input_tokens: record.responseInputTokens,
        response_output_tokens: record.responseOutputTokens,
        response_cached_tokens: record.responseCachedTokens,
      });

    if (error) {
      console.error("[Telemetry] Failed to persist log:", error);
      // Non-fatal - don't throw, telemetry should not break the main flow
    }
  } catch (err) {
    console.error("[Telemetry] Unexpected error:", err);
    // Non-fatal
  }
}
```

### Anti-Patterns to Avoid

- **Blocking on telemetry persistence:** Telemetry writes should be fire-and-forget or at least not block the SSE response. The existing chat pipeline returns the Response immediately and runs async -- telemetry should persist in that async block, not block the response.
- **Storing actual query results:** CONTEXT.md explicitly says "Row count only -- never store actual data" for privacy.
- **Using JSONB for metrics:** CONTEXT.md decided "Separate columns per step (not JSON)" for easier SQL querying.
- **Throwing on telemetry failures:** Telemetry is non-critical; failures should be logged but not propagate to the user.
- **Computing fingerprints for off-topic queries:** Off-topic responses have no SQL, so fingerprint should be NULL.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| SQL fingerprinting | Custom AST parsing | PostgreSQL `md5()` on normalized SQL | Native, fast, sufficient for pattern grouping |
| Token usage tracking | Manual counting | OpenAI `response.usage` field | Authoritative source per CONTEXT.md |
| High-resolution timing | `Date.now()` | `performance.now()` | Sub-millisecond precision, already used in codebase |
| Cost calculation | Stored cost column | Calculate in report queries | CONTEXT.md: "Cost calculation: Not stored -- calculate in reports using current prices" |

**Key insight:** The telemetry system should be transparent to the user and non-blocking. It augments the existing chat flow without changing user-facing behavior. All complexity is in data capture, not in the user path.

## Common Pitfalls

### Pitfall 1: Token Usage Missing in Streaming Responses

**What goes wrong:** `response.usage` is null during streaming events, only populated in `response.completed`.
**Why it happens:** OpenAI streams text deltas first, then sends final usage in the completed event.
**How to avoid:** Wait for `response.completed` event to capture usage, which the existing code already does.
**Warning signs:** All token counts are 0 or null in telemetry logs.

### Pitfall 2: TTFB Measured Too Late

**What goes wrong:** TTFB appears to be very high because measurement starts after some processing.
**Why it happens:** Forgetting to capture the absolute request start time.
**How to avoid:** Record `performance.now()` at the very start of the pipeline (before any async work), not when response generation starts.
**Warning signs:** TTFB > total pipeline duration, which is impossible.

### Pitfall 3: Telemetry Persistence Blocking Response

**What goes wrong:** Users experience delayed response because telemetry insert blocks.
**Why it happens:** Awaiting telemetry persistence in the SSE response path.
**How to avoid:** Persist telemetry in the finally block or after `progress.close()`, ensuring the SSE stream is complete. Use fire-and-forget pattern.
**Warning signs:** Response latency increases after adding telemetry.

### Pitfall 4: Null Handling for Partial Failures

**What goes wrong:** Telemetry insert fails due to NOT NULL constraints when request fails partway.
**Why it happens:** Some fields are only populated after certain steps complete.
**How to avoid:** All timing and token columns should be NULLABLE. Only `log_id`, `user_id`, `created_at`, `user_question`, and `is_off_topic` should be NOT NULL.
**Warning signs:** Telemetry inserts fail with constraint violations on error paths.

### Pitfall 5: SQL Fingerprint Collisions Across Different Intents

**What goes wrong:** Two semantically different queries get the same fingerprint.
**Why it happens:** Simple string normalization doesn't understand SQL semantics. E.g., `SELECT * FROM a WHERE x=1` vs `SELECT * FROM a WHERE x=2` have same fingerprint if you strip literals.
**How to avoid:** For this use case, we're NOT stripping literal values -- we're only normalizing whitespace. This means `x=1` and `x=2` have different fingerprints, which is actually correct for LLM-generated SQL where the literal is part of the generation. If pattern analysis shows too many unique fingerprints, consider a more sophisticated normalization in a future iteration.
**Warning signs:** Very high cardinality in fingerprint analysis (may indicate over-specific fingerprints).

## Code Examples

### Complete Telemetry Integration in Pipeline

```typescript
// Source: Derived from existing pipeline.ts with telemetry additions
// supabase/functions/chat/pipeline.ts

import { persistTelemetry, TelemetryRecord } from "./telemetry.ts";

export function runPipeline(input: PipelineInput): Response {
  const { query, userId, conversationId: inputConversationId } = input;
  const progress = createProgressStream();
  const requestStart = performance.now();

  (async () => {
    // Initialize telemetry record with known values
    const telemetry: TelemetryRecord = {
      userId,
      userQuestion: query,
      isOffTopic: false,
    };
    let firstTextTime: number | null = null;

    try {
      // ... existing conversation logic ...
      telemetry.conversationId = conversationId;

      // NL-to-SQL with timing and token capture
      const sqlStart = performance.now();
      const sqlResult = await generateSQL({...});
      telemetry.nlToSqlDurationMs = Math.round(performance.now() - sqlStart);
      telemetry.sqlModel = "gpt-4o-mini";
      telemetry.sqlInputTokens = sqlResult.usage.inputTokens;
      telemetry.sqlOutputTokens = sqlResult.usage.outputTokens;
      telemetry.sqlCachedTokens = sqlResult.usage.cachedTokens;

      if (sqlResult.parsed.offTopic) {
        telemetry.isOffTopic = true;
        telemetry.aiResponse = sqlResult.parsed.redirectMessage;
        // No SQL metrics for off-topic
        progress.sendDone(conversationId!, []);
        return;
      }

      telemetry.generatedSql = sqlResult.parsed.sqlQuery;

      // SQL execution with timing
      const execStart = performance.now();
      const queryResult = await executeWithRLS(...);
      telemetry.sqlExecutionDurationMs = Math.round(performance.now() - execStart);
      telemetry.resultRowCount = queryResult.rows.length;

      // Response generation with TTFB and token capture
      const respStart = performance.now();
      let fullResponseText = "";

      const { responseId, usage: responseUsage } = await generateStreamingResponse({
        ...
        onTextDelta: (delta) => {
          fullResponseText += delta;
          if (firstTextTime === null) {
            firstTextTime = performance.now();
          }
          progress.sendTextDelta(delta);
        },
      });

      telemetry.responseGenerationDurationMs = Math.round(performance.now() - respStart);
      telemetry.ttfbMs = firstTextTime !== null
        ? Math.round(firstTextTime - requestStart)
        : null;
      telemetry.responseModel = "gpt-4o-mini";
      telemetry.responseInputTokens = responseUsage.inputTokens;
      telemetry.responseOutputTokens = responseUsage.outputTokens;
      telemetry.responseCachedTokens = responseUsage.cachedTokens;
      telemetry.responseId = responseId;
      telemetry.aiResponse = cleanContent;
      telemetry.followUpSuggestions = followUps;

      progress.sendDone(conversationId!, followUps);

    } catch (err) {
      telemetry.errorType = determineErrorType(err);
      telemetry.errorMessage = String(err);
      telemetry.failedStep = determineFailedStep(/* track current step */);
      progress.sendError("...");
    } finally {
      progress.close();
      // Fire-and-forget telemetry persistence
      persistTelemetry(telemetry).catch((e) =>
        console.error("[Pipeline] Telemetry persistence failed:", e)
      );
    }
  })();

  return new Response(progress.stream, { headers: createSSEHeaders() });
}
```

### Example Report Queries (for snippets file)

```sql
-- Source: Derived from CONTEXT.md report requirements
-- supabase/snippets/observability_reports.sql

-- 1. Total token cost over time range (calculate from counts)
WITH token_prices AS (
  -- Prices per 1M tokens as of Feb 2026
  SELECT 0.15 AS input_price, 0.60 AS output_price  -- gpt-4o-mini
)
SELECT
  date_trunc('day', created_at) AS day,
  COUNT(*) AS requests,
  SUM(sql_input_tokens + response_input_tokens) AS total_input_tokens,
  SUM(sql_output_tokens + response_output_tokens) AS total_output_tokens,
  SUM(sql_cached_tokens + response_cached_tokens) AS total_cached_tokens,
  -- Calculate cost (cached tokens at 50% discount)
  ROUND(
    SUM(
      ((sql_input_tokens - COALESCE(sql_cached_tokens, 0)) +
       (response_input_tokens - COALESCE(response_cached_tokens, 0))) / 1000000.0 * p.input_price
      + (COALESCE(sql_cached_tokens, 0) + COALESCE(response_cached_tokens, 0)) / 1000000.0 * p.input_price * 0.5
      + (sql_output_tokens + response_output_tokens) / 1000000.0 * p.output_price
    )::numeric, 4
  ) AS estimated_cost_usd
FROM chat_telemetry_log, token_prices p
WHERE created_at >= '2026-01-01' AND created_at < '2026-02-01'
GROUP BY 1, p.input_price, p.output_price
ORDER BY 1;

-- 2. Average latency per step with percentiles
SELECT
  ROUND(AVG(nl_to_sql_duration_ms)) AS avg_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p50_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p95_sql_gen_ms,
  ROUND(PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY nl_to_sql_duration_ms)) AS p99_sql_gen_ms,

  ROUND(AVG(sql_execution_duration_ms)) AS avg_exec_ms,
  ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p50_exec_ms,
  ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY sql_execution_duration_ms)) AS p95_exec_ms,

  ROUND(AVG(response_generation_duration_ms)) AS avg_resp_ms,
  ROUND(AVG(ttfb_ms)) AS avg_ttfb_ms
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND error_type IS NULL;

-- 3. Error rate breakdown
SELECT
  error_type,
  failed_step,
  COUNT(*) AS count,
  ROUND(COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2) AS pct
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND error_type IS NOT NULL
GROUP BY error_type, failed_step
ORDER BY count DESC;

-- 4. Per-user usage and cost
SELECT
  user_id,
  COUNT(*) AS requests,
  SUM(sql_input_tokens + response_input_tokens) AS total_input_tokens,
  COUNT(*) FILTER (WHERE error_type IS NOT NULL) AS errors,
  COUNT(*) FILTER (WHERE is_off_topic) AS off_topic_count
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY user_id
ORDER BY total_input_tokens DESC
LIMIT 50;

-- 5. Top SQL patterns by fingerprint
SELECT
  sql_fingerprint,
  COUNT(*) AS occurrences,
  MIN(generated_sql) AS example_sql,  -- One example
  ROUND(AVG(sql_execution_duration_ms)) AS avg_exec_ms,
  ROUND(AVG(result_row_count)) AS avg_rows
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
  AND sql_fingerprint IS NOT NULL
GROUP BY sql_fingerprint
ORDER BY occurrences DESC
LIMIT 20;

-- 6. Off-topic rate
SELECT
  date_trunc('day', created_at) AS day,
  COUNT(*) AS total,
  COUNT(*) FILTER (WHERE is_off_topic) AS off_topic,
  ROUND(COUNT(*) FILTER (WHERE is_off_topic)::numeric / COUNT(*) * 100, 2) AS off_topic_pct
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY 1
ORDER BY 1;

-- 7. Model comparison (if multiple models used)
SELECT
  sql_model,
  response_model,
  COUNT(*) AS requests,
  ROUND(AVG(nl_to_sql_duration_ms)) AS avg_sql_gen_ms,
  ROUND(AVG(response_generation_duration_ms)) AS avg_resp_ms,
  SUM(sql_input_tokens + response_input_tokens) AS total_input_tokens
FROM chat_telemetry_log
WHERE created_at >= NOW() - INTERVAL '7 days'
GROUP BY sql_model, response_model
ORDER BY requests DESC;
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Normalized steps table (`user_ai_insight_step`) | Denormalized single row per request | Phase 5 decision | Simpler queries, faster aggregations |
| JSONB for token usage | Flat integer columns | Phase 5 decision | SQL-queryable, easier percentile calculations |
| No cached token tracking | Track `input_tokens_details.cached_tokens` | OpenAI Responses API feature | Understand actual costs (cached tokens cheaper) |
| No TTFB metric | Time to First Byte tracked | Phase 5 decision | User-perceived latency visibility |

**Deprecated/outdated:**
- Existing `user_ai_insight` + `user_ai_insight_step` tables: These were built for the older `ai-insights` function. The new `chat_telemetry_log` table follows CONTEXT.md's denormalized design. The old tables can coexist but are not used by the chat function.

## Open Questions

1. **SQL fingerprint normalization strategy**
   - What we know: Simple whitespace normalization + md5 provides grouping
   - What's unclear: Whether to strip literal values (would group `x=1` and `x=2` together)
   - Recommendation: Start without literal stripping. Evaluate fingerprint cardinality in practice. If too many unique fingerprints, add literal normalization in a follow-up.

2. **Telemetry retention strategy**
   - What we know: CONTEXT.md says "Keep indefinitely -- no auto-deletion"
   - What's unclear: Storage costs at scale
   - Recommendation: Implement as specified (no auto-deletion). Monitor storage growth. Can add partitioning or archival later if needed.

3. **Concurrent request handling**
   - What we know: Each request creates its own telemetry record
   - What's unclear: Whether high concurrency could cause insert bottlenecks
   - Recommendation: Start simple. Monitor insert latency in telemetry itself. Can add batching or async queue if needed.

## Sources

### Primary (HIGH confidence)
- Existing codebase: `supabase/functions/chat/pipeline.ts` -- Current pipeline structure, persistence patterns
- Existing codebase: `supabase/functions/ai-insights/agent.ts` -- Timing capture with `performance.now()`, token usage extraction
- Existing codebase: `supabase/migrations/20251224095800_ai_insight_steps.sql` -- Existing logging schema (reference for column types)
- [OpenAI Responses API](https://platform.openai.com/docs/api-reference/responses) -- Usage object structure with `input_tokens`, `output_tokens`, `cached_tokens`
- [PostgreSQL md5()](https://www.postgresql.org/docs/current/functions-string.html#id-1.5.8.10.11) -- Native hashing function

### Secondary (MEDIUM confidence)
- [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) -- Query fingerprinting concepts (normalized form)
- [pganalyze pg_query](https://pganalyze.com/blog/pg-query-2-0-postgres-query-parser) -- AST-based fingerprinting (considered but not used)
- [Supabase Logging Docs](https://supabase.com/docs/guides/telemetry/logs) -- Platform logging patterns

### Tertiary (LOW confidence)
- [OpenAI Community: Token usage with previous_response_id](https://community.openai.com/t/tokens-usage-on-response-api-with-previous-message/1327213) -- Token accumulation behavior
- [OpenAI Community: Cached tokens access](https://community.openai.com/t/how-to-access-cached-tokens-count-from-usage-object/1354192) -- Cached token field access

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- Using existing codebase patterns and native PostgreSQL features
- Architecture: HIGH -- CONTEXT.md provides clear decisions; implementation follows established patterns
- Pitfalls: HIGH -- Based on existing codebase experience and documented API behavior
- Reporting queries: MEDIUM -- Queries are straightforward but may need tuning for performance at scale

**Research date:** 2026-02-03
**Valid until:** 2026-03-05 (30 days -- stable domain, well-established patterns)
