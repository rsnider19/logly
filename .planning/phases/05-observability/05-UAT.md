---
status: complete
phase: 05-observability
source: 05-01-SUMMARY.md, 05-02-SUMMARY.md
started: 2026-02-03T20:15:00Z
updated: 2026-02-03T20:25:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Telemetry Record Created
expected: After sending a chat question in the app, query the chat_telemetry_log table in Supabase. A new row should exist with your question's conversation_id containing generated_sql text.
result: pass

### 2. SQL Fingerprint Computed
expected: The telemetry record should have a sql_fingerprint value (32-character MD5 hash) populated automatically by the database trigger.
result: pass

### 3. Timing Durations Captured
expected: The telemetry record should have timing values: sql_generation_ms, sql_execution_ms, and response_generation_ms all populated with positive numbers (milliseconds).
result: pass

### 4. Token Usage Captured
expected: The telemetry record should have token counts: sql_input_tokens, sql_output_tokens, response_input_tokens, and response_output_tokens all populated with positive numbers.
result: pass

### 5. TTFB Captured
expected: The telemetry record should have ttfb_ms (time to first byte) populated with a positive number representing milliseconds from request start to first text delta.
result: pass

### 6. Error Telemetry on Failure
expected: When a chat request fails (e.g., off-topic question triggers redirect), the telemetry record should still be created with error_type populated and partial timing/token data where available.
result: pass

## Summary

total: 6
passed: 6
issues: 0
pending: 0
skipped: 0

## Gaps

[none yet]
