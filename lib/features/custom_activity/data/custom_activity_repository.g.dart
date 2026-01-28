// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_activity_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the custom activity repository instance.

@ProviderFor(customActivityRepository)
final customActivityRepositoryProvider = CustomActivityRepositoryProvider._();

/// Provides the custom activity repository instance.

final class CustomActivityRepositoryProvider
    extends
        $FunctionalProvider<
          CustomActivityRepository,
          CustomActivityRepository,
          CustomActivityRepository
        >
    with $Provider<CustomActivityRepository> {
  /// Provides the custom activity repository instance.
  CustomActivityRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customActivityRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customActivityRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomActivityRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomActivityRepository create(Ref ref) {
    return customActivityRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomActivityRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomActivityRepository>(value),
    );
  }
}

String _$customActivityRepositoryHash() =>
    r'6336ebecb33ba6107a4acc8d7fff8f8dc8f45952';
