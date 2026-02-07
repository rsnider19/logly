// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_filter_frequency_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryFilterFrequencyRepository)
final categoryFilterFrequencyRepositoryProvider =
    CategoryFilterFrequencyRepositoryProvider._();

final class CategoryFilterFrequencyRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryFilterFrequencyRepository,
          CategoryFilterFrequencyRepository,
          CategoryFilterFrequencyRepository
        >
    with $Provider<CategoryFilterFrequencyRepository> {
  CategoryFilterFrequencyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryFilterFrequencyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$categoryFilterFrequencyRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryFilterFrequencyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryFilterFrequencyRepository create(Ref ref) {
    return categoryFilterFrequencyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryFilterFrequencyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryFilterFrequencyRepository>(
        value,
      ),
    );
  }
}

String _$categoryFilterFrequencyRepositoryHash() =>
    r'ec4757383b31c4d8939d45a190269ed7ef363520';
