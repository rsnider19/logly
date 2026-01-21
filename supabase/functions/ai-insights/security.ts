/**
 * SQL security validation utilities.
 *
 * These checks run BEFORE any SQL is executed to prevent malicious queries.
 * All validation is regex-based (no LLM calls) for speed and reliability.
 *
 * TODO: Add custom allow/deny rules as needed
 * TODO: Consider adding query complexity limits (e.g., max JOINs)
 */

export interface ValidationResult {
  valid: boolean;
  error?: string;
}

// Dangerous SQL keywords that should never appear in user-generated queries
const DANGEROUS_KEYWORDS = [
  "DROP",
  "DELETE",
  "INSERT",
  "UPDATE",
  "ALTER",
  "TRUNCATE",
  "CREATE",
  "GRANT",
  "REVOKE",
  "EXEC",
  "EXECUTE",
  "INTO", // Prevents SELECT INTO
  "COPY",
  "VACUUM",
  "REINDEX",
  "CLUSTER",
];

// Patterns that indicate SQL injection attempts
const INJECTION_PATTERNS = [
  /;\s*$/, // Trailing semicolon (multiple statements)
  /;\s*\w/, // Semicolon followed by another statement
  /--/, // SQL comment
  /\/\*/, // Block comment start
  /\*\//, // Block comment end
  /\\x[0-9a-fA-F]/, // Hex escape sequences
  /UNION\s+(ALL\s+)?SELECT/i, // UNION injection
];

/**
 * Validates a SQL query for safety before execution.
 *
 * @param sql - The SQL query to validate
 * @returns ValidationResult with valid flag and optional error message
 */
export function validateSqlQuery(sql: string): ValidationResult {
  const upperSql = sql.toUpperCase().trim();

  // Must start with SELECT
  if (!upperSql.startsWith("SELECT")) {
    return {
      valid: false,
      error: "Only SELECT queries are allowed",
    };
  }

  // Check for dangerous keywords
  for (const keyword of DANGEROUS_KEYWORDS) {
    // Use word boundary to avoid false positives (e.g., "UPDATED" in column name)
    const pattern = new RegExp(`\\b${keyword}\\b`, "i");
    if (pattern.test(sql)) {
      return {
        valid: false,
        error: `Query contains forbidden keyword: ${keyword}`,
      };
    }
  }

  // Check for injection patterns
  for (const pattern of INJECTION_PATTERNS) {
    if (pattern.test(sql)) {
      return {
        valid: false,
        error: "Query contains potentially dangerous pattern",
      };
    }
  }

  // TODO: Add additional validation rules here
  // Examples:
  // - Check for maximum query length
  // - Limit number of JOINs
  // - Restrict access to certain tables
  // - Validate column names against known schema

  return { valid: true };
}

/**
 * Sanitizes user input before embedding in SQL context.
 * Note: The LLM should use parameterized queries, but this is a safety net.
 *
 * @param input - User input to sanitize
 * @returns Sanitized string
 */
export function sanitizeInput(input: string): string {
  return input
    .replace(/'/g, "''") // Escape single quotes
    .replace(/\\/g, "\\\\") // Escape backslashes
    .trim();
}
