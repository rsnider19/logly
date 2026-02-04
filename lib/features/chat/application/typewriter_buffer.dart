import 'dart:async';

/// Buffers incoming text deltas and emits characters at a controlled rate
/// to create a typewriter effect.
///
/// - Normal mode: 5ms per tick, 1 char/tick (200 chars/sec, smooth single-char drip)
/// - Drain mode (after done signal): 1ms per tick, 1 char/tick (fast drain)
///
/// Each emission on [stream] is the full accumulated text so far,
/// not just the new characters. This makes it easy for the UI to display
/// the latest emission directly.
class TypewriterBuffer {
  TypewriterBuffer({
    this.normalInterval = const Duration(milliseconds: 5),
    this.drainInterval = const Duration(milliseconds: 1),
  });

  /// Interval between character emissions during normal streaming.
  final Duration normalInterval;

  /// Faster interval used after [markDone] to drain remaining buffer.
  final Duration drainInterval;

  final StringBuffer _pendingBuffer = StringBuffer();
  final StringBuffer _emittedBuffer = StringBuffer();
  final StreamController<String> _controller = StreamController<String>.broadcast();
  Timer? _timer;
  bool _isDraining = false;
  bool _isDone = false;

  /// Stream of accumulated text. Each emission is the full text emitted so far.
  Stream<String> get stream => _controller.stream;

  /// The text that has been emitted (dripped) to the UI so far.
  String get currentText => _emittedBuffer.toString();

  /// The complete text including buffered-but-not-yet-displayed characters.
  String get fullText => _emittedBuffer.toString() + _pendingBuffer.toString();

  /// Whether the buffer has finished draining all characters after [markDone].
  bool get isComplete => _isDone && _pendingBuffer.isEmpty;

  /// Add a text delta to the pending buffer.
  ///
  /// Callers should filter empty deltas before calling this method.
  void addDelta(String delta) {
    _pendingBuffer.write(delta);
    _ensureTimerRunning();
  }

  /// Signal that no more deltas will arrive. Switches to faster drain interval.
  void markDone() {
    _isDone = true;
    _isDraining = true;
    // Restart timer with faster drain interval
    _timer?.cancel();
    _timer = null;
    _ensureTimerRunning();
  }

  void _ensureTimerRunning() {
    if (_timer != null) return;
    if (_pendingBuffer.isEmpty) {
      if (_isDone && !_controller.isClosed) {
        unawaited(_controller.close());
      }
      return;
    }

    final interval = _isDraining ? drainInterval : normalInterval;
    _timer = Timer.periodic(interval, (_) {
      if (_pendingBuffer.isEmpty) {
        _timer?.cancel();
        _timer = null;
        if (_isDone && !_controller.isClosed) {
          unawaited(_controller.close());
        }
        return;
      }

      final bufferStr = _pendingBuffer.toString();
      // Emit exactly 1 character per tick for smooth typewriter effect
      const chunkSize = 1;
      final chunk = bufferStr.substring(0, chunkSize);
      _pendingBuffer
        ..clear()
        ..write(bufferStr.substring(chunkSize));
      _emittedBuffer.write(chunk);
      if (!_controller.isClosed) {
        _controller.add(_emittedBuffer.toString());
      }
    });
  }

  /// Dispose resources. Cancels any running timer and closes the stream.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    if (!_controller.isClosed) {
      unawaited(_controller.close());
    }
  }
}
