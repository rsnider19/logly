// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the summary repository instance.

@ProviderFor(summaryRepository)
final summaryRepositoryProvider = SummaryRepositoryProvider._();

/// Provides the summary repository instance.

final class SummaryRepositoryProvider
    extends
        $FunctionalProvider<
          SummaryRepository,
          SummaryRepository,
          SummaryRepository
        >
    with $Provider<SummaryRepository> {
  /// Provides the summary repository instance.
  SummaryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'summaryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$summaryRepositoryHash();

  @$internal
  @override
  $ProviderElement<SummaryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SummaryRepository create(Ref ref) {
    return summaryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SummaryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SummaryRepository>(value),
    );
  }
}

String _$summaryRepositoryHash() => r'299f2e202829a147bb8d36eab952f478fd97d87d';
