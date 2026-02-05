// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides (categoryId, count) pairs for the selected time period.
///
/// Derives from [periodCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Simply extracts the appropriate column.

@ProviderFor(categorySummary)
final categorySummaryProvider = CategorySummaryProvider._();

/// Provides (categoryId, count) pairs for the selected time period.
///
/// Derives from [periodCategoryCountsProvider] which contains pre-aggregated
/// counts for all time periods. Simply extracts the appropriate column.

final class CategorySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// Provides (categoryId, count) pairs for the selected time period.
  ///
  /// Derives from [periodCategoryCountsProvider] which contains pre-aggregated
  /// counts for all time periods. Simply extracts the appropriate column.
  CategorySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categorySummaryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categorySummaryHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return categorySummary(ref);
  }
}

String _$categorySummaryHash() => r'd103b81ad6402a18281e0d841deee7f62e14cd44';
