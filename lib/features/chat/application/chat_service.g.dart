// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the [ChatService] instance.

@ProviderFor(chatService)
final chatServiceProvider = ChatServiceProvider._();

/// Provides the [ChatService] instance.

final class ChatServiceProvider
    extends $FunctionalProvider<ChatService, ChatService, ChatService>
    with $Provider<ChatService> {
  /// Provides the [ChatService] instance.
  ChatServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatServiceHash();

  @$internal
  @override
  $ProviderElement<ChatService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatService create(Ref ref) {
    return chatService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatService>(value),
    );
  }
}

String _$chatServiceHash() => r'770102d4f3f3130b226aba0ca5fa0e82e357c074';
