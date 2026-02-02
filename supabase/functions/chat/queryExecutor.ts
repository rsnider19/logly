/**
 * RLS-enforced SQL execution with statement timeout.
 *
 * Executes LLM-generated SQL as the `authenticated` Postgres role with
 * the user's ID set in session config, so RLS policies automatically
 * scope results to the authenticated user's data.
 *
 * Security layers:
 * 1. UUID format validation on userId before interpolation
 * 2. SET LOCAL ROLE authenticated (RLS enforcement)
 * 3. set_config for auth.uid() via both claim formats
 * 4. Statement timeout to kill runaway queries
 * 5. Transaction-scoped settings (auto-revert on COMMIT/ROLLBACK)
 * 6. Row limit to prevent excessive data transfer
 *
 * Key difference from ai-insights/agent.ts executeQuery():
 * - ai-insights runs as `postgres` role (RLS bypassed)
 * - This function switches to `authenticated` role with RLS enforcement
 */

import { Client } from "jsr:@db/postgres";

/** Statement timeout in milliseconds. 10 seconds is generous enough for complex
 * aggregations but kills pathological queries before they hurt the database. */
const QUERY_TIMEOUT_MS = 10_000;

/** Maximum rows returned from any query. The LLM is instructed to aggregate,
 * but this is a safety net against unbounded result sets. */
const MAX_ROWS = 100;

/** Strict UUID v4 format regex for userId validation. */
const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/**
 * Result of a query execution.
 *
 * @property rows - The query result rows (up to MAX_ROWS)
 * @property truncated - Whether the result was truncated to MAX_ROWS
 */
export interface QueryResult {
  rows: unknown[];
  truncated: boolean;
}

/**
 * Executes a SQL query with RLS enforcement and statement timeout.
 *
 * Opens a new Postgres connection, begins a transaction, switches to the
 * `authenticated` role, sets JWT claim config for auth.uid(), applies a
 * statement timeout, executes the query, and commits.
 *
 * On error, the transaction is rolled back and the connection is closed.
 *
 * @param sql - The generated SQL query to execute (must be pre-validated)
 * @param userId - The authenticated user's UUID (from verified JWT)
 * @returns QueryResult with rows and truncation flag
 * @throws Error if userId is not a valid UUID
 * @throws Error if the query fails (timeout, syntax error, etc.)
 */
export async function executeWithRLS(
  sql: string,
  userId: string,
): Promise<QueryResult> {
  // Validate userId format before interpolation into SQL
  if (!UUID_REGEX.test(userId)) {
    throw new Error(`Invalid userId format: expected UUID, got "${userId}"`);
  }

  const client = new Client(Deno.env.get("SUPABASE_DB_URL"));
  await client.connect();

  try {
    // Begin transaction -- SET LOCAL only works within a transaction block
    await client.queryObject("BEGIN");

    // Set statement timeout for this transaction only
    await client.queryObject(
      `SET LOCAL statement_timeout = '${QUERY_TIMEOUT_MS}ms'`,
    );

    // Switch to authenticated role for RLS enforcement
    await client.queryObject("SET LOCAL ROLE authenticated");

    // Set JWT claims so auth.uid() works correctly.
    // auth.uid() uses coalesce to check both formats:
    //   1. request.jwt.claim.sub (legacy individual claim)
    //   2. request.jwt.claims->>'sub' (modern JSON blob)
    // Both must be set for full compatibility.
    await client.queryObject(
      `SELECT set_config('request.jwt.claim.sub', '${userId}', true)`,
    );
    await client.queryObject(
      `SELECT set_config('request.jwt.claims', '${JSON.stringify({ sub: userId, role: "authenticated" })}', true)`,
    );

    // Execute the generated SQL -- RLS policies now filter by auth.uid()
    const result = await client.queryObject(sql);
    const rows = result.rows;

    // Commit to finalize the transaction
    await client.queryObject("COMMIT");

    // Enforce row limit
    const truncated = rows.length > MAX_ROWS;
    return {
      rows: truncated ? rows.slice(0, MAX_ROWS) : rows,
      truncated,
    };
  } catch (err) {
    // Rollback on any error (swallow rollback errors if connection is broken)
    await client.queryObject("ROLLBACK").catch(() => {});
    throw err;
  } finally {
    await client.end();
  }
}
