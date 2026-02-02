/**
 * SQL security validation and input sanitization utilities for the chat function.
 *
 * Two layers of defense:
 * 1. validateSqlQuery() - Validates LLM-generated SQL is read-only and safe
 * 2. sanitizeUserInput() - Strips prompt injection patterns from user input
 *
 * These run BEFORE any SQL is executed or user input reaches the LLM.
 * All validation is regex-based (no LLM calls) for speed and reliability.
 */

// ============================================================
// SQL Validation
// ============================================================

export interface ValidationResult {
  valid: boolean;
  error?: string;
}

/** Maximum allowed SQL query length in characters. */
const MAX_QUERY_LENGTH = 2000;

/**
 * Dangerous SQL keywords that should never appear in generated queries.
 * Uses word-boundary matching to avoid false positives
 * (e.g., "UPDATED" in a column alias).
 */
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
  "COPY",
  "VACUUM",
  "REINDEX",
  "CLUSTER",
];

/**
 * Patterns that indicate SQL injection attempts.
 * These catch common injection vectors that bypass keyword checks.
 */
const INJECTION_PATTERNS = [
  /;\s*\w/, // Semicolon followed by another statement (multi-statement injection)
  /--.*\n.*\w/, // SQL line comment followed by more SQL (mid-query comment injection)
  /\/\*/, // Block comment start
  /\*\//, // Block comment end
  /\\x[0-9a-fA-F]/, // Hex escape sequences
  /UNION\s+(ALL\s+)?SELECT/i, // UNION injection
];

/**
 * Validates a SQL query for safety before execution.
 *
 * Checks:
 * - Must start with SELECT (case-insensitive)
 * - Must not exceed MAX_QUERY_LENGTH characters
 * - Must not contain dangerous keywords (word-boundary matched)
 * - Must not contain injection patterns (semicolons, comments, UNION, hex)
 *
 * @param sql - The SQL query to validate
 * @returns ValidationResult with valid flag and optional error message
 */
export function validateSqlQuery(sql: string): ValidationResult {
  // Strip trailing semicolons -- LLMs commonly append them to generated SQL
  const trimmed = sql.trim().replace(/;\s*$/, "");

  // Check maximum query length
  if (trimmed.length > MAX_QUERY_LENGTH) {
    return {
      valid: false,
      error: `Query exceeds maximum length of ${MAX_QUERY_LENGTH} characters`,
    };
  }

  // Must start with SELECT
  if (!trimmed.toUpperCase().startsWith("SELECT")) {
    return {
      valid: false,
      error: "Only SELECT queries are allowed",
    };
  }

  // Check for dangerous keywords with word boundaries
  for (const keyword of DANGEROUS_KEYWORDS) {
    const pattern = new RegExp(`\\b${keyword}\\b`, "i");
    if (pattern.test(trimmed)) {
      return {
        valid: false,
        error: `Query contains forbidden keyword: ${keyword}`,
      };
    }
  }

  // Check for injection patterns
  for (const pattern of INJECTION_PATTERNS) {
    if (pattern.test(trimmed)) {
      return {
        valid: false,
        error: "Query contains potentially dangerous pattern",
      };
    }
  }

  return { valid: true };
}

// ============================================================
// Input Sanitization (Prompt Injection Defense)
// ============================================================

/** Maximum allowed user input length in characters. */
const MAX_INPUT_LENGTH = 500;

/**
 * Regex patterns that detect common prompt injection attempts.
 * When matched, the adversarial text is stripped and a warning is logged.
 */
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

/**
 * Sanitizes user input before it reaches the LLM system prompt.
 *
 * Defense layers:
 * 1. Strips control characters (Unicode range \x00-\x08, \x0B, \x0C, \x0E-\x1F)
 * 2. Detects and strips known adversarial patterns (logs warnings for monitoring)
 * 3. Enforces max input length of 500 characters (truncates, does not reject)
 *
 * @param input - Raw user input from the client
 * @returns Sanitized string safe to embed in LLM prompts
 */
export function sanitizeUserInput(input: string): string {
  let sanitized = input.trim();

  // Strip control characters (keep \t, \n, \r which are \x09, \x0A, \x0D)
  sanitized = sanitized.replace(/[\x00-\x08\x0B\x0C\x0E-\x1F]/g, "");

  // Check and strip adversarial patterns (log for monitoring)
  for (const pattern of ADVERSARIAL_PATTERNS) {
    if (pattern.test(sanitized)) {
      console.warn(`[Sanitize] Potential prompt injection detected: ${pattern}`);
      sanitized = sanitized.replace(pattern, "");
    }
  }

  // Enforce max input length (truncate, don't reject)
  if (sanitized.length > MAX_INPUT_LENGTH) {
    sanitized = sanitized.substring(0, MAX_INPUT_LENGTH);
  }

  return sanitized.trim();
}
