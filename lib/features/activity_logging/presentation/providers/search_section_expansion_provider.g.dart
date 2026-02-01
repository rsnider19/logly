// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_section_expansion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages expand/collapse state for search screen sections.
///
/// Persists state to SharedPreferences so expansion state is preserved
/// across app sessions. All sections default to expanded.

@ProviderFor(SearchSectionExpansionStateNotifier)
final searchSectionExpansionStateProvider = SearchSectionExpansionStateNotifierProvider._();

/// Manages expand/collapse state for search screen sections.
///
/// Persists state to SharedPreferences so expansion state is preserved
/// across app sessions. All sections default to expanded.
final class SearchSectionExpansionStateNotifierProvider
    extends $NotifierProvider<SearchSectionExpansionStateNotifier, Map<String, bool>> {
  /// Manages expand/collapse state for search screen sections.
  ///
  /// Persists state to SharedPreferences so expansion state is preserved
  /// across app sessions. All sections default to expanded.
  SearchSectionExpansionStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchSectionExpansionStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchSectionExpansionStateNotifierHash();

  @$internal
  @override
  SearchSectionExpansionStateNotifier create() => SearchSectionExpansionStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$searchSectionExpansionStateNotifierHash() => r'c417fd367190b0e743ec7aef16047f53c1c1aab0';

/// Manages expand/collapse state for search screen sections.
///
/// Persists state to SharedPreferences so expansion state is preserved
/// across app sessions. All sections default to expanded.

abstract class _$SearchSectionExpansionStateNotifier extends $Notifier<Map<String, bool>> {
  Map<String, bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, bool>, Map<String, bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, bool>, Map<String, bool>>,
              Map<String, bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
