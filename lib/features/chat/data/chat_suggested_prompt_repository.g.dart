// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_suggested_prompt_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ChatSuggestedPromptRepository] instance.

@ProviderFor(chatSuggestedPromptRepository)
final chatSuggestedPromptRepositoryProvider =
    ChatSuggestedPromptRepositoryProvider._();

/// Provides the [ChatSuggestedPromptRepository] instance.

final class ChatSuggestedPromptRepositoryProvider
    extends
        $FunctionalProvider<
          ChatSuggestedPromptRepository,
          ChatSuggestedPromptRepository,
          ChatSuggestedPromptRepository
        >
    with $Provider<ChatSuggestedPromptRepository> {
  /// Provides the [ChatSuggestedPromptRepository] instance.
  ChatSuggestedPromptRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSuggestedPromptRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSuggestedPromptRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatSuggestedPromptRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatSuggestedPromptRepository create(Ref ref) {
    return chatSuggestedPromptRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatSuggestedPromptRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatSuggestedPromptRepository>(
        value,
      ),
    );
  }
}

String _$chatSuggestedPromptRepositoryHash() =>
    r'fa3139a509a6e5648329d1078e6f646a61bf9eea';
