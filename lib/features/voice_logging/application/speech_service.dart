import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_service.g.dart';

/// Service for handling speech-to-text functionality.
///
/// Wraps the speech_to_text package with permission handling and
/// provides a clean interface for voice input.
class SpeechService {
  SpeechService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;

  /// Checks if speech recognition is available on this device.
  Future<bool> isAvailable() async {
    if (!_initialized) {
      _initialized = await _speech.initialize(
        onError: _handleError,
        debugLogging: kDebugMode,
      );
    }
    return _initialized && _speech.isAvailable;
  }

  /// Checks the current microphone permission status.
  Future<PermissionStatus> checkPermission() async {
    return Permission.microphone.status;
  }

  /// Requests microphone permission.
  Future<PermissionStatus> requestPermission() async {
    return Permission.microphone.request();
  }

  /// Checks if speech recognition permission is granted (iOS-specific).
  Future<PermissionStatus> checkSpeechPermission() async {
    return Permission.speech.status;
  }

  /// Requests speech recognition permission (iOS-specific).
  Future<PermissionStatus> requestSpeechPermission() async {
    return Permission.speech.request();
  }

  /// Starts listening for speech input.
  ///
  /// [onResult] is called with partial and final results.
  /// [onListeningComplete] is called when listening stops.
  /// [onError] is called if an error occurs.
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    required VoidCallback onListeningComplete,
    required void Function(String error) onError,
    String localeId = 'en_US',
  }) async {
    if (!_initialized) {
      final available = await isAvailable();
      if (!available) {
        onError('Speech recognition is not available on this device');
        return;
      }
    }

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      partialResults: true,
      localeId: localeId,
      onSoundLevelChange: null,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  /// Stops listening and returns the final result.
  Future<void> stopListening() async {
    await _speech.stop();
  }

  /// Cancels listening without processing.
  Future<void> cancelListening() async {
    await _speech.cancel();
  }

  /// Whether the service is currently listening.
  bool get isListening => _speech.isListening;

  /// Whether the service is available.
  bool get isAvailableSync => _initialized && _speech.isAvailable;

  void _handleError(SpeechRecognitionError error) {
    debugPrint('Speech recognition error: ${error.errorMsg}');
  }
}

@Riverpod(keepAlive: true)
SpeechService speechService(SpeechServiceRef ref) {
  return SpeechService();
}
