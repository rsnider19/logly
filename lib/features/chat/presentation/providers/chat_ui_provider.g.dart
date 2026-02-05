// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bridge provider that translates [ChatStreamState] emissions from the
/// stream layer into [InMemoryChatController] operations (insert, update,
/// remove) that the `flutter_chat_ui` Chat widget observes.
///
/// This is the central orchestration point between the SSE stream and
/// the chat UI. It maps each state transition (connecting, streaming,
/// completing, completed, error) into the corresponding controller
/// mutation.

@ProviderFor(ChatUiStateNotifier)
final chatUiStateProvider = ChatUiStateNotifierProvider._();

/// Bridge provider that translates [ChatStreamState] emissions from the
/// stream layer into [InMemoryChatController] operations (insert, update,
/// remove) that the `flutter_chat_ui` Chat widget observes.
///
/// This is the central orchestration point between the SSE stream and
/// the chat UI. It maps each state transition (connecting, streaming,
/// completing, completed, error) into the corresponding controller
/// mutation.
final class ChatUiStateNotifierProvider
    extends $NotifierProvider<ChatUiStateNotifier, InMemoryChatController> {
  /// Bridge provider that translates [ChatStreamState] emissions from the
  /// stream layer into [InMemoryChatController] operations (insert, update,
  /// remove) that the `flutter_chat_ui` Chat widget observes.
  ///
  /// This is the central orchestration point between the SSE stream and
  /// the chat UI. It maps each state transition (connecting, streaming,
  /// completing, completed, error) into the corresponding controller
  /// mutation.
  ChatUiStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatUiStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatUiStateNotifierHash();

  @$internal
  @override
  ChatUiStateNotifier create() => ChatUiStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InMemoryChatController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InMemoryChatController>(value),
    );
  }
}

String _$chatUiStateNotifierHash() =>
    r'a040c4cf0fc5c422a45034d22b6a676673575573';

/// Bridge provider that translates [ChatStreamState] emissions from the
/// stream layer into [InMemoryChatController] operations (insert, update,
/// remove) that the `flutter_chat_ui` Chat widget observes.
///
/// This is the central orchestration point between the SSE stream and
/// the chat UI. It maps each state transition (connecting, streaming,
/// completing, completed, error) into the corresponding controller
/// mutation.

abstract class _$ChatUiStateNotifier extends $Notifier<InMemoryChatController> {
  InMemoryChatController build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<InMemoryChatController, InMemoryChatController>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InMemoryChatController, InMemoryChatController>,
              InMemoryChatController,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
