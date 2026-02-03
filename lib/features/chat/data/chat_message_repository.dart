import 'package:logly/core/providers/supabase_provider.dart';
import 'package:logly/features/chat/domain/chat_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_message_repository.g.dart';

/// Repository for reading chat messages from Supabase.
///
/// This is a READ-ONLY repository. All writes are handled by the
/// edge function (backend owns persistence).
class ChatMessageRepository {
  ChatMessageRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Gets messages for a conversation, ordered by creation time.
  ///
  /// [limit] defaults to 50 messages for pagination.
  /// [offset] for scroll-up pagination (load older messages).
  Future<List<ChatMessage>> getByConversation(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _supabase
        .from('chat_messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .range(offset, offset + limit - 1);

    return (response as List<dynamic>).map((json) => _parseMessage(json as Map<String, dynamic>)).toList();
  }

  /// Gets the message count for a conversation.
  ///
  /// Useful for pagination calculations.
  Future<int> getCountByConversation(String conversationId) async {
    final response = await _supabase.from('chat_messages').select('message_id').eq('conversation_id', conversationId);

    return (response as List<dynamic>).length;
  }

  ChatMessage _parseMessage(Map<String, dynamic> json) {
    // Handle metadata parsing - it comes as JSONB from Supabase
    ChatMessageMetadata? metadata;
    if (json['metadata'] != null) {
      metadata = ChatMessageMetadata.fromJson(json['metadata'] as Map<String, dynamic>);
    }

    return ChatMessage(
      messageId: json['message_id'] as String,
      conversationId: json['conversation_id'] as String,
      role: ChatMessageRole.values.byName(json['role'] as String),
      content: json['content'] as String,
      metadata: metadata,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Provides the [ChatMessageRepository] instance.
@Riverpod(keepAlive: true)
ChatMessageRepository chatMessageRepository(Ref ref) {
  return ChatMessageRepository(ref.watch(supabaseProvider));
}
