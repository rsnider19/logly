// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_parse_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(voiceParseRepository)
final voiceParseRepositoryProvider = VoiceParseRepositoryProvider._();

final class VoiceParseRepositoryProvider
    extends
        $FunctionalProvider<
          VoiceParseRepository,
          VoiceParseRepository,
          VoiceParseRepository
        >
    with $Provider<VoiceParseRepository> {
  VoiceParseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceParseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceParseRepositoryHash();

  @$internal
  @override
  $ProviderElement<VoiceParseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VoiceParseRepository create(Ref ref) {
    return voiceParseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceParseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceParseRepository>(value),
    );
  }
}

String _$voiceParseRepositoryHash() =>
    r'5e3e2e825b0b780b082567f12a9a425c8553697c';
