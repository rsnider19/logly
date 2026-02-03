# Phase 5: Observability — Implementation Context

> Decisions from user discussion that guide research and planning.
> These choices are LOCKED — downstream agents should not revisit them.

## Phase Goal

Every AI chat interaction is logged server-side with generated SQL, step durations, and token usage so that cost, quality, and performance can be monitored and reported.

---

## Log Storage Design

### Structure
- **Single denormalized table** — one row per request with all fields as columns
- **Identifiers**: Claude's discretion (user_id + response_id, possibly conversation_id)
- **Retention**: Keep indefinitely — no auto-deletion

### Content Captured
| Field | Decision |
|-------|----------|
| User's question text | Yes — enables quality review |
| AI response text | Yes — full audit trail |
| Generated SQL | Full text + normalized fingerprint hash |
| Query results | Row count only — never store actual data |
| Follow-up suggestions | Yes — track what was offered |
| Error details | Error type + message text |
| Failed step indicator | Yes — know which step failed for partial failures |
| Model name/version | Yes — track OpenAI model used |
| Off-topic flag | Yes — flag when AI detected off-topic and redirected |

### Scope Boundaries
- **Do NOT** distinguish follow-up vs initial questions (treat all the same)
- **Do NOT** log actual query result data (privacy)

### Access Control
- **Admin only** via service role — users cannot see their own telemetry logs

### Indexing
- Primary filters: time range, user_id, error status
- Query fingerprint for pattern grouping

---

## Timing Granularity

### Measurements Captured
| Metric | Storage | Notes |
|--------|---------|-------|
| NL-to-SQL duration | Integer (ms) | Time to generate SQL from natural language |
| SQL execution duration | Integer (ms) | Time to run query against database |
| Response generation duration | Integer (ms) | Time to generate natural language response |
| Time to first byte (TTFB) | Integer (ms) | Latency before user sees any streaming output |
| Request timestamp | Timestamp | When request was received |

### Design Decisions
- **Total duration**: Calculate from parts (no redundant column)
- **Partial failures**: Store timings for completed steps, nulls for incomplete
- **Timezone**: UTC always — convert on display
- **Accuracy**: Trust edge function timestamps (no validation/sanity checks)

---

## Token Tracking

### Per-Request Token Data
| Field | Decision |
|-------|----------|
| SQL generation input tokens | Separate column |
| SQL generation output tokens | Separate column |
| Response generation input tokens | Separate column |
| Response generation output tokens | Separate column |
| Cached tokens (per step) | Track separately from uncached |

### Design Decisions
- **Source of truth**: OpenAI API response `usage` field (not local estimation)
- **Cost calculation**: Not stored — calculate in reports using current prices
- **Storage format**: Separate columns per step (not JSON)
- **Failed calls**: Store nulls if token counts unavailable
- **Streaming**: Claude's discretion on capture timing (typically after stream completes)
- **Alerting**: Not in this phase — just logging

---

## Reporting Queries

### Access Method
- **SQL queries via Supabase dashboard** — no API endpoint needed
- **Example queries**: Document in SQL file in `supabase/` directory

### Core Metrics (matches success criteria)
- Total token cost (calculated from stored counts)
- Average latency per step
- Error rate

### Report Capabilities
| Capability | Decision |
|------------|----------|
| Time range | Flexible (any start/end date) |
| Time granularity | Daily aggregates for trends |
| Per-user breakdown | Yes — see usage and cost per user |
| Latency percentiles | p50, p95, p99 |
| Query fingerprint analysis | Yes — top patterns generated |
| Error breakdown | By error type (timeout, SQL error, rate limit, etc.) |
| Off-topic rate | Track as separate metric |
| Model comparison | Yes — filter/group by model version |

---

## Deferred Ideas

None captured during discussion.

---

## Next Steps

- [ ] Research phase (`/gsd:research-phase 5`)
- [ ] Plan phase (`/gsd:plan-phase 5`)
