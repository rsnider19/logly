/**
 * Streaming utilities for Server-Sent Events (SSE) progress updates.
 *
 * Message types:
 * - step: Progress checklist items with status
 * - text: Streamed response text deltas
 * - error: Error messages
 *
 * TODO: Add step timing metrics for performance monitoring
 */

export type StepStatus = "pending" | "in_progress" | "complete" | "error";

export interface StepMessage {
  type: "step";
  name: string;
  status: StepStatus;
}

export interface TextMessage {
  type: "text";
  delta: string;
}

export interface ErrorMessage {
  type: "error";
  message: string;
}

export interface ResponseIdMessage {
  type: "response_id";
  responseId: string;
}

export interface ConversionIdMessage {
  type: "conversion_id";
  conversionId: string;
}

export type StreamMessage =
  | StepMessage
  | TextMessage
  | ErrorMessage
  | ResponseIdMessage
  | ConversionIdMessage;

/**
 * User-friendly step names for the pipeline stages (UI display).
 * These are shown to users in the streaming progress UI.
 */
export const STEP_NAMES = {
  CONVERTING: "Reading through your Logly",
  VALIDATING: "Grabbing the relevant entries",
  EXECUTING: "Verifying my work",
  RESPONDING: "Generating your response",
} as const;

/**
 * Technical step names for database logging (debugging/analytics).
 * These are stored in user_ai_insight_step for debugging purposes.
 */
export const DB_STEP_NAMES = {
  CONVERTING: "nl_to_sql",
  VALIDATING: "sql_validation",
  EXECUTING: "sql_execution",
  RESPONDING: "response_generation",
} as const;

/**
 * Creates a progress stream controller for SSE responses.
 */
export function createProgressStream() {
  const encoder = new TextEncoder();
  let controller: ReadableStreamDefaultController | null = null;
  const buffer: Uint8Array[] = [];

  const stream = new ReadableStream({
    start(c) {
      controller = c;
      // Flush buffered messages
      while (buffer.length > 0) {
        c.enqueue(buffer.shift());
      }
    },
  });

  const safeEnqueue = (data: string) => {
    const encoded = encoder.encode(data);
    if (controller) {
      try {
        controller.enqueue(encoded);
      } catch (err) {
        console.warn("⚠️ Stream enqueue failed (client disconnected?):", err);
      }
    } else {
      buffer.push(encoded);
    }
  };

  return {
    stream,

    /**
     * Send a step progress update.
     */
    sendStep(name: string, status: StepStatus): void {
      const message: StepMessage = { type: "step", name, status };
      safeEnqueue(`data: ${JSON.stringify(message)}\n\n`);
    },

    /**
     * Send a text delta for streaming response.
     */
    sendText(delta: string): void {
      const message: TextMessage = { type: "text", delta };
      safeEnqueue(`data: ${JSON.stringify(message)}\n\n`);
    },

    /**
     * Send an error message.
     */
    sendError(message: string): void {
      const errorMsg: ErrorMessage = { type: "error", message };
      safeEnqueue(`data: ${JSON.stringify(errorMsg)}\n\n`);
    },

    /**
     * Send the response ID for follow-up questions.
     */
    sendResponseId(responseId: string): void {
      const message: ResponseIdMessage = {
        type: "response_id",
        responseId,
      };
      safeEnqueue(`data: ${JSON.stringify(message)}\n\n`);
    },

    /**
     * Send the conversion ID (SQL agent thread) for follow-ups.
     */
    sendConversionId(conversionId: string): void {
      const message: ConversionIdMessage = {
        type: "conversion_id",
        conversionId,
      };
      safeEnqueue(`data: ${JSON.stringify(message)}\n\n`);
    },

    /**
     * Close the stream.
     */
    close(): void {
      if (controller) {
        try {
          controller.close();
        } catch (_) {
          // Stream already closed
        }
      }
    },
  };
}

/**
 * Creates SSE response headers.
 */
export function createSSEHeaders(): Headers {
  return new Headers({
    "Content-Type": "text/event-stream",
    "Connection": "keep-alive",
    "Cache-Control": "no-cache",
    "X-Accel-Buffering": "no",
  });
}
