# Domain Pitfalls: AI Chat with Text-to-SQL

**Domain:** Natural language to SQL chat in a mobile app (Flutter + Supabase + OpenAI)
**Researched:** 2026-02-02
**Confidence:** HIGH (based on existing codebase analysis + verified external research)

---

## Critical Pitfalls

Mistakes that cause rewrites, data breaches, or fundamental architecture failures.

---

### Pitfall 1: Regex-Only SQL Validation Is Bypassable

**What goes wrong:** The current `security.ts` uses a blocklist of dangerous keywords (`DROP`, `DELETE`, `INSERT`, etc.) and regex patterns to validate generated SQL. Attackers (or adversarial prompts) can bypass regex-based validation through encoding tricks, comment injection within keywords, case manipulation, Unicode homoglyphs, or canonicalization flaws. OWASP explicitly documents dozens of WAF/regex bypass techniques that work against keyword blocklists.

**Why it happens:** Regex validation feels complete because it catches obvious attacks. But SQL is a context-free grammar -- regex cannot fully parse it. The blocklist approach has a fundamental asymmetry: defenders must enumerate every dangerous pattern, while attackers only need to find one that was missed.

**Consequences:**
- A crafted prompt could trick the LLM into generating SQL that passes regex validation but performs unauthorized operations
- The current `INTO` keyword block prevents `SELECT INTO` but the blocklist is non-exhaustive -- Postgres has functions like `pg_read_file()`, `pg_sleep()`, or `lo_export()` that could be exploited without triggering any blocked keyword
- Information disclosure via error messages or timing attacks even within SELECT-only queries

**Warning signs:**
- Security audit reveals gaps in the blocked keyword list
- Generated SQL contains Postgres-specific functions not in the blocklist
- Any query that uses string concatenation or dynamic function calls

**Prevention:**
1. **Defense in depth, not defense in one layer.** Regex is one layer, not THE layer. Keep it, but do not rely on it alone.
2. **Create a dedicated read-only Postgres role** with SELECT-only permissions on specific tables. Execute all AI-generated SQL through this role. This is the single most impactful security measure -- even if validation is completely bypassed, the role cannot modify data.
3. **Allowlist tables and columns** rather than blocklisting keywords. Parse the generated SQL with a proper SQL parser (e.g., `pgsql-parser` or Postgres `EXPLAIN` dry-run) and verify all referenced tables/columns exist in the known schema.
4. **Set `statement_timeout`** on the read-only role (e.g., 5 seconds) to prevent resource exhaustion via expensive queries like cartesian joins.
5. **Deny access to system catalogs** (`pg_catalog`, `information_schema`) and dangerous functions (`pg_read_file`, `pg_sleep`, `lo_export`, `dblink`) on the read-only role.

**Phase:** Must be addressed in the very first phase (security foundation), before any generated SQL touches production data.

**Confidence:** HIGH -- OWASP documentation, PortSwigger research, and multiple security advisories confirm regex bypass is well-documented and practical.

**Sources:**
- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [PortSwigger: SQL Injection Bypassing Common Filters](https://portswigger.net/support/sql-injection-bypassing-common-filters)
- [OWASP: SQL Injection Bypassing WAF](https://owasp.org/www-community/attacks/SQL_Injection_Bypassing_WAF)

---

### Pitfall 2: Cross-User Data Leakage via LLM-Generated SQL

**What goes wrong:** The current system injects `[user_id: abc-123]` into the prompt and relies on the fine-tuned model to include `WHERE user_id = '...'` in every query. If the model forgets, hallucinates a different user_id, or the user crafts a prompt that tricks the model into omitting the filter, one user's query could return another user's data. The raw `user_id` is also embedded directly in the SQL as a string literal, not as a parameterized value.

**Why it happens:** The LLM is probabilistic. Even with fine-tuning and low temperature (0.1), there is no guarantee that every generated query will include the user_id filter. The training data uses `abc-123` as a placeholder, which means the model learned a pattern, not a strict rule. Edge cases (complex multi-table joins, subqueries, CTEs) increase the probability of the filter being dropped.

**Consequences:**
- Complete data breach -- User A sees User B's activity data
- Privacy violation with potential legal implications (GDPR, CCPA)
- Loss of user trust, app store removal risk

**Warning signs:**
- Generated SQL that queries `user_activity` without a `WHERE user_id =` clause
- Follow-up questions where context confusion causes the model to reference a different user
- Queries involving subqueries or CTEs where the inner query lacks user scoping

**Prevention:**
1. **Never rely on the LLM for user scoping.** Enforce user isolation at the database level using PostgreSQL Row-Level Security (RLS) policies on all user-scoped tables (`user_activity`, `user_activity_detail`, `user_activity_sub_activity`).
2. **Set the user context as a session variable** before executing the generated SQL: `SET app.current_user_id = '<authenticated_user_id>'`. Have RLS policies reference `current_setting('app.current_user_id')` rather than relying on the SQL query itself.
3. **Post-generation validation:** After the LLM generates SQL, programmatically verify that every reference to `user_activity` (and other user-scoped tables) includes the correct `user_id` filter. Reject the query if not.
4. **Strip user_id from SQL output columns** -- the current `NL_TO_SQL_INSTRUCTIONS` says "Never expose user_id," but this should be enforced programmatically, not just instructed.

**Phase:** Must be addressed in the first phase alongside the read-only role. RLS policies are the foundation of multi-tenant security.

**Confidence:** HIGH -- This is verified as a critical risk by both the existing codebase analysis (user_id is passed as a string literal in the prompt) and ICSE 2025 research on P2SQL attacks.

**Sources:**
- [Supabase: Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Common Postgres RLS Footguns](https://www.bytebase.com/blog/postgres-row-level-security-footguns/)
- [ICSE 2025: Prompt-to-SQL Injections in LLM-Integrated Web Applications](https://dl.acm.org/doi/10.1109/ICSE55347.2025.00007)

---

### Pitfall 3: Silent Wrong Results (Queries That Execute But Return Incorrect Data)

**What goes wrong:** The most dangerous failure mode in text-to-SQL is not a query that errors out -- it is a query that runs successfully but returns wrong data. The user asks "How many times did I run this week?" and gets `0` because the LLM used the wrong join condition, referenced a non-existent column that Postgres resolved against an outer query, or misinterpreted "this week" as starting on Monday instead of Sunday.

**Why it happens:**
- **Hallucinated column/table names:** The LLM generates column names that do not exist. Postgres may resolve these against outer queries in subqueries (correlated subquery resolution), returning empty results without any error.
- **Semantic misinterpretation:** "This week" could mean different things. "Running" could match "Running Errands" if FTS is too broad. "How much did I exercise?" requires understanding which categories count as exercise.
- **Aggregation errors:** The LLM applies `COUNT`, `AVG`, `SUM` with incorrect `GROUP BY` or incorrect `JOIN` multiplicity, inflating or deflating numbers silently.
- **Date/time ambiguity:** "Last month" from February 1 means January. "Last 30 days" means something different. The user may not realize the distinction.

**Consequences:**
- User makes decisions based on wrong data (e.g., "I ran 0 times this week" when they actually ran 3 times)
- User loses trust in the AI feature, perceives it as useless
- No error signal -- the user may never realize the answer was wrong
- Potential health/safety implications if user acts on incorrect fitness data

**Warning signs:**
- Queries returning empty results when the user clearly has data
- Inconsistent answers for semantically similar questions
- Numbers that seem implausibly high or low
- User reports that answers "don't match what I see in my history"

**Prevention:**
1. **Result sanity checks:** After query execution, validate that results are plausible. If a user asks about their activities and gets 0 rows, check whether they have ANY activities logged. If they do, the query likely has a bug -- surface uncertainty to the user ("I wasn't able to find matching data -- you might want to try rephrasing your question").
2. **Schema validation of generated SQL:** Parse the SQL and verify all table names and column names against the known schema before execution. Reject queries that reference non-existent columns.
3. **Query explanation in the response prompt:** Pass the generated SQL to the response model so it can cross-reference the query logic with the user's question and flag potential mismatches.
4. **EXPLAIN analysis:** Run `EXPLAIN` on the generated query to verify the query plan makes sense (e.g., detects cartesian products, missing index usage).
5. **User feedback mechanism:** Allow users to thumbs-down responses. Track which query types produce negative feedback to identify systematic errors.
6. **Monitoring dashboard:** Log all generated SQL, results, and user feedback. Periodically audit to find patterns of silent failures.

**Phase:** Sanity checks and schema validation should be in Phase 1. User feedback and monitoring dashboard in Phase 2.

**Confidence:** HIGH -- Google Cloud, AWS, and multiple academic papers identify silent wrong results as the primary challenge in production text-to-SQL systems.

**Sources:**
- [Google Cloud: The Six Failures of Text-to-SQL](https://medium.com/google-cloud/the-six-failures-of-text-to-sql-and-how-to-fix-them-with-agents-ef5fd2b74b68)
- [AWS: Enterprise-grade NL-to-SQL Generation](https://aws.amazon.com/blogs/machine-learning/enterprise-grade-natural-language-to-sql-generation-using-llms-balancing-accuracy-latency-and-scale/)
- [The Silent SQL Bug: When An Invalid Column Name Doesn't Throw An Error](https://medium.com/learning-sql/the-silent-sql-bug-when-an-invalid-column-name-doesnt-throw-an-error-b5c9277bc68a)

---

### Pitfall 4: Fine-Tuned Model Drift When Schema Changes

**What goes wrong:** The current system uses a fine-tuned GPT-4.1-mini model (`ft:gpt-4.1-mini-2025-04-14:logly-llc::CwW7bj3O`) trained on the current schema. When the database schema evolves (new tables, renamed columns, new activity types, new detail types), the fine-tuned model does not automatically learn about these changes. It will continue generating SQL against the old schema, producing errors or -- worse -- silently wrong results.

**Why it happens:** Fine-tuning bakes schema knowledge into model weights. The compressed schema is in the system prompt (`NL_TO_SQL_INSTRUCTIONS`), but the model's learned SQL patterns are frozen at training time. Google Cloud explicitly warns that "keeping up with schema changes through fine-tuning alone is difficult and cost-prohibitive." Studies show 91% of ML models experience degradation over time, and fine-tuned models can see error rates jump 35% on new data within 6 months.

**Consequences:**
- New features/tables are invisible to the AI chat (e.g., adding a "mood" tracking feature but the model never queries mood data)
- Schema migrations that rename columns cause query errors
- Gradual accuracy degradation that is hard to detect without monitoring
- Expensive and time-consuming retraining cycle every time the schema changes

**Warning signs:**
- Increase in SQL execution errors after a migration
- User questions about new features returning "I couldn't find that data"
- Accuracy metrics declining over time without prompt changes
- Training data uses column names that no longer exist

**Prevention:**
1. **Schema-in-prompt as primary, fine-tuning as secondary:** The current `COMPRESSED_SCHEMA` in the system prompt is good. Ensure the model relies primarily on the prompt schema rather than memorized patterns. When the schema changes, update the prompt immediately.
2. **Automated schema sync:** Create a CI/CD step that regenerates `COMPRESSED_SCHEMA` from the live database schema whenever a migration is applied. Fail the build if the schema diverges from what the prompt contains.
3. **Training data versioning:** Tag training data with the schema version it was created for. When the schema changes significantly, create incremental training batches (the project already does this with `nl_to_sql_gaps_batch1/2/3.jsonl`) and retrain.
4. **Monitoring with automated alerts:** Track SQL error rates and empty-result rates over time. Set alerts when these metrics spike (likely indicates schema drift).
5. **Consider hybrid approach:** Use the fine-tuned model for common query patterns but fall back to a base model with full schema context for novel queries. This reduces retraining frequency.

**Phase:** Schema sync automation should be built in Phase 1. Monitoring and retraining pipeline in Phase 2.

**Confidence:** HIGH -- Google Cloud blog, MIT research on model degradation, and direct observation of the existing training data batches confirm this is a real and ongoing maintenance burden.

**Sources:**
- [Google Cloud: Techniques for Improving Text-to-SQL](https://cloud.google.com/blog/products/databases/techniques-for-improving-text-to-sql)
- [AI Model Drift & Retraining Guide](https://smartdev.com/ai-model-drift-retraining-a-guide-for-ml-system-maintenance/)
- [Text-to-SQL Comparison of LLM Accuracy in 2026](https://research.aimultiple.com/text-to-sql/)

---

## Moderate Pitfalls

Mistakes that cause degraded UX, cost overruns, or significant technical debt.

---

### Pitfall 5: Latency Death by Two LLM Round Trips

**What goes wrong:** The pipeline requires two sequential LLM calls: NL-to-SQL conversion (non-streamable, must complete before SQL execution) then response generation (streamable). On mobile networks, this creates 3-8 seconds of perceived latency before the user sees any response text. Research shows users expect sub-2-second responses and abandon after 5-10 seconds.

**Why it happens:** The architecture is inherently sequential: you cannot generate a friendly response until you have query results, and you cannot get query results until you have SQL. The first LLM call (NL-to-SQL) must complete fully before SQL execution begins, creating a blocking step. The existing streaming of intermediate "step" messages (e.g., "Reading through your Logly") helps but does not fundamentally solve the wait.

**Consequences:**
- Users perceive the feature as slow and stop using it
- Mobile network variability amplifies the problem (3G/rural connections add 1-3 seconds per round trip)
- Battery drain from long-running network connections
- Supabase Edge Function idle timeout (150 seconds) could be hit for complex queries on slow networks

**Warning signs:**
- User engagement metrics showing drop-off after first few uses
- P95 latency exceeding 8 seconds
- App reviews mentioning "slow AI" or "takes forever"
- Edge function timeout errors in logs

**Prevention:**
1. **Stream intermediate artifacts to the client** -- the current step-progress SSE messages are good. Enhance them with specific progress ("Found 12 matching activities...") to give users confidence something is happening.
2. **Optimize the NL-to-SQL model for speed:** The fine-tuned GPT-4.1-mini is already a good choice. Ensure `max_output_tokens` is set conservatively (currently 250, which is appropriate). Consider reducing system prompt token count further.
3. **Compress query results before sending to response model:** The current `jsonToCsv` conversion is smart. Consider further compression for large result sets -- only send the columns and aggregations relevant to the user's question.
4. **Consider combining into a single LLM call** for simple queries: If the query is simple enough (e.g., "How many times did I run this week?"), a single model call could generate both SQL and a friendly response template, with the actual number filled in post-execution.
5. **Connection warmup:** Keep the Supabase Edge Function warm to avoid cold start latency. Use periodic pings or Supabase's always-on functions feature if available.
6. **Show previous chat messages immediately** -- do not wait for the new response to render the existing conversation history. Load it from local cache.

**Phase:** Basic streaming is already implemented. Latency optimization should be ongoing across all phases but the single-call optimization could be a Phase 2 enhancement.

**Confidence:** HIGH -- Multiple sources confirm that 2-LLM-call architectures are a known latency bottleneck. The Waii blog specifically documents cutting SQL response times in half by restructuring the pipeline.

**Sources:**
- [OpenAI: Latency Optimization](https://platform.openai.com/docs/guides/latency-optimization)
- [Waii: How We Cut SQL Response Times in Half](https://blog.waii.ai/large-latency-models-how-we-cut-sql-response-times-in-half-ea8073689e09)
- [Snowflake: Real-Time Text-to-SQL](https://www.snowflake.com/en/engineering-blog/real-time-text-to-sql-snowflake-intelligence/)

---

### Pitfall 6: Unbounded OpenAI API Costs Per User

**What goes wrong:** Each chat message costs ~$0.003-$0.01 (two LLM calls with fine-tuned model + base model). A power user sending 100 messages per day costs $0.30-$1.00/day. With a pro subscription likely priced at $5-$10/month, a handful of heavy users can make the feature unprofitable. Worse, prompt injection attacks or automated abuse can generate massive bills.

**Why it happens:** The current implementation has no per-user rate limiting, no per-message cost tracking, and no daily/monthly message caps. The OpenAI API bills per-token with no user-level budget controls. The `store: true` flag on OpenAI responses also incurs storage costs.

**Consequences:**
- A single abusive user could generate hundreds of dollars in API costs
- Feature becomes unprofitable even with pro subscription gate
- Unexpected billing spikes with no early warning
- Denial-of-wallet attack if someone scripts repeated API calls

**Warning signs:**
- Monthly OpenAI bill exceeding projections
- Individual users with 100+ messages per day
- Token usage spikes without corresponding user growth
- Repeated identical or near-identical queries from single user

**Prevention:**
1. **Implement per-user message rate limits:** Daily cap (e.g., 50 messages/day for pro users) enforced server-side in the edge function. Return a clear message when the limit is hit.
2. **Track token usage per user:** Store `promptTokens` and `completionTokens` from each response (the existing `persistInsight` already captures this) and aggregate per user per day/month.
3. **Set OpenAI budget alerts:** Configure monthly budget caps and email alerts in OpenAI billing settings at 50%, 80%, and 100% thresholds.
4. **Implement request deduplication:** If a user sends the same question twice within a short window, return the cached response instead of making new LLM calls.
5. **Consider tiered limits:** Free tier gets 5 messages/day as a teaser, pro gets 50, with clear messaging about limits.
6. **Token-based limits over message-based:** Some queries consume 10x more tokens than others. Consider capping total tokens per user per day rather than just message count.

**Phase:** Rate limiting should be in Phase 1. Cost monitoring dashboard in Phase 2.

**Confidence:** HIGH -- OpenAI's own documentation recommends per-user rate limiting and budget alerts. The existing `persistInsight` function already captures usage data, making implementation straightforward.

**Sources:**
- [OpenAI: Rate Limits](https://platform.openai.com/docs/guides/rate-limits)
- [Best Practices for AI API Cost & Throughput Management 2025](https://skywork.ai/blog/ai-api-cost-throughput-pricing-token-math-budgets-2025/)
- [OpenAI: Managing Costs](https://platform.openai.com/docs/guides/realtime-costs)

---

### Pitfall 7: Multi-Turn Context Window Exhaustion

**What goes wrong:** The current pipeline uses OpenAI's `previous_response_id` for multi-turn context, which lets OpenAI manage conversation history server-side. However, as conversations grow long, the accumulated context can exceed model context windows, degrade response quality ("lost in the middle" effect), or significantly increase token costs since the entire conversation history is sent as input tokens for each new message.

**Why it happens:** LLMs are stateless. The `previous_response_id` mechanism chains responses, but each new request includes all prior context. After 10-20 exchanges, the context can reach 10,000+ tokens, with most of that being irrelevant history. Research shows LLMs exhibit "primacy and recency bias" -- they attend more to the beginning and end of the context, losing important details in the middle.

**Consequences:**
- Follow-up questions lose context from earlier in the conversation
- Increasing cost per message as conversation grows (linear token increase)
- Eventual context window overflow causing errors
- Model confused by contradictory or irrelevant historical context

**Warning signs:**
- Follow-up questions getting worse answers as conversation grows
- Token usage per message increasing significantly over conversation length
- Users starting new conversations frequently (indicates follow-ups are not working)
- Model "forgetting" what was discussed 5+ messages ago

**Prevention:**
1. **Implement conversation length limits:** Cap conversations at 20-30 messages and prompt the user to start a new conversation with a summary.
2. **Separate SQL agent and response agent context:** The current dual `previous_response_id` / `previous_conversion_id` approach is smart -- keep the SQL generation context chain separate from the response chain. This is already partially implemented.
3. **Summarize older context:** After N messages, summarize the conversation and replace older messages with the summary. This preserves context while reducing tokens.
4. **Clear context on topic change:** If the user asks about something completely unrelated to the previous question, consider starting a fresh context chain rather than accumulating irrelevant history.
5. **Monitor token usage per turn:** Alert when a single conversation's cumulative token usage exceeds thresholds.

**Phase:** Basic conversation limits in Phase 1 (chat UI). Context management optimization in Phase 2.

**Confidence:** MEDIUM -- The `previous_response_id` mechanism is managed by OpenAI, which likely handles some context management internally. The exact behavior of context accumulation with this API needs empirical testing.

**Sources:**
- [Context Window Management: Strategies for Long-Context AI Agents](https://www.getmaxim.ai/articles/context-window-management-strategies-for-long-context-ai-agents-and-chatbots/)
- [OpenAI Cookbook: Session Memory Management](https://cookbook.openai.com/examples/agents_sdk/session_memory)
- [Managing Chat History for LLMs (Semantic Kernel)](https://devblogs.microsoft.com/semantic-kernel/managing-chat-history-for-large-language-models-llms/)

---

### Pitfall 8: SSE Stream Fragility on Mobile Networks

**What goes wrong:** The current SSE (Server-Sent Events) streaming implementation has no reconnection logic, no event IDs, and no mechanism for resuming a dropped stream. When a mobile user passes through a tunnel, switches from WiFi to cellular, or iOS suspends the app in the background, the stream silently dies. The user sees a partial response or a loading spinner that never resolves.

**Why it happens:** SSE has built-in reconnection in browser `EventSource` implementations, but the Flutter HTTP client does not get this for free. The current `createProgressStream` does not emit event IDs, which means even if the client did reconnect, the server has no way to resume from where it left off. iOS aggressively suspends background network connections to conserve battery.

**Consequences:**
- Partial responses that leave the user confused
- Infinite loading states when the stream drops silently
- Lost responses that were generated (and billed) but never delivered
- Battery drain from SSE connections kept alive during long queries

**Warning signs:**
- Users reporting "stuck" loading indicators
- Analytics showing high rates of incomplete responses
- Higher error rates on cellular networks vs WiFi
- Edge function logs showing successful completion but client showing error

**Prevention:**
1. **Implement client-side timeout:** If no SSE data is received within 30 seconds, show an error state with a retry button rather than waiting indefinitely.
2. **Persist partial responses:** Store each text delta in local state so that if the stream drops partway through, the user can see what was already received.
3. **Add a fallback polling endpoint:** For cases where SSE fails, allow the client to poll for the completed response by conversation/message ID. The response is already persisted in `user_ai_insight`, so this is feasible.
4. **Handle iOS app lifecycle:** When the app goes to background, gracefully close the SSE connection. When it returns to foreground, check if the response was completed and fetch it via polling.
5. **Send periodic keep-alive comments** in the SSE stream to prevent proxy/CDN timeouts during the NL-to-SQL conversion step (which can take 2-4 seconds with no data sent).

**Phase:** Client-side timeout and partial response persistence in Phase 1 (chat UI). Fallback polling in Phase 2.

**Confidence:** HIGH -- Multiple sources document SSE fragility on mobile. The current implementation has no event IDs or reconnection logic, confirmed by reading `streamHandler.ts`.

**Sources:**
- [Server-Sent Events Are Still Not Production Ready (DEV Community)](https://dev.to/miketalbot/server-sent-events-are-still-not-production-ready-after-a-decade-a-lesson-for-me-a-warning-for-you-2gie)
- [Guide to SSE in JavaScript, Android, and iOS](https://jsonobject.hashnode.dev/guide-to-implementing-server-sent-events-sse-in-javascript-android-and-ios-for-client-side-developers)
- [Working with Server-Sent Events in Swift](https://nickarner.com/notes/working-with-server-sent-events-in-swift---november-16-2021/)

---

## Minor Pitfalls

Mistakes that cause friction, confusion, or suboptimal experience but are recoverable.

---

### Pitfall 9: Ambiguous Queries Without Clarification

**What goes wrong:** Users ask ambiguous questions like "How active was I?" or "What did I do most?" and the model guesses an interpretation rather than asking for clarification. The user gets a confident answer that may not address what they actually meant.

**Why it happens:** The current pipeline is fire-and-forget: user question goes in, SQL comes out. There is no mechanism for the model to ask clarifying questions before generating SQL. The fine-tuned model is trained to always produce SQL, even for ambiguous inputs.

**Consequences:**
- User gets irrelevant answers and loses trust
- User has to manually rephrase multiple times
- The "always generate SQL" behavior masks questions the system cannot actually answer

**Prevention:**
1. **Add a classification step:** Before SQL generation, classify the query as: (a) clear and answerable, (b) ambiguous but answerable with assumptions, (c) unanswerable. For (b), include the assumption in the response ("I interpreted 'active' as any logged activity. If you meant workouts specifically, try asking about workouts."). For (c), return a helpful message without hitting the database.
2. **Suggested follow-ups:** After each response, suggest 2-3 follow-up questions that disambiguate common interpretations.
3. **Handle non-data questions gracefully:** Questions like "What should I do to improve my running?" are not data queries. The system should route these to a general response rather than generating failing SQL.

**Phase:** Classification step in Phase 2. Suggested follow-ups in Phase 1 (chat UI).

**Confidence:** MEDIUM -- Google Cloud and AWS documentation recommend interactive clarification but the complexity of implementation depends on whether it justifies the added latency.

---

### Pitfall 10: Empty Chat State That Discourages First Use

**What goes wrong:** Users open the chat feature and see a blank screen with a text input. They do not know what to ask, what the AI can answer, or what the limits are. First-time users type generic questions ("Hi") or overly complex ones ("Analyze my entire fitness journey and create a plan") and get disappointing results.

**Why it happens:** AI chat interfaces are open-ended, which paradoxically makes them harder to use than constrained UIs. Users have no mental model of the system's capabilities. This is a well-documented UX pattern -- 2025 research shows that "narrow capabilities beat vague promises" and users need explicit capability disclosure.

**Consequences:**
- Low first-message success rate, leading users to abandon the feature
- Users form incorrect mental models ("it can't do anything useful")
- Support requests about what the AI can/cannot do

**Prevention:**
1. **Suggested starter questions:** Show 4-6 tappable starter questions that demonstrate the system's capabilities ("How many times did I work out this month?", "What was my longest run?", "Show my activities from last week"). These should be personalized to the user's actual logged activities.
2. **Capability disclosure:** Brief onboarding tooltip or header text: "Ask me about your activity history, patterns, and stats."
3. **Progressive disclosure of advanced features:** After the user has used basic queries successfully, suggest more advanced ones ("You can also ask about pace, duration trends, or compare activities across time periods").
4. **Graceful handling of out-of-scope queries:** When the user asks something the system cannot answer, explicitly say what it CAN do rather than just saying it failed.

**Phase:** Phase 1 (chat UI) -- this is the first thing the user sees and directly impacts adoption.

**Confidence:** HIGH -- Multiple UX research sources confirm that empty chat states are a primary adoption blocker for AI features.

**Sources:**
- [UX for AI Chatbots: Complete Guide 2025](https://www.parallelhq.com/blog/ux-ai-chatbots)
- [Designing Great Chat-Native App UX](https://skywork.ai/blog/chat-native-app-ux-best-practices/)
- [AI Chatbot UX: 2026's Top Design Best Practices](https://www.letsgroto.com/blog/ux-best-practices-for-ai-chatbots)

---

### Pitfall 11: Error Messages That Expose Technical Details

**What goes wrong:** When SQL execution fails, the Postgres error message could leak schema information, table names, column types, or query structure to the user. The current implementation catches errors and returns generic messages ("I ran into an issue fetching your data"), which is good. But if error handling has gaps, raw error messages could reach the client.

**Why it happens:** During development, detailed error messages are useful for debugging. In production, they become an information disclosure vector. The current code logs errors to console (`console.error`) and returns sanitized messages via SSE, but any uncaught exception in the async pipeline could bypass this.

**Prevention:**
1. **Wrap the entire pipeline in a top-level try/catch** that always returns a sanitized error message. The current implementation does this partially but the `finally` block only closes the stream -- it does not send an error message if an uncaught exception occurs before any step begins.
2. **Never include SQL, table names, column names, or Postgres error codes in client-facing messages.** Log them server-side only.
3. **Categorize errors for the user:** "I couldn't understand your question" (NL-to-SQL failure), "I had trouble finding that data" (execution failure), "Something went wrong on our end" (unexpected error).

**Phase:** Phase 1 -- error handling is foundational.

**Confidence:** HIGH -- Direct code review confirms the current error handling is mostly good but has edge cases.

---

### Pitfall 12: The "INTO" Keyword Block Preventing Legitimate Queries

**What goes wrong:** The current security validation blocks the keyword `INTO` to prevent `SELECT INTO` statements. However, this also blocks legitimate queries that use `INTO` in other contexts. More importantly, this reveals a broader problem: the blocklist approach causes false positives that prevent valid queries from executing, frustrating users.

**Why it happens:** Keyword blocklisting is inherently prone to false positives because SQL keywords appear in many contexts. `INTO` might appear in comments, string literals, or legitimate subquery patterns. The current regex uses word-boundary matching (`\b`), which helps, but edge cases remain.

**Prevention:**
1. **Use SQL parsing instead of regex** to determine query intent. A proper parser can distinguish `SELECT INTO` from `INTO` appearing in a string literal or column alias.
2. **If keeping regex, test with a comprehensive suite** of legitimate queries to ensure no false positives. The existing training data (JSONL files) could serve as a test suite -- run all training queries through the validator and verify none are rejected.
3. **Log rejected queries** so you can detect false positive patterns and adjust the rules.

**Phase:** Phase 1 (security refinement).

**Confidence:** HIGH -- Direct code review of `security.ts` confirms this specific issue.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation | Severity |
|-------------|---------------|------------|----------|
| Security foundation (read-only role, RLS) | #1, #2: Regex bypass and cross-user leakage | Create read-only Postgres role + RLS policies before any production SQL execution | Critical |
| Edge function pipeline | #5: Two-LLM latency | Stream intermediate progress, optimize token counts, consider single-call for simple queries | Moderate |
| Chat UI (Flutter) | #8, #10: Stream fragility, empty state | Client-side timeouts, partial response persistence, suggested starters | Moderate |
| Cost management | #6: Unbounded API costs | Per-user rate limits, daily caps, budget alerts | Moderate |
| Fine-tuned model maintenance | #4: Schema drift | Automated schema sync, monitoring, incremental retraining pipeline | Moderate |
| Multi-turn conversations | #7: Context exhaustion | Conversation length limits, separate context chains | Minor-Moderate |
| Query accuracy | #3, #9: Silent wrong results, ambiguity | Schema validation, sanity checks, user feedback mechanism | Critical |
| Error handling | #11, #12: Technical leaks, false positives | Top-level error wrapping, SQL parsing over regex | Minor |

---

## Logly-Specific Observations

Based on direct analysis of the existing codebase:

1. **The `executeQuery` function uses a raw database client** (`new Client(Deno.env.get("SUPABASE_DB_URL"))`) rather than the Supabase client with RLS. This means RLS policies are not enforced on AI-generated queries. The connection string likely uses a superuser or service role. This is the single highest-risk finding.

2. **The user_id is passed as a string literal** directly in the SQL (`WHERE ua.user_id = 'abc-123'`), not as a parameterized value. This makes it easier for prompt injection to manipulate the user_id filter.

3. **The `MAX_ROWS = 20` limit** is good for cost control but could frustrate users asking for comprehensive lists ("Show all my running sessions this year" -- capped at 20 even if they have 200).

4. **The training data all uses `abc-123` as the user_id.** If the model over-fits on this pattern, it might behave differently with real UUID-format user_ids.

5. **The `sanitizeInput` function exists but is never called** in the current pipeline. The LLM generates complete SQL strings, and user input is only passed to the LLM prompt, not used to construct SQL directly. This function may provide false security confidence.

6. **The response model (`gpt-4.1-mini`) is not fine-tuned,** which is correct for the friendly response step. But it means the response quality depends entirely on the system prompt, which should be tested thoroughly for edge cases (empty results, single-row results, aggregated numbers, duration formatting).

---

*Research conducted: 2026-02-02*
*Sources verified against: Existing codebase analysis, OWASP documentation, ICSE 2025 research, Google Cloud blog, AWS blog, OpenAI documentation, Supabase documentation*
