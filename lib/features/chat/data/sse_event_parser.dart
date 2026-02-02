import 'dart:async';

/// Transforms a stream of arbitrary string chunks into complete SSE event payloads.
///
/// SSE events are delimited by double newlines (`\n\n`). Each event line starts with
/// `data: ` followed by JSON. This transformer buffers partial chunks and emits
/// only complete, parseable event data strings.
///
/// This is critical because the `ByteStream` from `functions_client` splits data
/// arbitrarily at TCP boundaries -- a JSON object may span multiple chunks.
class SseEventTransformer extends StreamTransformerBase<String, String> {
  /// Creates an [SseEventTransformer].
  const SseEventTransformer();

  @override
  Stream<String> bind(Stream<String> stream) {
    return Stream.eventTransformed(stream, _SseEventSink.new);
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
