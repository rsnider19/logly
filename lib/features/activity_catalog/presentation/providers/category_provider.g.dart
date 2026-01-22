// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides all activity categories.

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// Provides all activity categories.

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActivityCategory>>,
          List<ActivityCategory>,
          FutureOr<List<ActivityCategory>>
        >
    with
        $FutureModifier<List<ActivityCategory>>,
        $FutureProvider<List<ActivityCategory>> {
  /// Provides all activity categories.
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<ActivityCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActivityCategory>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'13304b4a354468f29acd1c3c5f38159727ceda2c';

/// Provides a single category by ID.

@ProviderFor(categoryById)
final categoryByIdProvider = CategoryByIdFamily._();

/// Provides a single category by ID.

final class CategoryByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityCategory>,
          ActivityCategory,
          FutureOr<ActivityCategory>
        >
    with $FutureModifier<ActivityCategory>, $FutureProvider<ActivityCategory> {
  /// Provides a single category by ID.
  CategoryByIdProvider._({
    required CategoryByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryByIdHash();

  @override
  String toString() {
    return r'categoryByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ActivityCategory> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActivityCategory> create(Ref ref) {
    final argument = this.argument as String;
    return categoryById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryByIdHash() => r'fbf4c70ed42c9924ffa2d88dc14af9be9468e356';

/// Provides a single category by ID.

final class CategoryByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ActivityCategory>, String> {
  CategoryByIdFamily._()
    : super(
        retry: null,
        name: r'categoryByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provides a single category by ID.

  CategoryByIdProvider call(String categoryId) =>
      CategoryByIdProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'categoryByIdProvider';
}
