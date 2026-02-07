import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logly/features/activity_catalog/domain/activity_summary.dart';

part 'voice_parse_response.freezed.dart';
part 'voice_parse_response.g.dart';

/// Response from the parse-voice-activity edge function.
///
/// Contains both the parsed activity data and matching activities.
@freezed
abstract class VoiceParseResponse with _$VoiceParseResponse {
  const factory VoiceParseResponse({
    /// The extracted activity data from the voice transcript.
    required VoiceParsedData parsed,

    /// Top matching activities from hybrid search.
    required List<ActivitySummary> activities,

    /// Optional telemetry ID for tracking voice parsing events.
    String? telemetryId,
  }) = _VoiceParseResponse;

  factory VoiceParseResponse.fromJson(Map<String, dynamic> json) =>
      _$VoiceParseResponseFromJson(json);
}

/// Parsed data extracted from a voice transcript by GPT-4o-mini.
@freezed
abstract class VoiceParsedData with _$VoiceParsedData {
  const factory VoiceParsedData({
    /// The normalized activity type for searching (e.g., "running", "yoga").
    required String activityQuery,

    /// Duration of the activity, if mentioned.
    VoiceDuration? duration,

    /// Distance covered, if mentioned.
    VoiceDistance? distance,

    /// When the activity happened, if mentioned.
    VoiceDate? date,

    /// Any additional context from the transcript.
    String? comments,
  }) = _VoiceParsedData;

  factory VoiceParsedData.fromJson(Map<String, dynamic> json) =>
      _$VoiceParsedDataFromJson(json);
}

/// Duration extracted from voice input.
@freezed
abstract class VoiceDuration with _$VoiceDuration {
  const factory VoiceDuration({
    /// Duration in seconds.
    required int seconds,
  }) = _VoiceDuration;

  factory VoiceDuration.fromJson(Map<String, dynamic> json) =>
      _$VoiceDurationFromJson(json);
}

/// Distance extracted from voice input.
@freezed
abstract class VoiceDistance with _$VoiceDistance {
  const factory VoiceDistance({
    /// Distance in meters.
    required double meters,

    /// The original numeric value mentioned.
    required double originalValue,

    /// The original unit mentioned (e.g., "miles", "km").
    required String originalUnit,
  }) = _VoiceDistance;

  factory VoiceDistance.fromJson(Map<String, dynamic> json) =>
      _$VoiceDistanceFromJson(json);
}

/// Date/time extracted from voice input.
@freezed
abstract class VoiceDate with _$VoiceDate {
  const factory VoiceDate({
    /// ISO 8601 date string.
    required String iso,

    /// The relative time phrase used (e.g., "this morning", "yesterday").
    String? relative,
  }) = _VoiceDate;

  factory VoiceDate.fromJson(Map<String, dynamic> json) =>
      _$VoiceDateFromJson(json);
}
