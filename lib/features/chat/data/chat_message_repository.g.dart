// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ChatMessageRepository] instance.

@ProviderFor(chatMessageRepository)
final chatMessageRepositoryProvider = ChatMessageRepositoryProvider._();

/// Provides the [ChatMessageRepository] instance.

final class ChatMessageRepositoryProvider
    extends
        $FunctionalProvider<
          ChatMessageRepository,
          ChatMessageRepository,
          ChatMessageRepository
        >
    with $Provider<ChatMessageRepository> {
  /// Provides the [ChatMessageRepository] instance.
  ChatMessageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatMessageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatMessageRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatMessageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChatMessageRepository create(Ref ref) {
    return chatMessageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatMessageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatMessageRepository>(value),
    );
  }
}

String _$chatMessageRepositoryHash() =>
    r'5a67443279fc4a29a5a3db8b49c1016e00e497b5';
