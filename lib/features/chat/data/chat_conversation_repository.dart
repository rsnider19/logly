import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/features/chat/domain/chat_conversation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_conversation_repository.g.dart';

/// Repository for reading chat conversations from Supabase.
///
/// This is a READ-ONLY repository. All writes (except delete) are handled by the
/// edge function (backend owns persistence).
class ChatConversationRepository {
  ChatConversationRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Gets all conversations for the current user, ordered by most recent.
  ///
  /// Used for the conversation history list.
  Future<List<ChatConversation>> getAll({int limit = 50, int offset = 0}) async {
    final response = await _supabase
        .from('chat_conversations')
        .select()
        .order('updated_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List<dynamic>)
        .map((json) => ChatConversation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Gets a conversation by ID.
  Future<ChatConversation?> getById(String conversationId) async {
    final response = await _supabase
        .from('chat_conversations')
        .select()
        .eq('conversation_id', conversationId)
        .maybeSingle();

    if (response == null) return null;
    return ChatConversation.fromJson(response);
  }

  /// Deletes a conversation (cascades to messages via FK).
  ///
  /// This is the only write operation allowed from client - user-initiated delete.
  Future<void> delete(String conversationId) async {
    await _supabase.from('chat_conversations').delete().eq('conversation_id', conversationId);
  }
}

/// Provides the [ChatConversationRepository] instance.
@Riverpod(keepAlive: true)
ChatConversationRepository chatConversationRepository(Ref ref) {
  return ChatConversationRepository(ref.watch(supabaseProvider));
}
