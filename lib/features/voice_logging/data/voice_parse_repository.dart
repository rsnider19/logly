import 'package:logly/core/providers/logger_provider.dart';
import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/core/services/logger_service.dart';
import 'package:logly/features/voice_logging/domain/voice_parse_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'voice_parse_repository.g.dart';

/// Exception thrown when voice parsing fails.
class VoiceParseException implements Exception {
  VoiceParseException(this.message, [this.technicalDetails]);

  final String message;
  final String? technicalDetails;

  @override
  String toString() => message;
}

/// Repository for parsing voice transcripts via the edge function.
class VoiceParseRepository {
  VoiceParseRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Parses a voice transcript and returns matching activities.
  ///
  /// Calls the parse-voice-activity edge function which:
  /// 1. Uses GPT-4o-mini to extract activity data from the transcript
  /// 2. Searches for matching activities using hybrid search
  /// 3. Returns both parsed data and top 5 matching activities
  Future<VoiceParseResponse> parseAndSearch(String transcript) async {
    try {
      final now = DateTime.now();
      final offset = now.timeZoneOffset;
      final sign = offset.isNegative ? '-' : '+';
      final hours = offset.inHours.abs().toString().padLeft(2, '0');
      final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
      final utcOffset = '$sign$hours:$minutes';

      final response = await _supabase.functions.invoke(
        'parse-voice-activity',
        body: {
          'transcript': transcript,
          'timezone': now.timeZoneName,
          'utc_offset': utcOffset,
          'local_date': now.toIso8601String(),
        },
      );

      if (response.status != 200) {
        final errorData = response.data as Map<String, dynamic>?;
        final errorMessage = errorData?['error'] as String? ?? 'Unknown error';
        throw VoiceParseException(
          'Failed to process voice input',
          'Status ${response.status}: $errorMessage',
        );
      }

      final data = response.data as Map<String, dynamic>;
      return VoiceParseResponse.fromJson(data);
    } on FunctionException catch (e, st) {
      _logger.e('Voice parse function error', e, st);
      throw VoiceParseException(
        'Failed to process voice input. Please try again.',
        e.toString(),
      );
    } catch (e, st) {
      _logger.e('Failed to parse voice input', e, st);
      if (e is VoiceParseException) rethrow;
      throw VoiceParseException(
        'Failed to process voice input. Please try again.',
        e.toString(),
      );
    }
  }
}

@Riverpod(keepAlive: true)
VoiceParseRepository voiceParseRepository(Ref ref) {
  return VoiceParseRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
