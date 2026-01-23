// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collapsible_sections_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing collapsible section states.

@ProviderFor(CollapsibleSectionsStateNotifier)
final collapsibleSectionsStateProvider =
    CollapsibleSectionsStateNotifierProvider._();

/// Notifier for managing collapsible section states.
final class CollapsibleSectionsStateNotifierProvider
    extends
        $NotifierProvider<CollapsibleSectionsStateNotifier, Map<String, bool>> {
  /// Notifier for managing collapsible section states.
  CollapsibleSectionsStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collapsibleSectionsStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collapsibleSectionsStateNotifierHash();

  @$internal
  @override
  CollapsibleSectionsStateNotifier create() =>
      CollapsibleSectionsStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, bool>>(value),
    );
  }
}

String _$collapsibleSectionsStateNotifierHash() =>
    r'8714f961e8a73976fea9c72e66b3d9cffab6594b';

/// Notifier for managing collapsible section states.

abstract class _$CollapsibleSectionsStateNotifier
    extends $Notifier<Map<String, bool>> {
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
