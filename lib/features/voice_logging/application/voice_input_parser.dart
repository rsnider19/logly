import 'package:logly/features/voice_logging/domain/voice_parse_result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'voice_input_parser.g.dart';

/// Service for parsing voice transcripts into structured activity data.
///
/// Uses regex-based extraction to identify:
/// - Duration (e.g., "45 minutes", "1 hour 30 mins", "2h30m")
/// - Distance (e.g., "5 miles", "10 km", "5k")
/// - Date/time (e.g., "this morning", "yesterday")
/// - Activity query (remaining meaningful text)
class VoiceInputParser {
  /// Parses a raw transcript into structured activity data.
  VoiceParseResult parse(String transcript) {
    final normalizedTranscript = transcript.toLowerCase().trim();

    final duration = extractDuration(normalizedTranscript);
    final distance = extractDistance(normalizedTranscript);
    final activityDate = extractDateTime(normalizedTranscript);
    final activityQuery = extractActivityQuery(normalizedTranscript);

    return VoiceParseResult(
      rawTranscript: transcript,
      activityQuery: activityQuery,
      durationSeconds: duration,
      distanceMeters: distance,
      activityDate: activityDate,
    );
  }

  /// Extracts duration from text and returns seconds.
  ///
  /// Supports patterns like:
  /// - "45 minutes", "45 min", "45m"
  /// - "1 hour", "2 hours", "1h"
  /// - "1 hour 30 minutes", "1h30m", "1 hour and 30 mins"
  int? extractDuration(String text) {
    // Pattern: hours and minutes combined (e.g., "1 hour 30 minutes", "1h30m")
    final hoursMinutesPattern = RegExp(
      r'(\d+)\s*h(?:ours?)?\s*(?:and\s*)?(\d+)\s*m(?:in(?:ute)?s?)?',
      caseSensitive: false,
    );
    final hoursMinutesMatch = hoursMinutesPattern.firstMatch(text);
    if (hoursMinutesMatch != null) {
      final hours = int.parse(hoursMinutesMatch.group(1)!);
      final minutes = int.parse(hoursMinutesMatch.group(2)!);
      return (hours * 60 + minutes) * 60;
    }

    // Pattern: hours only (e.g., "2 hours", "1h")
    final hoursPattern = RegExp(
      r'(\d+)\s*h(?:ours?)?(?!\s*\d)',
      caseSensitive: false,
    );
    final hoursMatch = hoursPattern.firstMatch(text);
    if (hoursMatch != null) {
      final hours = int.parse(hoursMatch.group(1)!);
      return hours * 60 * 60;
    }

    // Pattern: minutes only (e.g., "45 minutes", "30 min", "45m")
    final minutesPattern = RegExp(
      r'(\d+)\s*m(?:in(?:ute)?s?)?',
      caseSensitive: false,
    );
    final minutesMatch = minutesPattern.firstMatch(text);
    if (minutesMatch != null) {
      final minutes = int.parse(minutesMatch.group(1)!);
      return minutes * 60;
    }

    return null;
  }

  /// Extracts distance from text and returns meters.
  ///
  /// Supports patterns like:
  /// - "5 miles", "5 mi"
  /// - "10 km", "10 kilometers"
  /// - "5k" (interpreted as 5 kilometers)
  double? extractDistance(String text) {
    const metersPerMile = 1609.344;
    const metersPerKm = 1000.0;

    // Pattern: miles (e.g., "5 miles", "5.5 mi")
    final milesPattern = RegExp(
      r'(\d+(?:\.\d+)?)\s*(?:miles?|mi)\b',
      caseSensitive: false,
    );
    final milesMatch = milesPattern.firstMatch(text);
    if (milesMatch != null) {
      final miles = double.parse(milesMatch.group(1)!);
      return miles * metersPerMile;
    }

    // Pattern: kilometers (e.g., "10 km", "10 kilometers")
    final kmPattern = RegExp(
      r'(\d+(?:\.\d+)?)\s*(?:km|kilometers?|kilometres?)\b',
      caseSensitive: false,
    );
    final kmMatch = kmPattern.firstMatch(text);
    if (kmMatch != null) {
      final km = double.parse(kmMatch.group(1)!);
      return km * metersPerKm;
    }

    // Pattern: "5k" style (common for running)
    final kPattern = RegExp(
      r'(\d+(?:\.\d+)?)\s*k\b(?!m|ilo)',
      caseSensitive: false,
    );
    final kMatch = kPattern.firstMatch(text);
    if (kMatch != null) {
      final km = double.parse(kMatch.group(1)!);
      return km * metersPerKm;
    }

    return null;
  }

  /// Extracts date/time reference from text.
  ///
  /// Supports patterns like:
  /// - "this morning", "this afternoon", "this evening"
  /// - "yesterday", "today"
  /// - "yesterday morning", "yesterday at 6pm"
  DateTime? extractDateTime(String text) {
    final now = DateTime.now();

    // "this morning" - set to 8 AM today
    if (RegExp(r'\bthis\s+morning\b', caseSensitive: false).hasMatch(text)) {
      return DateTime(now.year, now.month, now.day, 8);
    }

    // "this afternoon" - set to 2 PM today
    if (RegExp(r'\bthis\s+afternoon\b', caseSensitive: false).hasMatch(text)) {
      return DateTime(now.year, now.month, now.day, 14);
    }

    // "this evening" - set to 6 PM today
    if (RegExp(r'\bthis\s+evening\b', caseSensitive: false).hasMatch(text)) {
      return DateTime(now.year, now.month, now.day, 18);
    }

    // "yesterday morning"
    if (RegExp(r'\byesterday\s+morning\b', caseSensitive: false).hasMatch(text)) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day, 8);
    }

    // "yesterday afternoon"
    if (RegExp(r'\byesterday\s+afternoon\b', caseSensitive: false).hasMatch(text)) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day, 14);
    }

    // "yesterday evening"
    if (RegExp(r'\byesterday\s+evening\b', caseSensitive: false).hasMatch(text)) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day, 18);
    }

    // "yesterday" (without time)
    if (RegExp(r'\byesterday\b', caseSensitive: false).hasMatch(text)) {
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day, now.hour, now.minute);
    }

    // "today at X" with time
    final todayAtPattern = RegExp(
      r'\btoday\s+at\s+(\d{1,2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    );
    final todayAtMatch = todayAtPattern.firstMatch(text);
    if (todayAtMatch != null) {
      var hour = int.parse(todayAtMatch.group(1)!);
      final minute = todayAtMatch.group(2) != null ? int.parse(todayAtMatch.group(2)!) : 0;
      final amPm = todayAtMatch.group(3)?.toLowerCase();

      if (amPm == 'pm' && hour < 12) hour += 12;
      if (amPm == 'am' && hour == 12) hour = 0;

      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    return null;
  }

  /// Extracts the activity query by removing extracted patterns and filler words.
  String extractActivityQuery(String text) {
    var query = text;

    // Remove duration patterns
    query = query.replaceAll(
      RegExp(r'\d+\s*h(?:ours?)?\s*(?:and\s*)?\d*\s*m(?:in(?:ute)?s?)?', caseSensitive: false),
      '',
    );
    query = query.replaceAll(
      RegExp(r'\d+\s*m(?:in(?:ute)?s?)?', caseSensitive: false),
      '',
    );
    query = query.replaceAll(
      RegExp(r'\d+\s*h(?:ours?)?', caseSensitive: false),
      '',
    );

    // Remove distance patterns
    query = query.replaceAll(
      RegExp(r'\d+(?:\.\d+)?\s*(?:miles?|mi|km|kilometers?|kilometres?)\b', caseSensitive: false),
      '',
    );
    query = query.replaceAll(
      RegExp(r'\d+(?:\.\d+)?\s*k\b(?!m|ilo)', caseSensitive: false),
      '',
    );

    // Remove date/time patterns
    query = query.replaceAll(
      RegExp(r'\b(?:this|yesterday)\s+(?:morning|afternoon|evening)\b', caseSensitive: false),
      '',
    );
    query = query.replaceAll(
      RegExp(r'\byesterday\b', caseSensitive: false),
      '',
    );
    query = query.replaceAll(
      RegExp(r'\btoday\s+at\s+\d{1,2}(?::\d{2})?\s*(?:am|pm)?\b', caseSensitive: false),
      '',
    );

    // Remove common filler words
    query = query.replaceAll(
      RegExp(r'\b(i|my|the|a|an|for|in|did|just|went|was|had|do|log|logged)\b', caseSensitive: false),
      '',
    );

    // Clean up whitespace
    query = query.replaceAll(RegExp(r'\s+'), ' ').trim();

    return query;
  }
}

@Riverpod(keepAlive: true)
VoiceInputParser voiceInputParser(VoiceInputParserRef ref) {
  return VoiceInputParser();
}
