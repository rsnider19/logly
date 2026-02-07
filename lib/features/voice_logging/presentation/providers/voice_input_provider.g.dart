// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_input_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing the voice input flow.

@ProviderFor(VoiceInputStateNotifier)
final voiceInputStateProvider = VoiceInputStateNotifierProvider._();

/// State notifier for managing the voice input flow.
final class VoiceInputStateNotifierProvider
    extends $NotifierProvider<VoiceInputStateNotifier, VoiceInputState> {
  /// State notifier for managing the voice input flow.
  VoiceInputStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceInputStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceInputStateNotifierHash();

  @$internal
  @override
  VoiceInputStateNotifier create() => VoiceInputStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceInputState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceInputState>(value),
    );
  }
}

String _$voiceInputStateNotifierHash() =>
    r'be29a55cafbe8ef47068364a85670e80934a1a97';

/// State notifier for managing the voice input flow.

abstract class _$VoiceInputStateNotifier extends $Notifier<VoiceInputState> {
  VoiceInputState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VoiceInputState, VoiceInputState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VoiceInputState, VoiceInputState>,
              VoiceInputState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for storing voice prepopulation data.
///
/// This is consumed by LogActivityScreen to pre-fill form fields.

@ProviderFor(VoicePrepopulation)
final voicePrepopulationProvider = VoicePrepopulationProvider._();

/// Provider for storing voice prepopulation data.
///
/// This is consumed by LogActivityScreen to pre-fill form fields.
final class VoicePrepopulationProvider
    extends $NotifierProvider<VoicePrepopulation, VoiceParsedData?> {
  /// Provider for storing voice prepopulation data.
  ///
  /// This is consumed by LogActivityScreen to pre-fill form fields.
  VoicePrepopulationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voicePrepopulationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voicePrepopulationHash();

  @$internal
  @override
  VoicePrepopulation create() => VoicePrepopulation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceParsedData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceParsedData?>(value),
    );
  }
}

String _$voicePrepopulationHash() =>
    r'2bbd1bd10470d13e47086bec4e9f40ea5831bdde';

/// Provider for storing voice prepopulation data.
///
/// This is consumed by LogActivityScreen to pre-fill form fields.

abstract class _$VoicePrepopulation extends $Notifier<VoiceParsedData?> {
  VoiceParsedData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VoiceParsedData?, VoiceParsedData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VoiceParsedData?, VoiceParsedData?>,
              VoiceParsedData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
