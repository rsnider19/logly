import 'package:flutter/foundation.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/voice_logging/application/speech_service.dart';
import 'package:logly/features/voice_logging/data/voice_parse_repository.dart';
import 'package:logly/features/voice_logging/domain/voice_parse_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voice_input_provider.g.dart';

/// Status of the voice input flow.
enum VoiceInputStatus {
  /// Initial state, not yet started.
  idle,

  /// Checking/requesting microphone permission.
  requestingPermission,

  /// Permission was denied.
  permissionDenied,

  /// Actively listening for speech.
  listening,

  /// Processing the transcript (calling edge function).
  processing,

  /// Showing results (single match or disambiguation).
  showingResults,

  /// An error occurred.
  error,
}

/// State for the voice input flow.
@immutable
class VoiceInputState {
  const VoiceInputState({
    this.status = VoiceInputStatus.idle,
    this.partialTranscript,
    this.finalTranscript,
    this.parsedData,
    this.matchedActivities,
    this.errorMessage,
  });

  final VoiceInputStatus status;
  final String? partialTranscript;
  final String? finalTranscript;
  final VoiceParsedData? parsedData;
  final List<ActivitySummary>? matchedActivities;
  final String? errorMessage;

  VoiceInputState copyWith({
    VoiceInputStatus? status,
    String? partialTranscript,
    String? finalTranscript,
    VoiceParsedData? parsedData,
    List<ActivitySummary>? matchedActivities,
    String? errorMessage,
    bool clearPartial = false,
    bool clearFinal = false,
    bool clearParsed = false,
    bool clearMatches = false,
    bool clearError = false,
  }) {
    return VoiceInputState(
      status: status ?? this.status,
      partialTranscript: clearPartial ? null : (partialTranscript ?? this.partialTranscript),
      finalTranscript: clearFinal ? null : (finalTranscript ?? this.finalTranscript),
      parsedData: clearParsed ? null : (parsedData ?? this.parsedData),
      matchedActivities: clearMatches ? null : (matchedActivities ?? this.matchedActivities),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// State notifier for managing the voice input flow.
@riverpod
class VoiceInputStateNotifier extends _$VoiceInputStateNotifier {
  @override
  VoiceInputState build() {
    final speechService = ref.read(speechServiceProvider);
    ref.onDispose(speechService.cancelListening);
    return const VoiceInputState();
  }

  /// Starts the voice input session.
  Future<void> startListening() async {
    final speechService = ref.read(speechServiceProvider);

    // Check permissions
    state = state.copyWith(status: VoiceInputStatus.requestingPermission, clearError: true);

    final micPermission = await speechService.checkPermission();
    if (micPermission.isDenied) {
      final result = await speechService.requestPermission();
      if (!result.isGranted) {
        state = state.copyWith(
          status: VoiceInputStatus.permissionDenied,
          errorMessage: 'Microphone permission is required for voice logging',
        );
        return;
      }
    } else if (micPermission.isPermanentlyDenied) {
      state = state.copyWith(
        status: VoiceInputStatus.permissionDenied,
        errorMessage: 'Microphone permission was denied. Please enable it in Settings.',
      );
      return;
    }

    // Check speech recognition permission (iOS)
    final speechPermission = await speechService.checkSpeechPermission();
    if (speechPermission.isDenied) {
      final result = await speechService.requestSpeechPermission();
      if (!result.isGranted) {
        state = state.copyWith(
          status: VoiceInputStatus.permissionDenied,
          errorMessage: 'Speech recognition permission is required for voice logging',
        );
        return;
      }
    }

    // Check availability
    final isAvailable = await speechService.isAvailable();
    if (!isAvailable) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'Speech recognition is not available on this device',
      );
      return;
    }

    // Start listening
    state = state.copyWith(
      status: VoiceInputStatus.listening,
      clearPartial: true,
      clearFinal: true,
      clearParsed: true,
      clearMatches: true,
    );

    await speechService.startListening(
      onResult: _handleSpeechResult,
      onListeningComplete: _handleListeningComplete,
      onError: _handleError,
    );
  }

  void _handleSpeechResult(String text, bool isFinal) {
    if (isFinal) {
      state = state.copyWith(
        finalTranscript: text,
        partialTranscript: text,
      );
      _processTranscript(text);
    } else {
      state = state.copyWith(partialTranscript: text);
    }
  }

  void _handleListeningComplete() {
    // If we have a final transcript, process it
    if (state.finalTranscript != null && state.status == VoiceInputStatus.listening) {
      _processTranscript(state.finalTranscript!);
    } else if (state.partialTranscript != null && state.status == VoiceInputStatus.listening) {
      // Use partial transcript if no final was received
      _processTranscript(state.partialTranscript!);
    } else if (state.status == VoiceInputStatus.listening) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'No speech detected. Please try again.',
      );
    }
  }

  void _handleError(String error) {
    state = state.copyWith(
      status: VoiceInputStatus.error,
      errorMessage: error,
    );
  }

  Future<void> _processTranscript(String transcript) async {
    if (transcript.trim().isEmpty) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'No speech detected. Please try again.',
      );
      return;
    }

    state = state.copyWith(
      status: VoiceInputStatus.processing,
      finalTranscript: transcript,
    );

    try {
      // Call edge function to parse and search
      final repository = ref.read(voiceParseRepositoryProvider);
      final response = await repository.parseAndSearch(transcript);

      state = state.copyWith(
        status: VoiceInputStatus.showingResults,
        parsedData: response.parsed,
        matchedActivities: response.activities,
      );
    } on VoiceParseException catch (e) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'Failed to process voice input. Please try again.',
      );
    }
  }

  /// Stops listening and processes any partial results.
  Future<void> stopListening() async {
    final speechService = ref.read(speechServiceProvider);
    await speechService.stopListening();
  }

  /// Cancels the voice input session.
  void cancel() {
    final speechService = ref.read(speechServiceProvider);
    speechService.cancelListening();
    state = const VoiceInputState();
  }

  /// Resets the state for a new session.
  void reset() {
    state = const VoiceInputState();
  }
}

/// Provider for storing voice prepopulation data.
///
/// This is consumed by LogActivityScreen to pre-fill form fields.
@riverpod
class VoicePrepopulation extends _$VoicePrepopulation {
  @override
  VoiceParsedData? build() => null;

  /// Sets the prepopulation data.
  void set(VoiceParsedData data) {
    state = data;
  }

  /// Clears the prepopulation data.
  void clear() {
    state = null;
  }
}
