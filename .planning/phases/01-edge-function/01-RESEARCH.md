# Phase 1: Edge Function - Research

**Researched:** 2026-02-02
**Domain:** Supabase Edge Functions (Deno/TypeScript), OpenAI Responses API, text-to-SQL pipeline, SSE streaming, Postgres RLS
**Confidence:** HIGH (existing codebase provides proven patterns; key unknowns resolved via official docs)

## Summary

This phase builds a new `chat` Supabase edge function that is architecturally very similar to the existing `ai-insights` function already in the codebase. The existing function provides a proven blueprint: a two-call OpenAI pipeline (NL-to-SQL generation + friendly response composition), SSE streaming via `ReadableStream`, SQL validation via regex, and follow-up context via `previous_response_id`. The new `chat` function will reuse these patterns but with important differences mandated by the CONTEXT.md decisions.

The primary technical challenges are: (1) enforcing RLS on generated SQL queries by switching the Postgres session to the `authenticated` role within a transaction rather than running as the `postgres` admin role, (2) implementing per-user rate limiting via Upstash Redis, (3) applying a statement timeout to generated queries, and (4) refining the SSE event protocol to match the decided-upon event types (`step`, `text_delta`, `response_id`, `error`, `done`).

**Primary recommendation:** Fork the proven patterns from `ai-insights` (pipeline structure, SSE streaming, SQL validation, OpenAI integration) into the new `chat` function, then layer on the three new capabilities: RLS-enforced query execution, Upstash rate limiting, and statement timeout. Use GPT-4o-mini as decided.

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| OpenAI SDK | `npm:openai@4.103.0+` | Responses API calls (SQL generation + response streaming) | Already used in `ai-insights`, official Deno-compatible SDK |
| `jsr:@db/postgres` | latest | Direct Postgres connection for executing generated SQL | Already used in `ai-insights` and other edge functions |
| `jsr:@supabase/supabase-js@2` | `^2.58.0` | Supabase client for auth verification, admin operations | Already in project `deno.json` imports |
| `npm:zod` | latest | Schema validation for OpenAI structured output | Already used in `ai-insights` agent |
| Deno runtime | (built-in) | Edge function runtime, `ReadableStream`, `TextEncoder` | Supabase Edge Functions standard |

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `npm:@upstash/ratelimit` | `^2.0.8` | Per-user rate limiting (sliding window) | Every request before pipeline execution |
| `npm:@upstash/redis` | latest | Redis client for Upstash (rate limit backend) | Dependency of `@upstash/ratelimit` |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Upstash Redis rate limiting | Postgres-based rate counter | DB write on every request adds latency; GET requests on read replicas can't write counters back; Upstash is Supabase's official recommendation |
| `jsr:@db/postgres` for query execution | Supabase PostgREST `.rpc()` | PostgREST can't execute arbitrary SQL; direct connection is required for dynamic generated queries |
| GPT-4o-mini (decided) | GPT-4.1-mini | 4.1-mini has better instruction following and 1M context but is ~2.7x more expensive ($0.40/$1.60 vs $0.15/$0.60 per 1M tokens); user explicitly chose GPT-4o-mini |

### Installation

No npm install needed -- Supabase Edge Functions use Deno imports. Dependencies are declared in the function's `deno.json` or imported inline:

```typescript
import OpenAI from "npm:openai@4.103.0";
import { Client } from "jsr:@db/postgres";
import { Ratelimit } from "npm:@upstash/ratelimit";
import { Redis } from "npm:@upstash/redis";
import { z } from "npm:zod";
```

Environment variables required (add to `supabase/functions/.env`):
```
UPSTASH_REDIS_REST_URL=...
UPSTASH_REDIS_REST_TOKEN=...
```

## Architecture Patterns

### Recommended Project Structure

```
supabase/functions/
├── chat/                         # New edge function
│   ├── index.ts                  # Entry point: auth, rate limit, route to pipeline
│   ├── pipeline.ts               # Two-call pipeline orchestrator (NL→SQL→response)
│   ├── sqlGenerator.ts           # Call 1: NL-to-SQL via OpenAI
│   ├── responseGenerator.ts      # Call 2: Friendly response via OpenAI (streaming)
│   ├── queryExecutor.ts          # SQL execution with RLS + timeout
│   ├── security.ts               # SQL validation + input sanitization
│   ├── rateLimit.ts              # Upstash rate limiting
│   ├── schema.ts                 # Hardcoded DB schema for system prompt
│   ├── streamHandler.ts          # SSE stream utilities
│   ├── prompts.ts                # System prompts (NL-to-SQL + response personality)
│   └── deno.json                 # Function-specific Deno config
├── _utils/                       # Shared utilities (existing)
│   ├── verifyJwt.ts              # JWT auth middleware (reuse)
│   ├── isEntitledTo.ts           # Subscription check (reuse)
│   ├── supabaseAdmin.ts          # Admin client (reuse)
│   └── supabaseClient.ts         # User client (reuse)
└── deno.json                     # Root Deno config
```

### Pattern 1: RLS-Enforced Query Execution via Role Switching

**What:** Execute LLM-generated SQL as the `authenticated` Postgres role with the user's ID set in session, so RLS policies automatically scope results to the user's data.

**When to use:** Every time generated SQL is executed against the database.

**Why this matters:** The existing `ai-insights` function connects via `SUPABASE_DB_URL`, which uses the `postgres` role (admin privileges, RLS bypassed). The `ai-insights` function relies on the LLM to include `WHERE user_id = '<userId>'` in the generated SQL. The new `chat` function must enforce RLS as a security layer so even if the LLM omits the user filter, the user can only see their own data.

**Example:**
```typescript
// Source: https://marmelab.com/blog/2025/12/08/supabase-edge-function-transaction-rls.html
// and https://github.com/orgs/supabase/discussions/30124

import { Client } from "jsr:@db/postgres";

async function executeWithRLS(
  sql: string,
  userId: string,
  timeoutMs: number = 10000,
): Promise<{ rows: unknown[]; truncated: boolean }> {
  const client = new Client(Deno.env.get("SUPABASE_DB_URL"));
  await client.connect();

  try {
    // Begin transaction for SET LOCAL scope
    await client.queryObject("BEGIN");

    // Set statement timeout for this transaction only
    await client.queryObject(`SET LOCAL statement_timeout = '${timeoutMs}ms'`);

    // Switch to authenticated role for RLS enforcement
    await client.queryObject("SET LOCAL ROLE authenticated");

    // Set both JWT claim formats so auth.uid() works correctly
    // auth.uid() checks request.jwt.claim.sub first, then request.jwt.claims->>'sub'
    await client.queryObject(
      `SELECT set_config('request.jwt.claim.sub', '${userId}', true)`
    );
    await client.queryObject(
      `SELECT set_config('request.jwt.claims', '${JSON.stringify({ sub: userId, role: "authenticated" })}', true)`
    );

    // Execute the generated SQL -- RLS policies now filter by auth.uid()
    const result = await client.queryObject(sql);
    const rows = result.rows;

    await client.queryObject("COMMIT");

    const MAX_ROWS = 100;
    return {
      rows: rows.length > MAX_ROWS ? rows.slice(0, MAX_ROWS) : rows,
      truncated: rows.length > MAX_ROWS,
    };
  } catch (err) {
    await client.queryObject("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    await client.end();
  }
}
```

**CRITICAL:** The `userId` value must be sanitized to prevent SQL injection in the `set_config` calls. Use parameterized queries where possible, or validate the UUID format before interpolation. The userId comes from a verified JWT (via `supabaseAdminClient.auth.getClaims`), so it is trusted -- but defensive coding is still recommended.

### Pattern 2: Two-Call OpenAI Pipeline with SSE Streaming

**What:** First OpenAI call generates SQL (non-streaming, structured output). Second call generates a friendly response from the query results (streaming via SSE).

**When to use:** Every chat request.

**Example (pipeline orchestrator):**
```typescript
// Mirrors existing ai-insights/agent.ts pattern
export async function runPipeline(input: PipelineInput): Promise<Response> {
  const progress = createProgressStream();

  (async () => {
    try {
      // Step 1: "Understanding your question..."
      progress.sendStep("Understanding your question...", "start");
      const { sql, conversionId } = await generateSQL(input);
      progress.sendStep("Understanding your question...", "complete");

      // SQL validation (silent -- no step event for user)
      validateSQL(sql);

      // Step 2: "Looking up your data..."
      progress.sendStep("Looking up your data...", "start");
      const { rows, truncated } = await executeWithRLS(sql, input.userId);
      progress.sendStep("Looking up your data...", "complete");

      // Step 3: Stream response (no spinner -- transitions directly to text)
      const { responseId } = await generateStreamingResponse(
        input, rows, truncated, conversionId,
        (delta) => progress.sendTextDelta(delta),
      );

      progress.sendResponseId(responseId);
      progress.sendDone();
    } catch (err) {
      progress.sendError("I ran into an issue. Could you try again?");
    } finally {
      progress.close();
    }
  })();

  return new Response(progress.stream, { headers: sseHeaders() });
}
```

### Pattern 3: SSE Event Protocol (decided format)

**What:** The specific SSE event format as decided in CONTEXT.md.

**Event types and payloads:**
```typescript
// Step progress (start + complete pairs)
{ "type": "step", "name": "Understanding your question...", "status": "start" }
{ "type": "step", "name": "Understanding your question...", "status": "complete" }

// Streaming text (token-by-token from Call 2)
{ "type": "text_delta", "delta": "You logged " }
{ "type": "text_delta", "delta": "**5 runs** " }

// Response ID for follow-ups (dedicated event)
{ "type": "response_id", "responseId": "resp_abc123" }

// Error (user-friendly message)
{ "type": "error", "message": "I ran into an issue..." }

// Done signal (just a completion signal, no metadata)
{ "type": "done" }
```

**Differences from existing `ai-insights` stream:**
- Uses `text_delta` instead of `text` (aligns with CONTEXT.md decision)
- Adds `done` event (not present in existing function)
- Step status uses `start`/`complete` instead of `in_progress`/`complete` (matching CONTEXT.md spinner/checkmark behavior)
- Only 2-3 user-visible steps (vs 4 in `ai-insights`): SQL validation is silent
- Removes `conversion_id` event (CONTEXT.md only mentions `response_id`)

### Pattern 4: Upstash Rate Limiting

**What:** Per-user rate limiting using Upstash Redis sliding window.

**Example:**
```typescript
// Source: https://supabase.com/docs/guides/functions/examples/rate-limiting
import { Ratelimit } from "npm:@upstash/ratelimit";
import { Redis } from "npm:@upstash/redis";

// Create outside handler for connection reuse across warm invocations
const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(), // Uses UPSTASH_REDIS_REST_URL + UPSTASH_REDIS_REST_TOKEN
  limiter: Ratelimit.slidingWindow(20, "1 h"), // 20 requests per hour per user
  analytics: true,
});

async function checkRateLimit(userId: string): Promise<{ allowed: boolean; resetMs?: number }> {
  const { success, reset } = await ratelimit.limit(userId);
  if (!success) {
    return { allowed: false, resetMs: reset };
  }
  return { allowed: true };
}
```

### Pattern 5: Follow-Up Context via `previous_response_id`

**What:** Chain OpenAI Responses API calls using `previous_response_id` for multi-turn context.

**How it works in this pipeline:** The SQL generation call (Call 1) stores its response with `store: true`. The response generation call (Call 2) chains from Call 1 using `previous_response_id`. For follow-up questions, the client sends back the `response_id` from the previous exchange, and Call 1 of the new request chains from it.

**Context passing strategy (Claude's discretion recommendation):**

The existing `ai-insights` function uses two separate `previous_response_id` chains -- one for the SQL agent (`previousConversionId`) and one for the friendly response agent (`previousResponseId`). This is the correct approach because:

1. **SQL agent chain**: Needs to remember what SQL was generated for prior questions to resolve follow-up references ("What about last week?" needs to know the previous query was about runs)
2. **Response agent chain**: Chains from the SQL agent's response in the same turn (Call 2 uses Call 1's responseId as `previous_response_id`), creating a unified context

**Recommended approach:** Keep the existing dual-chain pattern from `ai-insights`:
- Client sends: `{ query, previousResponseId?, previousConversionId? }`
- Call 1 (SQL): Uses `previousConversionId` if provided
- Call 2 (Response): Uses Call 1's responseId as `previous_response_id`
- Response to client: Both `responseId` and `conversionId` for next turn

This way, the SQL agent has conversation context about what was previously asked, and the response agent naturally chains from the SQL context within each turn.

### Anti-Patterns to Avoid

- **Running generated SQL as `postgres` role:** The existing `ai-insights` function does this. The new `chat` function MUST switch to `authenticated` role with RLS. Never trust the LLM to include correct user_id filters.
- **In-memory rate limiting:** Edge functions are stateless across invocations. In-memory counters reset on every cold start. Use Upstash Redis.
- **Blocking on rate limit check after pipeline starts:** Check rate limit BEFORE any OpenAI calls to avoid wasted API spend.
- **Using `SET` instead of `SET LOCAL`:** `SET LOCAL` scopes to the current transaction and is automatically reverted on COMMIT/ROLLBACK. `SET` affects the entire session and could leak to other queries if the connection is reused.
- **Sending technical error messages to user:** All user-facing errors must be friendly. Technical details go to `console.error` only.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Rate limiting | In-memory counter or Postgres-based tracker | `@upstash/ratelimit` with `@upstash/redis` | Atomic operations, works across cold starts, Supabase's official recommendation |
| JWT verification | Manual JWT decode/verify | `supabaseAdminClient.auth.getClaims(token)` | Already implemented in `_utils/verifyJwt.ts`, handles key rotation |
| Subscription gating | Custom entitlement check | `isEntitledTo({ userId, entitlement: "ai-insights" })` | Already implemented, queries RevenueCat entitlements via Postgres function |
| SSE formatting | Manual string concatenation | Dedicated `createProgressStream()` helper | Existing pattern handles buffering, encoding, error-safe enqueueing |
| SQL sanitization | Simple string replacement only | Regex-based keyword blocking + must-start-with-SELECT + injection pattern detection | Existing `security.ts` pattern handles word boundaries, UNION injection, comments, etc. |

**Key insight:** The existing `ai-insights` function has already solved most of the infrastructure problems. The new `chat` function should reuse these patterns rather than inventing new approaches. The only genuinely new components are RLS enforcement on query execution, rate limiting, and statement timeout.

## Common Pitfalls

### Pitfall 1: RLS Not Enforced on Direct Postgres Connections

**What goes wrong:** `SUPABASE_DB_URL` connects as the `postgres` role, which bypasses ALL RLS policies. If you just run `client.queryObject(sql)` without role switching, every user can see every other user's data.
**Why it happens:** The existing `ai-insights` function does this -- it relies on the LLM to add `WHERE user_id = userId` to every query. This works for honest LLM output but provides no defense against prompt injection or LLM errors.
**How to avoid:** Always wrap generated SQL execution in a transaction with `SET LOCAL ROLE authenticated` and `set_config('request.jwt.claim.sub', userId, true)` before executing.
**Warning signs:** Query results include data from multiple users. Missing `WHERE user_id = ...` in generated SQL.

### Pitfall 2: `SET LOCAL` Only Works Inside Transactions

**What goes wrong:** `SET LOCAL` has no effect outside of a `BEGIN...COMMIT/ROLLBACK` block. The role and timeout settings silently do nothing.
**Why it happens:** Postgres documentation states that `SET LOCAL` is only effective within a transaction block.
**How to avoid:** Always wrap query execution in `BEGIN` / `COMMIT` with `ROLLBACK` in catch blocks.
**Warning signs:** RLS appears to not be working. Statement timeout doesn't fire.

### Pitfall 3: auth.uid() Requires Both Claim Formats

**What goes wrong:** `auth.uid()` returns null even after setting the role to `authenticated`.
**Why it happens:** Supabase's `auth.uid()` function uses `coalesce` to check TWO config settings: `request.jwt.claim.sub` (legacy individual claim) and `request.jwt.claims` (JSON blob, modern). If neither is set, `auth.uid()` returns null and all RLS policies using `user_id = auth.uid()` return no rows.
**How to avoid:** Set BOTH `request.jwt.claim.sub` and `request.jwt.claims` before executing queries.
**Warning signs:** Queries return empty results. RLS policies that check `auth.uid()` filter out all rows.

### Pitfall 4: Statement Timeout Value Must Be Transaction-Scoped

**What goes wrong:** Statement timeout set on the session persists beyond the intended query, or doesn't apply at all.
**Why it happens:** `SET statement_timeout` vs `SET LOCAL statement_timeout` have different scopes. In Supabase, `SET LOCAL` inside a function body doesn't work through PostgREST -- but for direct Postgres connections it works fine within a `BEGIN`/`COMMIT` block.
**How to avoid:** Use `SET LOCAL statement_timeout = 'Xms'` AFTER `BEGIN` and BEFORE the query. Recommended value: 10000ms (10 seconds) -- generous enough for complex aggregations but kills runaway queries before they hurt the database.
**Warning signs:** Queries running indefinitely. Database CPU spikes.

### Pitfall 5: SSE Connection Blocking in Supabase Edge Functions

**What goes wrong:** One active SSE connection blocks other edge function calls.
**Why it happens:** Known Supabase issue where HTTP/1 proxy limits concurrent connections per function. Reported in [GitHub Issue #12474](https://github.com/supabase/supabase/issues/12474).
**How to avoid:** Keep SSE connections short-lived (the pipeline should complete in under 30 seconds). Close streams promptly in `finally` blocks. This is unlikely to be a problem for this use case since responses are not long-lived connections.
**Warning signs:** Second chat request hangs while first is still streaming.

### Pitfall 6: Rate Limit Check Still Invokes the Edge Function

**What goes wrong:** Rate-limited requests still consume edge function invocations (billed).
**Why it happens:** Rate limiting happens INSIDE the edge function, not before it. Supabase doesn't expose Kong gateway rate limiting to users.
**How to avoid:** Accept this as a known limitation. The Upstash Redis call is fast (~1-5ms) and cheap. Return 429 immediately to minimize compute time. For extreme abuse, consider Cloudflare in front.
**Warning signs:** High edge function invocation counts despite low actual usage.

### Pitfall 7: OpenAI `previous_response_id` with Different Models

**What goes wrong:** Follow-up context may not work correctly when chaining between different model versions.
**Why it happens:** OpenAI's `previous_response_id` stores the full conversation context server-side. Chaining from a response created by Model A to a new request using Model B may produce unexpected behavior.
**How to avoid:** Use the same model (GPT-4o-mini) for both Call 1 and Call 2. The user decided on GPT-4o-mini for both, so this is already handled.
**Warning signs:** Follow-up responses lose context or produce irrelevant answers.

### Pitfall 8: Prompt Injection via Generated SQL

**What goes wrong:** User crafts input that tricks the LLM into generating malicious SQL (DROP TABLE, data exfiltration from other schemas, etc.).
**Why it happens:** LLMs are fundamentally susceptible to prompt injection -- there is no perfect defense.
**How to avoid:** Layer multiple defenses:
  1. **Input sanitization**: Strip known adversarial phrases ("ignore previous instructions"), escape special characters
  2. **Hardened system prompt**: Clear constraints on SELECT-only, specific tables, user scoping
  3. **SQL validation (regex)**: Must start with SELECT, block dangerous keywords (DROP, DELETE, INSERT, UPDATE, ALTER, TRUNCATE, CREATE, GRANT, REVOKE, EXEC, INTO, COPY), block injection patterns (semicolons, comments, UNION SELECT, hex escapes)
  4. **RLS enforcement**: Even if the LLM generates a query that omits user filtering, RLS policies will scope results to the authenticated user
  5. **Statement timeout**: Limits damage from expensive queries
**Warning signs:** SQL validation catching forbidden keywords. Unusual query patterns in logs.

## Code Examples

### Complete Entry Point Pattern

```typescript
// Source: Derived from existing ai-insights/index.ts pattern
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { AuthMiddleware } from "../_utils/verifyJwt.ts";
import { isEntitledTo } from "../_utils/isEntitledTo.ts";
import { checkRateLimit } from "./rateLimit.ts";
import { runPipeline } from "./pipeline.ts";

Deno.serve((r) =>
  AuthMiddleware(r, async (req, userId) => {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    if (!userId) {
      return Response.json({ message: "Unauthorized" }, { status: 401 });
    }

    // Subscription check
    const isEntitled = await isEntitledTo({ userId, entitlement: "ai-insights" });
    if (!isEntitled) {
      return Response.json(
        { message: "Forbidden", code: "premium_required" },
        { status: 403 },
      );
    }

    // Rate limit check (before any OpenAI calls)
    const rateCheck = await checkRateLimit(userId);
    if (!rateCheck.allowed) {
      return Response.json(
        { message: "You've been busy! Give me a moment to catch up. Try again shortly." },
        { status: 429 },
      );
    }

    // Parse body
    let query: string;
    let previousResponseId: string | undefined;
    let previousConversionId: string | undefined;
    try {
      const body = await req.json();
      query = body.query;
      previousResponseId = body.previousResponseId;
      previousConversionId = body.previousConversionId;

      if (!query || typeof query !== "string") {
        return Response.json({ error: "Missing or invalid 'query' field" }, { status: 400 });
      }
    } catch {
      return Response.json({ error: "Invalid JSON body" }, { status: 400 });
    }

    return runPipeline({ query, userId, previousResponseId, previousConversionId });
  })
);
```

### Input Sanitization Pattern

```typescript
// Defense layer 1: Sanitize user input before it reaches the LLM
const ADVERSARIAL_PATTERNS = [
  /ignore\s+(all\s+)?previous\s+instructions/i,
  /ignore\s+(all\s+)?above/i,
  /disregard\s+(all\s+)?previous/i,
  /forget\s+(all\s+)?instructions/i,
  /you\s+are\s+now/i,
  /new\s+instructions?:/i,
  /system\s*:\s*/i,
  /\bprompt\b.*\binjection\b/i,
  /act\s+as\s+(a\s+)?different/i,
  /override\s+(your\s+)?instructions/i,
];

function sanitizeUserInput(input: string): string {
  let sanitized = input.trim();

  // Remove potential encoding tricks
  sanitized = sanitized.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F]/g, ""); // Control chars

  // Check for adversarial patterns (log but don't block -- redirect gracefully)
  for (const pattern of ADVERSARIAL_PATTERNS) {
    if (pattern.test(sanitized)) {
      console.warn(`[Sanitize] Potential prompt injection detected: ${pattern}`);
      // Don't block -- let the hardened system prompt handle redirection
      // But strip the adversarial portion
      sanitized = sanitized.replace(pattern, "");
    }
  }

  // Limit length (prevent token-heavy inputs)
  const MAX_INPUT_LENGTH = 500;
  if (sanitized.length > MAX_INPUT_LENGTH) {
    sanitized = sanitized.substring(0, MAX_INPUT_LENGTH);
  }

  return sanitized;
}
```

### Friendly Rate Limit Response Pattern

```typescript
// When rate limit is exceeded, return a warm SSE response (not a JSON error)
// This allows the client to display it in the chat like a normal message
function createRateLimitResponse(): Response {
  const progress = createProgressStream();

  // Send as a friendly chat message, not a cold HTTP error
  setTimeout(() => {
    progress.sendError(
      "You've been busy! I need a moment to catch my breath. " +
      "Try again in a few minutes -- I'll be ready to help! \\ud83d\\ude0a"
    );
    progress.close();
  }, 0);

  return new Response(progress.stream, {
    headers: createSSEHeaders(),
  });
}
```

### Statement Timeout Value Recommendation

```typescript
// 10 seconds: generous enough for complex JOINs and aggregations across
// large datasets, but kills genuinely runaway queries before they impact
// database performance. The existing ai-insights function has no timeout
// at all, which is a risk.
const QUERY_TIMEOUT_MS = 10_000;
```

**Rationale for 10 seconds:**
- Simple COUNT queries: ~50-200ms
- Multi-table JOINs with aggregation: ~500ms-3s
- Complex date-range aggregations on large datasets: ~2-5s
- Anything over 10s is likely a pathological query from the LLM
- Supabase's default dashboard timeout is 15s; 10s is safely under that

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| OpenAI Chat Completions API (manual conversation management) | OpenAI Responses API with `previous_response_id` | March 2025 | Server-managed context, lower cost via caching |
| GPT-4o-mini as cheapest capable model | GPT-4.1-mini available (better instruction following, 1M context) | April 2025 | User chose GPT-4o-mini; GPT-4.1-mini is 2.7x more expensive |
| Supabase JWT verification via symmetric secret | Supabase Auth `getClaims()` with asymmetric keys | 2025 | Already adopted in project's `verifyJwt.ts` |
| `request.jwt.claim.sub` (individual claims) | `request.jwt.claims` (full JSON blob) | PostgREST v9+ | Must set BOTH for backward compatibility with `auth.uid()` |

**Deprecated/outdated:**
- OpenAI Assistants API: Being retired in first half of 2026. The project already uses the Responses API, which is the replacement.
- `getUserId()` in `_utils/getUserId.ts`: Marked as deprecated in the codebase. Uses unverified JWT decode. The `AuthMiddleware` / `authMiddleware` with `getClaims()` is the correct approach.

## Open Questions

1. **Concurrent SSE connection limits**
   - What we know: Supabase has a known issue where one SSE connection can block others (HTTP/1 proxy limitation). This was reported in GitHub Issue #12474.
   - What's unclear: Whether this is still an issue in 2026 or if Supabase has moved to HTTP/2.
   - Recommendation: Accept the risk for now. Chat interactions are short-lived (< 30s). Monitor in production. If blocking occurs, consider deploying the chat function to Deno Deploy directly.

2. **`previous_response_id` reliability**
   - What we know: Some developers report "conversation not found" errors when using `previous_response_id` with `store: true`. The existing `ai-insights` function uses this successfully.
   - What's unclear: How often these errors occur and under what conditions.
   - Recommendation: Handle gracefully -- if `previous_response_id` fails, fall back to a fresh context and log the error. The user will get a less-contextualized but still valid response.

3. **Fine-tuned model vs GPT-4o-mini base**
   - What we know: The existing `ai-insights` uses a fine-tuned GPT-4.1-mini model (`ft:gpt-4.1-mini-2025-04-14:logly-llc::CwW7bj3O`). The user decided "GPT-4o-mini for both SQL generation and response composition."
   - What's unclear: Whether "GPT-4o-mini" means the base model or whether the user expects fine-tuning. The existing function uses a fine-tuned model for better SQL accuracy.
   - Recommendation: Start with base `gpt-4o-mini` as decided. The schema and instructions in the system prompt should provide sufficient accuracy. Fine-tuning can be added later if SQL quality is insufficient. Use the same COMPRESSED_SCHEMA from `ai-insights/schema.ts`.

4. **Off-topic question detection**
   - What we know: CONTEXT.md says "Off-topic questions get a gentle redirect." This needs to be implemented in the system prompt or as a separate classification step.
   - What's unclear: Whether this should be a separate OpenAI call or handled by the SQL generation prompt itself.
   - Recommendation: Handle in the SQL generation system prompt. Instruct the model to return a special "off_topic" flag in the JSON response instead of SQL when the question is not about Logly data. This avoids an extra API call.

## Sources

### Primary (HIGH confidence)
- Existing codebase: `supabase/functions/ai-insights/` -- Complete working implementation of NL-to-SQL pipeline with SSE streaming
- Existing codebase: `supabase/functions/_utils/` -- Auth, entitlement checking, Supabase client patterns
- Existing codebase: `supabase/migrations/` -- RLS policies on all user-scoped tables using `auth.uid()`
- [Supabase Rate Limiting Docs](https://supabase.com/docs/guides/functions/examples/rate-limiting) -- Official Upstash integration guide
- [Supabase Timeouts Docs](https://supabase.com/docs/guides/database/postgres/timeouts) -- `SET LOCAL statement_timeout` patterns
- [OpenAI Responses API Reference](https://platform.openai.com/docs/api-reference/responses/create) -- `previous_response_id`, `store`, streaming
- [OpenAI Conversation State Guide](https://platform.openai.com/docs/guides/conversation-state) -- Multi-turn context patterns

### Secondary (MEDIUM confidence)
- [Marmelab: Transactions and RLS in Supabase Edge Functions](https://marmelab.com/blog/2025/12/08/supabase-edge-function-transaction-rls.html) -- RLS enforcement via role switching in transactions
- [GitHub Discussion #30124: Run queries as authenticated user](https://github.com/orgs/supabase/discussions/30124) -- `set_config('request.jwt.claims', ...)` pattern
- [Supabase Postgres Roles Docs](https://supabase.com/docs/guides/database/postgres/roles) -- `authenticated` role, RLS bypass explanation
- [Upstash Ratelimit Getting Started](https://upstash.com/docs/redis/sdks/ratelimit-ts/gettingstarted) -- Sliding window, Deno compatibility
- [OWASP Prompt Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/LLM_Prompt_Injection_Prevention_Cheat_Sheet.html) -- Input sanitization patterns

### Tertiary (LOW confidence)
- [GitHub Issue #12474: SSE connection blocking](https://github.com/supabase/supabase/issues/12474) -- May be resolved; needs empirical testing
- [OpenAI Community: previous_response_id reliability](https://community.openai.com/t/responses-api-question-about-managing-conversation-state-with-previous-response-id/1141633) -- Anecdotal reports, not confirmed

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- Existing codebase proves the entire stack works; only adding Upstash Redis
- Architecture: HIGH -- Pipeline pattern proven in `ai-insights`; RLS pattern documented by Supabase and community
- Pitfalls: HIGH -- Most pitfalls identified from official docs and existing codebase analysis
- Rate limiting: MEDIUM -- Upstash is Supabase's official recommendation but not yet used in this project
- RLS via role switching: MEDIUM -- Pattern documented in multiple sources but not yet tested in this specific codebase

**Research date:** 2026-02-02
**Valid until:** 2026-03-04 (30 days -- stable domain, libraries well-established)
