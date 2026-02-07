// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_telemetry_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the voice telemetry service instance.

@ProviderFor(voiceTelemetryService)
final voiceTelemetryServiceProvider = VoiceTelemetryServiceProvider._();

/// Provides the voice telemetry service instance.

final class VoiceTelemetryServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<VoiceTelemetryService>,
          VoiceTelemetryService,
          FutureOr<VoiceTelemetryService>
        >
    with
        $FutureModifier<VoiceTelemetryService>,
        $FutureProvider<VoiceTelemetryService> {
  /// Provides the voice telemetry service instance.
  VoiceTelemetryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceTelemetryServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceTelemetryServiceHash();

  @$internal
  @override
  $FutureProviderElement<VoiceTelemetryService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VoiceTelemetryService> create(Ref ref) {
    return voiceTelemetryService(ref);
  }
}

String _$voiceTelemetryServiceHash() =>
    r'0445a891d1bee0e0de8b58c216e1b36103fb828f';
