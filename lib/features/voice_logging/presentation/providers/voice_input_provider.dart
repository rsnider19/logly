import 'package:flutter/foundation.dart';
import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';
import 'package:logly/features/voice_logging/application/speech_service.dart';
import 'package:logly/features/voice_logging/application/voice_input_parser.dart';
import 'package:logly/features/voice_logging/domain/voice_parse_result.dart';
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

  /// Processing the transcript.
  processing,

  /// Searching for matching activities.
  searchingActivities,

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
    this.parseResult,
    this.matchedActivities,
    this.errorMessage,
  });

  final VoiceInputStatus status;
  final String? partialTranscript;
  final String? finalTranscript;
  final VoiceParseResult? parseResult;
  final List<ActivitySummary>? matchedActivities;
  final String? errorMessage;

  VoiceInputState copyWith({
    VoiceInputStatus? status,
    String? partialTranscript,
    String? finalTranscript,
    VoiceParseResult? parseResult,
    List<ActivitySummary>? matchedActivities,
    String? errorMessage,
    bool clearPartial = false,
    bool clearFinal = false,
    bool clearParse = false,
    bool clearMatches = false,
    bool clearError = false,
  }) {
    return VoiceInputState(
      status: status ?? this.status,
      partialTranscript: clearPartial ? null : (partialTranscript ?? this.partialTranscript),
      finalTranscript: clearFinal ? null : (finalTranscript ?? this.finalTranscript),
      parseResult: clearParse ? null : (parseResult ?? this.parseResult),
      matchedActivities: clearMatches ? null : (matchedActivities ?? this.matchedActivities),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// State notifier for managing the voice input flow.
@riverpod
class VoiceInputStateNotifier extends _$VoiceInputStateNotifier {
  @override
  VoiceInputState build() => const VoiceInputState();

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
      clearParse: true,
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

    // Parse the transcript
    final parser = ref.read(voiceInputParserProvider);
    final parseResult = parser.parse(transcript);

    state = state.copyWith(
      parseResult: parseResult,
      status: VoiceInputStatus.searchingActivities,
    );

    // Search for matching activities
    if (parseResult.activityQuery.length < 2) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'Could not understand the activity. Please try again.',
      );
      return;
    }

    try {
      final catalogService = ref.read(catalogServiceProvider);
      final activities = await catalogService.searchActivitiesSummary(parseResult.activityQuery);

      if (activities.isEmpty) {
        state = state.copyWith(
          status: VoiceInputStatus.showingResults,
          matchedActivities: [],
        );
      } else {
        state = state.copyWith(
          status: VoiceInputStatus.showingResults,
          matchedActivities: activities,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: VoiceInputStatus.error,
        errorMessage: 'Failed to search activities: $e',
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
  VoiceParseResult? build() => null;

  /// Sets the prepopulation data.
  void set(VoiceParseResult result) {
    state = result;
  }

  /// Clears the prepopulation data.
  void clear() {
    state = null;
  }
}
