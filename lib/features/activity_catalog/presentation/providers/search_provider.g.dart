// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the current search query text.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// Holds the current search query text.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// Holds the current search query text.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'b07ebd22fb9cb0db36c8d833cc6e21f4fcbd9b7b';

/// Holds the current search query text.

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provides debounced search results as lightweight summaries.
///
/// Debounces by 300ms and requires minimum 2 characters.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Provides debounced search results as lightweight summaries.
///
/// Debounces by 300ms and requires minimum 2 characters.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivitySummary>>,
          List<ActivitySummary>,
          FutureOr<List<ActivitySummary>>
        >
    with
        $FutureModifier<List<ActivitySummary>>,
        $FutureProvider<List<ActivitySummary>> {
  /// Provides debounced search results as lightweight summaries.
  ///
  /// Debounces by 300ms and requires minimum 2 characters.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivitySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivitySummary>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'5c67170f72878ab0c83208479a1a5bc2745e0aab';
