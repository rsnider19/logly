import 'dart:convert';

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
/// Opens authenticated SSE connections to the `chat` edge function and parses
/// the byte stream into typed [ChatEvent] domain objects. No business logic --
/// just data access following the repository pattern.
class ChatRepository {
  ChatRepository(this._supabase, this._logger);

  final SupabaseClient _supabase;
  final LoggerService _logger;

  /// Sends a question to the chat edge function and returns
  /// a stream of parsed [ChatEvent] objects.
  ///
  /// The Supabase client automatically attaches the user's JWT.
  /// Optional [previousResponseId] and [previousConversionId] enable
  /// follow-up question chaining. Optional [conversationId] continues
  /// an existing conversation.
  Stream<ChatEvent> sendQuestion({
    required String query,
    String? previousResponseId,
    String? previousConversionId,
    String? conversationId,
  }) async* {
    try {
      final response = await _supabase.functions.invoke(
        'chat',
        body: <String, dynamic>{
          'query': query,
          'previousResponseId': ?previousResponseId,
          'previousConversionId': ?previousConversionId,
          'conversationId': ?conversationId,
        },
      );

      // functions_client returns ByteStream (extends StreamView<List<int>>)
      // when Content-Type is text/event-stream.
      final byteStream = response.data as Stream<List<int>>;

      yield* byteStream
          .transform(const Utf8Decoder())
          .transform(const SseEventTransformer())
          .map((jsonStr) => ChatEvent.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>));
    } on FunctionException catch (e, st) {
      _logger.e('Chat function error: ${e.status} ${e.reasonPhrase}', e, st);
      switch (e.status) {
        case 401:
          throw const ChatAuthException();
        case 403:
          throw const ChatPremiumRequiredException();
        case 429:
          throw const ChatRateLimitException();
        default:
          throw ChatConnectionException(e.toString());
      }
    } catch (e, st) {
      _logger.e('Chat stream error', e, st);
      if (e is ChatException) rethrow;
      throw ChatConnectionException(e.toString());
    }
  }
}

/// Provides the [ChatRepository] instance.
@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(
    ref.watch(supabaseProvider),
    ref.watch(loggerProvider),
  );
}
