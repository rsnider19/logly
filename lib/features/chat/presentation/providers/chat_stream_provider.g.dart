// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_stream_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier exposing [ChatStreamState] to the UI layer.
///
/// Holds the current chat stream state and exposes [sendQuestion] to
/// initiate a new chat request. Blocks concurrent requests while a
/// response is still streaming.
///
/// Preserves `responseId` and `conversionId` across requests for
/// follow-up question chaining. Call [resetConversation] to start
/// a fresh conversation.

@ProviderFor(ChatStreamStateNotifier)
final chatStreamStateProvider = ChatStreamStateNotifierProvider._();

/// Riverpod notifier exposing [ChatStreamState] to the UI layer.
///
/// Holds the current chat stream state and exposes [sendQuestion] to
/// initiate a new chat request. Blocks concurrent requests while a
/// response is still streaming.
///
/// Preserves `responseId` and `conversionId` across requests for
/// follow-up question chaining. Call [resetConversation] to start
/// a fresh conversation.
final class ChatStreamStateNotifierProvider
    extends $NotifierProvider<ChatStreamStateNotifier, ChatStreamState> {
  /// Riverpod notifier exposing [ChatStreamState] to the UI layer.
  ///
  /// Holds the current chat stream state and exposes [sendQuestion] to
  /// initiate a new chat request. Blocks concurrent requests while a
  /// response is still streaming.
  ///
  /// Preserves `responseId` and `conversionId` across requests for
  /// follow-up question chaining. Call [resetConversation] to start
  /// a fresh conversation.
  ChatStreamStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatStreamStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatStreamStateNotifierHash();

  @$internal
  @override
  ChatStreamStateNotifier create() => ChatStreamStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatStreamState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatStreamState>(value),
    );
  }
}

String _$chatStreamStateNotifierHash() =>
    r'7d79e0a967515a297934967f354b6b9b29853385';

/// Riverpod notifier exposing [ChatStreamState] to the UI layer.
///
/// Holds the current chat stream state and exposes [sendQuestion] to
/// initiate a new chat request. Blocks concurrent requests while a
/// response is still streaming.
///
/// Preserves `responseId` and `conversionId` across requests for
/// follow-up question chaining. Call [resetConversation] to start
/// a fresh conversation.

abstract class _$ChatStreamStateNotifier extends $Notifier<ChatStreamState> {
  ChatStreamState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ChatStreamState, ChatStreamState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatStreamState, ChatStreamState>,
              ChatStreamState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
