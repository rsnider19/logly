// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ChatConversationRepository] instance.

@ProviderFor(chatConversationRepository)
final chatConversationRepositoryProvider =
    ChatConversationRepositoryProvider._();

/// Provides the [ChatConversationRepository] instance.

final class ChatConversationRepositoryProvider
    extends
        $FunctionalProvider<
          ChatConversationRepository,
          ChatConversationRepository,
          ChatConversationRepository
        >
    with $Provider<ChatConversationRepository> {
  /// Provides the [ChatConversationRepository] instance.
  ChatConversationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatConversationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatConversationRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatConversationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatConversationRepository create(Ref ref) {
    return chatConversationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatConversationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatConversationRepository>(value),
    );
  }
}

String _$chatConversationRepositoryHash() =>
    r'0ef6d8e33cfef45340546c771a989016fdc9b512';
