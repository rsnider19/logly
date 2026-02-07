import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_parse_result.freezed.dart';
part 'voice_parse_result.g.dart';

/// Result of parsing a voice transcript into structured activity data.
@freezed
abstract class VoiceParseResult with _$VoiceParseResult {
  const factory VoiceParseResult({
    /// The original transcript from speech recognition.
    required String rawTranscript,

    /// The extracted activity query for searching.
    required String activityQuery,

    /// Extracted duration in seconds (e.g., "45 minutes" -> 2700).
    int? durationSeconds,

    /// Extracted distance in meters (e.g., "5 miles" -> 8046.72).
    double? distanceMeters,

    /// Extracted date/time for the activity.
    DateTime? activityDate,

    /// Any remaining text that could be used as comments.
    String? comments,
  }) = _VoiceParseResult;

  factory VoiceParseResult.fromJson(Map<String, dynamic> json) => _$VoiceParseResultFromJson(json);
}
