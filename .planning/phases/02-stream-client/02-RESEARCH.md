# Phase 2: Stream Client - Research

**Researched:** 2026-02-02
**Domain:** Flutter SSE client, Dart stream processing, typewriter text buffering, Supabase edge function invocation, Riverpod state management
**Confidence:** HIGH

## Summary

This phase builds the Flutter data layer that opens an authenticated SSE connection to the `chat` edge function (built in Phase 1) and parses the streaming response into typed domain events (`ChatEvent`) for the UI to consume. The primary technical challenges are: (1) consuming the SSE `ByteStream` from `supabase_flutter`'s `functions.invoke()` with proper line buffering to handle arbitrary chunk splitting, (2) parsing SSE `data:` lines into a sealed `ChatEvent` class hierarchy, (3) implementing a character-by-character typewriter buffer that drips text at 5ms/char with speed-up after completion, and (4) managing connection lifecycle with stall detection and one-retry logic.

The `supabase_flutter` package (v2.12.0) already includes SSE support in its `functions_client` (v2.5.0): when the edge function returns `Content-Type: text/event-stream`, the `FunctionResponse.data` is a `ByteStream` rather than decoded JSON. The JWT auth token is automatically forwarded by the Supabase client. The main gotcha is that SSE chunks arrive split arbitrarily at TCP boundaries, so a proper line-buffering SSE parser is essential -- raw `json.decode()` on each chunk will fail.

The existing codebase provides clear patterns to follow: repositories are "dumb" data access with `@Riverpod(keepAlive: true)`, services contain business logic, Freezed generates domain models, and sealed classes with `@Freezed(unionKey: ...)` are used for union types. The `flyer_chat_text_stream_message` package (already in pubspec) provides the UI widget for Phase 3 and expects a `StreamState` (loading/streaming/completed/error) with `accumulatedText` -- the data layer must emit state compatible with this.

**Primary recommendation:** Use `supabase_flutter`'s built-in `functions.invoke()` for the SSE connection (no third-party HTTP client needed for mobile). Build a custom SSE line-buffer parser as a Dart `StreamTransformer` to handle chunk splitting. Model events as a Freezed sealed class hierarchy. Implement the typewriter buffer as a standalone class using `Timer.periodic` that emits characters from a growing buffer. Surface the whole pipeline through a Riverpod `AsyncNotifier` that holds the chat stream state.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `supabase_flutter` | 2.12.0 | Edge function invocation with SSE support | Already in project; `functions.invoke()` returns `ByteStream` for SSE |
| `functions_client` | 2.5.0 | Underlying functions client (transitive dep) | Handles `text/event-stream` content type, returns raw `ByteStream` |
| `freezed` / `freezed_annotation` | 3.0.6 / 3.1.0 | Sealed class codegen for `ChatEvent` types | Already in project; used for all domain models |
| `riverpod` / `riverpod_annotation` | any / 4.0.1 | State management for chat stream state | Already in project; `@Riverpod(keepAlive: true)` for services |
| `dart:async` | (built-in) | `StreamController`, `StreamTransformer`, `Timer.periodic`, `Completer` | Core Dart; no external dependency needed |
| `dart:convert` | (built-in) | `Utf8Decoder`, `LineSplitter`, `jsonDecode` | SSE byte stream parsing |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `flyer_chat_text_stream_message` | 2.3.0 | UI widget for streaming text (Phase 3) | Already in project; data layer must emit state compatible with its `StreamState` |
| `flutter_chat_core` | 2.9.0 | Chat message models (Phase 3) | Already in project; `TextStreamMessage` model for the UI layer |
| `logger` | 2.5.0 | Logging via `LoggerService` | Already in project; all repositories/services use it |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `supabase_flutter` built-in SSE | `flutter_client_sse` (pub.dev) | Extra dependency; supabase_flutter already handles SSE natively since functions_client 2.5.0. flutter_client_sse last updated Aug 2024. |
| `supabase_flutter` built-in SSE | Raw `dart:io` `HttpClient` | Would need to manually construct URL, add auth headers, handle token refresh. supabase_flutter does all of this automatically. |
| Custom SSE line-buffer parser | `dart_sse` package | Extra dependency for ~30 lines of code. The SSE protocol is simple (`data:` lines separated by `\n\n`). Custom parser gives full control over the known chunk-splitting issue. |
| `Timer.periodic` for typewriter | `Ticker` (Flutter) | `Ticker` ties into rendering pipeline for smoother animation but requires a `TickerProvider` (widget-level concern). `Timer.periodic` works at the data layer without widget dependency. 5ms granularity is fine for mobile (4ms minimum on web). |

**Installation:**
No additional packages needed. Everything is already in `pubspec.yaml`.

## Architecture Patterns

### Recommended Project Structure
```
lib/features/chat/
├── domain/
│   ├── chat_event.dart              # Sealed ChatEvent class (Freezed)
│   ├── chat_stream_state.dart       # Chat stream state model (Freezed)
│   └── chat_exception.dart          # Feature exceptions
├── data/
│   ├── chat_repository.dart         # SSE connection + raw event parsing
│   └── sse_event_parser.dart        # StreamTransformer: ByteStream -> SSE events
├── application/
│   ├── chat_service.dart            # Business logic: retry, stall detection, typewriter
│   └── typewriter_buffer.dart       # Character drip buffer (5ms/char, speed-up on done)
└── presentation/
    └── providers/
        └── chat_stream_provider.dart  # Riverpod notifier for UI consumption
```

### Pattern 1: SSE Line-Buffer Parser (StreamTransformer)

**What:** A `StreamTransformer<String, String>` that buffers incoming UTF-8 text and emits complete SSE events delimited by `\n\n`. This is critical because the `ByteStream` from `functions_client` splits data arbitrarily at TCP boundaries.

**When to use:** Always -- between the raw `ByteStream` and the JSON parser.

**Why this matters:** The server sends events formatted as `data: {"type":"text_delta","delta":"Hello"}\n\n`. But the client may receive `data: {"type":"text_del` in one chunk and `ta","delta":"Hello"}\n\n` in the next. Without buffering, `jsonDecode` fails on the first chunk.

**Example:**
```dart
// Source: SSE spec (https://html.spec.whatwg.org/multipage/server-sent-events.html)
// + supabase-flutter issue #948 workaround

import 'dart:async';

/// Transforms a stream of arbitrary string chunks into complete SSE event payloads.
///
/// SSE events are delimited by double newlines (\n\n). Each event line starts with
/// "data: " followed by JSON. This transformer buffers partial chunks and emits
/// only complete, parseable event data strings.
class SseEventTransformer extends StreamTransformerBase<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) {
    return Stream.eventTransformed(stream, (sink) => _SseEventSink(sink));
  }
}

class _SseEventSink implements EventSink<String> {
  _SseEventSink(this._outputSink);
  final EventSink<String> _outputSink;
  final StringBuffer _buffer = StringBuffer();

  @override
  void add(String chunk) {
    _buffer.write(chunk);
    _processBuffer();
  }

  void _processBuffer() {
    final content = _buffer.toString();
    // SSE events are separated by double newlines
    final events = content.split('\n\n');

    // All but the last element are complete events
    for (var i = 0; i < events.length - 1; i++) {
      final event = events[i].trim();
      if (event.isEmpty) continue;

      // Extract data from "data: <json>" lines
      for (final line in event.split('\n')) {
        if (line.startsWith('data: ')) {
          _outputSink.add(line.substring(6)); // Strip "data: " prefix
        }
      }
    }

    // Keep the last (potentially incomplete) element in the buffer
    _buffer
      ..clear()
      ..write(events.last);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _outputSink.addError(error, stackTrace);
  }

  @override
  void close() {
    // Process any remaining data in the buffer
    final remaining = _buffer.toString().trim();
    if (remaining.isNotEmpty) {
      for (final line in remaining.split('\n')) {
        if (line.startsWith('data: ')) {
          _outputSink.add(line.substring(6));
        }
      }
    }
    _outputSink.close();
  }
}
```

### Pattern 2: Sealed ChatEvent Class (Freezed)

**What:** A sealed class hierarchy modeling all SSE event types from the server. Uses Freezed with `@Freezed(unionKey: 'type')` for automatic JSON deserialization based on the `type` field.

**When to use:** Domain model for all parsed SSE events.

**Example:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_event.freezed.dart';
part 'chat_event.g.dart';

/// Domain events parsed from the chat SSE stream.
///
/// Maps 1:1 to the server's SSE event protocol defined in streamHandler.ts.
@Freezed(unionKey: 'type')
sealed class ChatEvent with _$ChatEvent {
  const ChatEvent._();

  /// Pipeline step progress (start/complete pairs).
  @FreezedUnionValue('step')
  const factory ChatEvent.step({
    required String name,
    required String status,
  }) = ChatStepEvent;

  /// Streaming text delta (token-by-token from the response).
  @FreezedUnionValue('text_delta')
  const factory ChatEvent.textDelta({
    required String delta,
  }) = ChatTextDeltaEvent;

  /// Response ID for follow-up chaining.
  @FreezedUnionValue('response_id')
  const factory ChatEvent.responseId({
    required String responseId,
  }) = ChatResponseIdEvent;

  /// Conversion ID for SQL agent follow-up context.
  @FreezedUnionValue('conversion_id')
  const factory ChatEvent.conversionId({
    required String conversionId,
  }) = ChatConversionIdEvent;

  /// Error (user-friendly message).
  @FreezedUnionValue('error')
  const factory ChatEvent.error({
    required String message,
  }) = ChatErrorEvent;

  /// Stream completion signal.
  @FreezedUnionValue('done')
  const factory ChatEvent.done() = ChatDoneEvent;

  factory ChatEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatEventFromJson(json);
}
```

### Pattern 3: Repository Pattern (SSE Connection)

**What:** A "dumb" repository that opens the SSE connection via `supabase_flutter` and returns a `Stream<ChatEvent>`. No business logic -- just data access.

**When to use:** Called by `ChatService` (never from UI).

**Example:**
```dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/chat/data/sse_event_parser.dart';
import 'package:logly/features/chat/domain/chat_event.dart';
import 'package:logly/features/chat/domain/chat_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_repository.g.dart';

/// Repository for chat edge function SSE communication.
///
/// Opens authenticated SSE connections and parses the byte stream
/// into typed ChatEvent domain objects. No business logic.
class ChatRepository {
  ChatRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Sends a question to the chat edge function and returns
  /// a stream of parsed ChatEvent objects.
  ///
  /// The Supabase client automatically attaches the user's JWT.
  Stream<ChatEvent> sendQuestion({
    required String query,
    String? previousResponseId,
    String? previousConversionId,
  }) async* {
    try {
      final response = await _supabase.functions.invoke(
        'chat',
        body: {
          'query': query,
          if (previousResponseId != null) 'previousResponseId': previousResponseId,
          if (previousConversionId != null) 'previousConversionId': previousConversionId,
        },
      );

      // functions_client returns ByteStream for text/event-stream
      final byteStream = response.data as http.ByteStream;

      yield* byteStream
          .transform(const Utf8Decoder())
          .transform(SseEventTransformer())
          .map((jsonStr) {
            final json = jsonDecode(jsonStr) as Map<String, dynamic>;
            return ChatEvent.fromJson(json);
          });
    } on FunctionException catch (e, st) {
      _logger.e('Chat function returned error: ${e.status}', e, st);
      if (e.status == 401) {
        throw const ChatAuthException();
      } else if (e.status == 403) {
        throw const ChatPremiumRequiredException();
      } else if (e.status == 429) {
        throw const ChatRateLimitException();
      }
      throw ChatConnectionException(e.toString());
    } catch (e, st) {
      _logger.e('Chat stream error', e, st);
      throw ChatConnectionException(e.toString());
    }
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
```

### Pattern 4: Typewriter Buffer

**What:** A standalone class that accepts text deltas (chunks from SSE) and emits characters one-by-one at a configurable rate. After a "done" signal, it speeds up to drain the remaining buffer.

**When to use:** Between the raw `ChatEvent` stream and the UI state.

**Example:**
```dart
import 'dart:async';

/// Buffers incoming text deltas and emits characters at a controlled rate
/// to create a typewriter effect.
///
/// - Normal mode: 5ms per character (200 chars/sec)
/// - Drain mode (after done signal): 1ms per character (1000 chars/sec)
class TypewriterBuffer {
  TypewriterBuffer({
    this.normalInterval = const Duration(milliseconds: 5),
    this.drainInterval = const Duration(milliseconds: 1),
  });

  final Duration normalInterval;
  final Duration drainInterval;

  final StringBuffer _buffer = StringBuffer();
  final StringBuffer _emitted = StringBuffer();
  final StreamController<String> _controller = StreamController<String>.broadcast();
  Timer? _timer;
  bool _isDraining = false;
  bool _isDone = false;

  /// Stream of accumulated text (each emission is the full text so far).
  Stream<String> get stream => _controller.stream;

  /// The full text emitted so far.
  String get currentText => _emitted.toString();

  /// Whether the buffer has finished draining all characters.
  bool get isComplete => _isDone && _buffer.isEmpty;

  /// Add a text delta to the buffer.
  void addDelta(String delta) {
    _buffer.write(delta);
    _ensureTimerRunning();
  }

  /// Signal that no more deltas will arrive. Speed up draining.
  void markDone() {
    _isDone = true;
    _isDraining = true;
    // Restart timer with faster interval
    _timer?.cancel();
    _timer = null;
    _ensureTimerRunning();
  }

  void _ensureTimerRunning() {
    if (_timer != null) return;
    if (_buffer.isEmpty) return;

    final interval = _isDraining ? drainInterval : normalInterval;
    _timer = Timer.periodic(interval, (_) {
      if (_buffer.isEmpty) {
        _timer?.cancel();
        _timer = null;
        if (_isDone) {
          _controller.close();
        }
        return;
      }

      final bufferStr = _buffer.toString();
      final char = bufferStr[0];
      _buffer
        ..clear()
        ..write(bufferStr.substring(1));
      _emitted.write(char);
      _controller.add(_emitted.toString());
    });
  }

  /// Dispose resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
```

### Pattern 5: Service with Stall Detection and Retry

**What:** The `ChatService` orchestrates the repository call with stall detection (30s timeout between events), auto-retry (one silent retry), and typewriter buffering.

**When to use:** Business logic layer called by the Riverpod provider.

**Key logic flow:**
```
1. Call repository.sendQuestion()
2. Listen to Stream<ChatEvent> with 30s stall timeout
3. On each event, reset the stall timer
4. Route events: textDelta -> typewriter buffer, step/responseId/conversionId -> state, error -> error state
5. On stall or network error: retry once silently, then surface error
6. On done: signal typewriter to drain, wait for drain to complete
```

### Pattern 6: Riverpod State Notifier for Chat Stream

**What:** A `@Riverpod(keepAlive: true)` notifier that holds the current chat stream state and exposes it to the UI. The state includes: connection status, current step, typewriter text, accumulated IDs, and error info.

**When to use:** UI providers consume this to render the chat.

**State shape (Freezed):**
```dart
@freezed
abstract class ChatStreamState with _$ChatStreamState {
  const factory ChatStreamState({
    @Default(ChatConnectionStatus.idle) ChatConnectionStatus status,
    @Default('') String displayText,       // Typewriter-dripped text for UI
    @Default('') String fullText,          // Complete accumulated text (for copy, etc.)
    String? currentStepName,               // Active step label
    String? currentStepStatus,             // "start" or "complete"
    String? responseId,                    // For follow-up chaining
    String? conversionId,                  // For SQL context chaining
    String? errorMessage,                  // User-friendly error
    @Default(false) bool isRetrying,       // Silent retry in progress
  }) = _ChatStreamState;
}

enum ChatConnectionStatus {
  idle,        // No active stream
  connecting,  // Request sent, waiting for first event
  streaming,   // Receiving events
  completing,  // Done received, typewriter draining
  completed,   // All text emitted
  error,       // Error state
}
```

### Anti-Patterns to Avoid

- **Decoding chunks directly as JSON without line buffering:** The `ByteStream` splits data at arbitrary TCP boundaries. Always buffer and split on `\n\n` first. This is the #1 issue reported in supabase-flutter #948.
- **Using `response.data` as anything other than `ByteStream` for SSE:** The `functions_client` returns `ByteStream` when content-type is `text/event-stream`. Casting to `String` or `List` will fail.
- **Putting retry logic in the repository:** Repositories are dumb data access. Retry, stall detection, and typewriter buffering belong in the service layer.
- **Using `StreamSubscription.cancel()` without closing the HTTP connection:** Cancelling the stream subscription does not necessarily close the underlying HTTP connection. Ensure cleanup in the service's dispose/cancel logic.
- **Exposing raw `Stream<ChatEvent>` to the UI:** The UI should consume a state object (compatible with `flyer_chat_text_stream_message`'s `StreamState`), not raw events. The provider translates events into state.
- **Using `Timer.periodic` with intervals shorter than 4ms on web:** Browser minimum timer resolution is 4ms. The decided 5ms normal rate is safe; the 1ms drain rate will effectively run at ~4ms on web, which is acceptable.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| SSE HTTP connection with auth | Raw `HttpClient` with manual JWT headers | `supabase_flutter` `functions.invoke()` | Automatically attaches JWT, handles token refresh, manages connection lifecycle |
| JSON serialization of event types | Manual `switch` on `type` field with `Map` construction | Freezed `@Freezed(unionKey: 'type')` sealed class | Codegen handles all serialization, exhaustive pattern matching, immutability |
| Streaming text UI rendering | Custom `RichText` with fade-in animation | `flyer_chat_text_stream_message` (already in pubspec) | Handles animated opacity, markdown rendering, loading/error states |
| Timer-based character emission | `Stream.periodic` with manual index tracking | Custom `TypewriterBuffer` class with `Timer.periodic` | Need variable-rate emission (normal vs drain), buffer management, clean cancellation |

**Key insight:** The `supabase_flutter` client already handles the hardest parts (auth, SSE content-type detection, ByteStream return). The custom work is: (1) SSE line buffering (~30 lines), (2) Freezed event model (codegen), (3) typewriter buffer (~50 lines), and (4) service orchestration with retry/stall logic.

## Common Pitfalls

### Pitfall 1: SSE Chunk Splitting Breaks JSON Parsing

**What goes wrong:** `jsonDecode()` throws `FormatException` because a JSON object was split across two TCP chunks. Example: chunk 1 = `data: {"type":"text_del`, chunk 2 = `ta","delta":"Hi"}\n\n`.
**Why it happens:** TCP/HTTP does not guarantee SSE event boundaries align with stream chunk boundaries. The `ByteStream` emits bytes as they arrive from the network.
**How to avoid:** Always use a line-buffering `StreamTransformer` that accumulates text and splits on `\n\n` before attempting JSON parse. See Pattern 1 above.
**Warning signs:** Intermittent `FormatException` in logs. Works sometimes, fails other times. Fails more often with larger payloads.

### Pitfall 2: Stall Detection Conflicts with Typewriter Buffer

**What goes wrong:** The 30-second stall timer fires during the typewriter buffer's drain phase (after the last SSE event but before all characters are emitted to UI).
**Why it happens:** The stall timer monitors SSE events from the server. The `done` event is the last SSE event, but the typewriter buffer may still be dripping characters for several seconds after.
**How to avoid:** Cancel the stall timer when the `done` event is received. The stall timer protects against server-side stalls, not client-side rendering delays.
**Warning signs:** False stall errors appearing after successful responses with long text.

### Pitfall 3: Timer.periodic Drift Causes Memory Leaks

**What goes wrong:** `Timer.periodic` keeps running after the stream is cancelled or the widget is disposed.
**Why it happens:** The timer is not cancelled when the stream subscription is cancelled or the notifier is disposed.
**How to avoid:** Always cancel the timer in `TypewriterBuffer.dispose()`. Call `dispose()` from the service's cleanup logic. The Riverpod notifier's `ref.onDispose()` should trigger this chain.
**Warning signs:** Growing memory usage over time. Console warnings about operations on disposed objects.

### Pitfall 4: Retry Logic Sends Stale Auth Token

**What goes wrong:** After a network drop, the retry attempt uses a JWT that expired during the outage. The edge function returns 401.
**Why it happens:** `supabase_flutter` automatically refreshes tokens, but if the connection was dead, the refresh may not have happened yet.
**How to avoid:** `supabase_flutter` handles this internally -- the `functions.invoke()` call uses the current session token at the time of invocation. If the token is expired, the Supabase client refreshes it before the request. No manual intervention needed, but handle 401 gracefully just in case.
**Warning signs:** 401 errors on retry that succeed on manual retry seconds later.

### Pitfall 5: Blocking New Questions While Streaming

**What goes wrong:** User taps "send" while a response is still streaming, creating overlapping SSE connections.
**Why it happens:** No guard preventing concurrent requests.
**How to avoid:** The notifier should check `status != idle && status != completed && status != error` before allowing a new question. The CONTEXT.md explicitly requires: "New questions are blocked while a response is still streaming."
**Warning signs:** Garbled text from interleaved streams. Memory growth from orphaned stream subscriptions.

### Pitfall 6: Empty `delta` in `text_delta` Events

**What goes wrong:** The typewriter buffer receives empty string deltas, causing no-op emissions that waste timer cycles.
**Why it happens:** OpenAI streaming sometimes sends empty deltas (token boundaries, formatting markers).
**How to avoid:** Filter out empty deltas before adding to the typewriter buffer: `if (delta.isNotEmpty) buffer.addDelta(delta);`
**Warning signs:** Timer running with no visible text change. Slight performance overhead.

## Code Examples

### Complete SSE Connection Flow (Repository)

```dart
// Source: Verified from functions_client 2.5.0 source code at
// /Users/robsnider/.pub-cache/hosted/pub.dev/functions_client-2.5.0/lib/src/functions_client.dart
// Lines 176-177: when responseType == 'text/event-stream', data = response.stream (ByteStream)

final response = await supabase.functions.invoke(
  'chat',
  body: {'query': 'How many runs did I log this week?'},
);

// response.data is ByteStream when Content-Type is text/event-stream
final byteStream = response.data as http.ByteStream;

// Transform: bytes -> utf8 strings -> buffered SSE events -> ChatEvent objects
final events = byteStream
    .transform(const Utf8Decoder())
    .transform(SseEventTransformer())
    .map((jsonStr) => ChatEvent.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>));

await for (final event in events) {
  switch (event) {
    case ChatStepEvent(:final name, :final status):
      print('Step: $name ($status)');
    case ChatTextDeltaEvent(:final delta):
      print('Text: $delta');
    case ChatResponseIdEvent(:final responseId):
      print('Response ID: $responseId');
    case ChatConversionIdEvent(:final conversionId):
      print('Conversion ID: $conversionId');
    case ChatErrorEvent(:final message):
      print('Error: $message');
    case ChatDoneEvent():
      print('Done!');
  }
}
```

### SSE Event Protocol (Server-Side Reference)

From the actual edge function `streamHandler.ts` (Phase 1):

```
# Server sends these SSE events (each is a JSON object on a "data:" line):

data: {"type":"step","name":"Understanding your question...","status":"start"}

data: {"type":"step","name":"Understanding your question...","status":"complete"}

data: {"type":"conversion_id","conversionId":"resp_sql_abc123"}

data: {"type":"step","name":"Looking up your data...","status":"start"}

data: {"type":"step","name":"Looking up your data...","status":"complete"}

data: {"type":"text_delta","delta":"You logged "}

data: {"type":"text_delta","delta":"**5 runs** "}

data: {"type":"text_delta","delta":"this week!"}

data: {"type":"response_id","responseId":"resp_abc123"}

data: {"type":"done"}
```

### Auth Token Handling (Automatic)

```dart
// Source: Verified from functions_client 2.5.0 source code
// The FunctionsClient automatically includes the Authorization header
// from its internal _headers map. The SupabaseClient updates this
// via FunctionsClient.setAuth() whenever the session token changes.
//
// No manual token handling needed. Just call:
final response = await supabase.functions.invoke('chat', body: {...});
// The JWT is included automatically.
```

### Stall Detection Pattern

```dart
// In the service layer, wrap the event stream with a timeout between events
import 'dart:async';

Stream<ChatEvent> _withStallDetection(
  Stream<ChatEvent> source, {
  Duration stallTimeout = const Duration(seconds: 30),
}) async* {
  await for (final event in source.timeout(
    stallTimeout,
    onTimeout: (sink) {
      sink.addError(const ChatStallException());
      sink.close();
    },
  )) {
    yield event;
  }
}
```

### Exception Hierarchy

```dart
// Following existing codebase pattern: AppException base class with
// message (user-facing) and technicalDetails (logging)

import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for chat feature.
abstract class ChatException extends AppException {
  const ChatException(super.message, [super.technicalDetails]);
}

/// Connection lost or failed to establish.
class ChatConnectionException extends ChatException {
  const ChatConnectionException([String? technicalDetails])
      : super('Unable to connect. Please try again.', technicalDetails);
}

/// Auth token invalid or expired.
class ChatAuthException extends ChatException {
  const ChatAuthException()
      : super('Please sign in again to continue.', 'JWT expired or invalid');
}

/// User not subscribed to premium.
class ChatPremiumRequiredException extends ChatException {
  const ChatPremiumRequiredException()
      : super('Premium subscription required.', 'HTTP 403 premium_required');
}

/// Rate limit exceeded.
class ChatRateLimitException extends ChatException {
  const ChatRateLimitException()
      : super("You've been busy! Try again in a few minutes.", 'HTTP 429');
}

/// Stream stalled (no events for 30 seconds).
class ChatStallException extends ChatException {
  const ChatStallException()
      : super('Connection stalled. Please try again.', 'No SSE event for 30s');
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Third-party SSE packages (`flutter_client_sse`, `dart_sse`) | `supabase_flutter` built-in SSE via `functions_client` | Apr 2024 (PR #905) | No extra dependency needed; native integration with auth |
| `response.data as String` then manual parse | `response.data as ByteStream` for SSE content-type | functions_client 2.5.0 | Automatic content-type detection, proper streaming |
| Manual JWT header attachment for edge functions | Automatic via `supabase_flutter` session management | Already in project | Token refresh handled transparently |
| `flutter_chat_ui` 1.x with custom stream widgets | `flyer_chat_text_stream_message` 2.3.0 with `StreamState` | Already in project | Ready-made streaming text widget with loading/streaming/completed/error states |

**Deprecated/outdated:**
- `flutter_client_sse` package: Last updated Aug 2024, not needed since `functions_client` 2.5.0 has SSE support built in.
- `dart-archive/sse` package: Archived, was never intended for general-purpose SSE consumption.
- Manual `XMLHttpRequest` for Flutter Web SSE: Not needed for mobile; `fetch_client` workaround only needed on web if/when web target is added.

## Open Questions

1. **Web platform support for SSE streaming**
   - What we know: On mobile (iOS/Android), `supabase_flutter`'s SSE works with the default HTTP client. On Flutter Web, you need `fetch_client` with `RequestMode.cors` passed as the `httpClient` to `Supabase.initialize()`.
   - What's unclear: Whether Logly targets Flutter Web. The project appears mobile-only based on the dependencies (HealthKit, Google Sign-In native).
   - Recommendation: Skip web-specific SSE handling for now. If web support is needed later, add conditional `fetch_client` initialization in bootstrap.

2. **Typewriter buffer timing precision**
   - What we know: `Timer.periodic` has a minimum resolution of ~4ms on web (browser limitation) and ~1ms on mobile. The 5ms normal rate and 1ms drain rate are both achievable on mobile.
   - What's unclear: Whether 5ms per character produces the exact "ChatGPT feel" the user wants, or if tuning will be needed.
   - Recommendation: Make the intervals configurable constants. Start with 5ms normal / 1ms drain as decided. Easy to adjust during Phase 3 UI testing.

3. **Conversation ID handling across retry**
   - What we know: CONTEXT.md says "Previous response_id and conversion_id are preserved across failed requests -- user can retry a failed follow-up without losing context." Retry resends original question from scratch.
   - What's unclear: Whether the service should reset the IDs after a successful response (clearing for next question) or keep them until the user explicitly sends a new question.
   - Recommendation: Store IDs in the service after each successful response. Pass them to the next `sendQuestion()` call. Reset to null only when explicitly starting a fresh conversation (no previous IDs).

4. **FunctionException vs network error distinction**
   - What we know: `functions_client` throws `FunctionException` for non-2xx responses. Network errors (DNS, timeout, no connectivity) may throw different exception types (`SocketException`, `ClientException`, etc.).
   - What's unclear: The exact exception types for all failure modes.
   - Recommendation: Catch `FunctionException` specifically for HTTP status-based errors (401, 403, 429). Catch generic `Exception` for network errors. Log the actual exception type to discover edge cases during testing.

## Sources

### Primary (HIGH confidence)
- **functions_client 2.5.0 source** (`/Users/robsnider/.pub-cache/hosted/pub.dev/functions_client-2.5.0/lib/src/functions_client.dart`) -- Verified SSE handling: line 176 checks `text/event-stream`, line 177 returns `response.stream` as `ByteStream`
- **flyer_chat_text_stream_message 2.3.0 source** (`/Users/robsnider/.pub-cache/hosted/pub.dev/flyer_chat_text_stream_message-2.3.0/`) -- `StreamState` sealed class with Loading/Streaming/Completed/Error
- **Chat edge function source** (`/Users/robsnider/StudioProjects/logly/supabase/functions/chat/streamHandler.ts`) -- SSE event protocol: step, text_delta, response_id, conversion_id, error, done
- **Chat edge function pipeline** (`/Users/robsnider/StudioProjects/logly/supabase/functions/chat/pipeline.ts`) -- Event ordering and flow
- **Existing codebase patterns** -- Repository/Service/Provider patterns from activity_catalog, home, auth, settings features

### Secondary (MEDIUM confidence)
- [supabase-flutter PR #905](https://github.com/supabase/supabase-flutter/pull/905) -- SSE support implementation details
- [supabase-flutter Issue #948](https://github.com/supabase/supabase-flutter/issues/948) -- SSE chunk splitting bug and workarounds
- [supabase-flutter Issue #894](https://github.com/supabase/supabase-flutter/issues/894) -- SSE support request and community patterns
- [SSE Specification](https://html.spec.whatwg.org/multipage/server-sent-events.html) -- Event stream format: `data:` lines separated by `\n\n`

### Tertiary (LOW confidence)
- [Timer.periodic browser minimum of 4ms](https://api.flutter.dev/flutter/dart-async/Timer/Timer.periodic.html) -- Dart docs mention browser limitations
- [flutter_client_sse pub.dev](https://pub.dev/packages/flutter_client_sse) -- Alternative SSE package (not recommended)

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- `supabase_flutter` SSE support verified directly from installed source code; no new dependencies needed
- Architecture: HIGH -- Patterns follow existing codebase conventions (repository/service/provider); event model verified against actual edge function source
- SSE parsing: HIGH -- Chunk splitting issue documented in GitHub issue #948 with verified workaround; SSE spec is simple and well-understood
- Typewriter buffer: MEDIUM -- Timer-based approach is standard Dart; exact timing feel may need tuning during Phase 3 UI integration
- Stall detection: HIGH -- `Stream.timeout()` is built-in Dart; pattern is straightforward
- Retry logic: MEDIUM -- Single-retry logic is simple; edge cases around auth token refresh during retry are handled by `supabase_flutter` but not exhaustively tested

**Research date:** 2026-02-02
**Valid until:** 2026-03-04 (30 days -- stable domain, libraries well-established)
