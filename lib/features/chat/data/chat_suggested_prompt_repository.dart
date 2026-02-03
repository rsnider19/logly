import 'package:logly/core/providers/supabase_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_suggested_prompt_repository.g.dart';

/// Repository for fetching starter question prompts from Supabase.
///
/// Reads from the existing `ai_insight_suggested_prompt` table.
class ChatSuggestedPromptRepository {
  ChatSuggestedPromptRepository(this._supabase);

  final SupabaseClient _supabase;

  /// Fetches active starter prompts ordered by display_order.
  ///
  /// Returns a list of prompt strings to display in the empty chat state.
  Future<List<String>> getActivePrompts() async {
    final response = await _supabase
        .from('ai_insight_suggested_prompt')
        .select('prompt_text')
        .eq('is_active', true)
        .order('display_order');

    return (response as List<dynamic>)
        .map((row) => row['prompt_text'] as String)
        .toList();
  }
}

/// Provides the [ChatSuggestedPromptRepository] instance.
@Riverpod(keepAlive: true)
ChatSuggestedPromptRepository chatSuggestedPromptRepository(Ref ref) {
  return ChatSuggestedPromptRepository(ref.watch(supabaseProvider));
}
