/**
 * SSE (Server-Sent Events) streaming utilities for the chat function.
 *
 * Event protocol (per CONTEXT.md decisions):
 * - step:          Pipeline progress with start/complete status pairs
 * - text_delta:    Token-by-token streamed response text
 * - response_id:   OpenAI response ID for follow-up chaining
 * - conversion_id: SQL agent response ID for follow-up SQL context
 * - error:         User-friendly error message
 * - done:          Completion signal (no metadata)
 *
 * Key differences from ai-insights/streamHandler.ts:
 * - Step status uses "start"/"complete" (not "in_progress"/"complete")
 * - Text event type is "text_delta" (not "text")
 * - Adds "done" event as a completion signal
 * - Only 2-3 user-visible steps (SQL validation is silent)
 */

// ============================================================
// Message Types
// ============================================================

export type StepStatus = "start" | "complete";

export interface StepMessage {
  type: "step";
  name: string;
  status: StepStatus;
}

export interface TextDeltaMessage {
  type: "text_delta";
  delta: string;
}

export interface ResponseIdMessage {
  type: "response_id";
  responseId: string;
}

export interface ConversionIdMessage {
  type: "conversion_id";
  conversionId: string;
}

export interface ErrorMessage {
  type: "error";
  message: string;
}

export interface DoneMessage {
  type: "done";
  conversation_id: string;
  follow_up_suggestions?: string[];
}

export type StreamMessage =
  | StepMessage
  | TextDeltaMessage
  | ResponseIdMessage
  | ConversionIdMessage
  | ErrorMessage
  | DoneMessage;

// ============================================================
// Progress Stream
// ============================================================

export interface ProgressStream {
  /** The underlying ReadableStream for the SSE response body. */
  stream: ReadableStream<Uint8Array>;
  /** Send a step progress event (start or complete). */
  sendStep(name: string, status: StepStatus): void;
  /** Send a text delta for streaming response content. */
  sendTextDelta(delta: string): void;
  /** Send the response ID for follow-up question chaining. */
  sendResponseId(responseId: string): void;
  /** Send the conversion ID (SQL agent thread) for follow-up SQL context. */
  sendConversionId(conversionId: string): void;
  /** Send an error message (user-friendly). */
  sendError(message: string): void;
  /** Send completion signal with conversation ID and optional follow-up suggestions. */
  sendDone(conversationId: string, followUpSuggestions?: string[]): void;
  /** Close the stream. Always call in a finally block. */
  close(): void;
}

/**
 * Creates a progress stream controller for SSE responses.
 *
 * Uses a buffer to handle messages enqueued before the stream starts.
 * All messages are JSON-serialized and formatted as SSE `data:` events.
 *
 * @returns ProgressStream with typed send methods and the underlying ReadableStream
 */
export function createProgressStream(): ProgressStream {
  const encoder = new TextEncoder();
  let controller: ReadableStreamDefaultController<Uint8Array> | null = null;
  const buffer: Uint8Array[] = [];

  const stream = new ReadableStream<Uint8Array>({
    start(c) {
      controller = c;
      // Flush any messages buffered before the stream started
      while (buffer.length > 0) {
        const chunk = buffer.shift();
        if (chunk) c.enqueue(chunk);
      }
    },
  });

  /**
   * Safely enqueue an SSE data event. Buffers if the stream
   * controller is not yet ready; catches errors if the client
   * has already disconnected.
   */
  const safeEnqueue = (data: string) => {
    const encoded = encoder.encode(data);
    if (controller) {
      try {
        controller.enqueue(encoded);
      } catch (err) {
        console.warn("[Stream] Enqueue failed (client disconnected?):", err);
      }
    } else {
      buffer.push(encoded);
    }
  };

  /** Format a message as an SSE data event. */
  const sendMessage = (message: StreamMessage) => {
    safeEnqueue(`data: ${JSON.stringify(message)}\n\n`);
  };

  return {
    stream,

    sendStep(name: string, status: StepStatus): void {
      sendMessage({ type: "step", name, status });
    },

    sendTextDelta(delta: string): void {
      sendMessage({ type: "text_delta", delta });
    },

    sendResponseId(responseId: string): void {
      sendMessage({ type: "response_id", responseId });
    },

    sendConversionId(conversionId: string): void {
      sendMessage({ type: "conversion_id", conversionId });
    },

    sendError(message: string): void {
      sendMessage({ type: "error", message });
    },

    sendDone(conversationId: string, followUpSuggestions?: string[]): void {
      const message: DoneMessage = {
        type: "done",
        conversation_id: conversationId,
      };
      if (followUpSuggestions && followUpSuggestions.length > 0) {
        message.follow_up_suggestions = followUpSuggestions;
      }
      sendMessage(message);
    },

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

// ============================================================
// SSE Headers
// ============================================================

/**
 * Creates standard SSE response headers.
 *
 * Includes:
 * - Content-Type: text/event-stream
 * - Connection: keep-alive
 * - Cache-Control: no-cache
 * - X-Accel-Buffering: no (disables nginx buffering)
 */
export function createSSEHeaders(): Headers {
  return new Headers({
    "Content-Type": "text/event-stream",
    "Connection": "keep-alive",
    "Cache-Control": "no-cache",
    "X-Accel-Buffering": "no",
  });
}
