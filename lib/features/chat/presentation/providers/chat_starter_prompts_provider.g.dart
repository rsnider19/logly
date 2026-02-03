// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_starter_prompts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for starter prompts shown in the empty chat state.
///
/// Fetches from Supabase on first access and caches the result.
/// Falls back to hardcoded prompts if the fetch fails.

@ProviderFor(chatStarterPrompts)
final chatStarterPromptsProvider = ChatStarterPromptsProvider._();

/// Provider for starter prompts shown in the empty chat state.
///
/// Fetches from Supabase on first access and caches the result.
/// Falls back to hardcoded prompts if the fetch fails.

final class ChatStarterPromptsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Provider for starter prompts shown in the empty chat state.
  ///
  /// Fetches from Supabase on first access and caches the result.
  /// Falls back to hardcoded prompts if the fetch fails.
  ChatStarterPromptsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatStarterPromptsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatStarterPromptsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return chatStarterPrompts(ref);
  }
}

String _$chatStarterPromptsHash() =>
    r'88addcc16d5389acd0058fb7114c2354fd61c8e0';
