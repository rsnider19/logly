// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the settings service instance.

@ProviderFor(settingsService)
final settingsServiceProvider = SettingsServiceProvider._();

/// Provides the settings service instance.

final class SettingsServiceProvider
    extends
        $FunctionalProvider<SettingsService, SettingsService, SettingsService>
    with $Provider<SettingsService> {
  /// Provides the settings service instance.
  SettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsService create(Ref ref) {
    return settingsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsService>(value),
    );
  }
}

String _$settingsServiceHash() => r'a75b4c378ea1a9605d387f28ab0006e941452497';
