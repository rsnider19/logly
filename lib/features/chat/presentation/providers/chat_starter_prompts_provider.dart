import 'package:logly/features/chat/data/chat_suggested_prompt_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_starter_prompts_provider.g.dart';

/// Provider for starter prompts shown in the empty chat state.
///
/// Fetches from Supabase on first access and caches the result.
/// Falls back to hardcoded prompts if the fetch fails.
@riverpod
Future<List<String>> chatStarterPrompts(Ref ref) async {
  final repository = ref.watch(chatSuggestedPromptRepositoryProvider);

  try {
    final prompts = await repository.getActivePrompts();
    if (prompts.isNotEmpty) return prompts;
  } catch (e) {
    // Log error but don't crash - fall back to defaults
  }

  // Fallback prompts if fetch fails or returns empty
  return const [
    'What did I do this week?',
    'What are my most consistent habits?',
    'How active was I last month?',
  ];
}
