// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_custom_activity_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier for managing the create custom activity form.

@ProviderFor(CreateCustomActivityFormStateNotifier)
final createCustomActivityFormStateProvider =
    CreateCustomActivityFormStateNotifierProvider._();

/// State notifier for managing the create custom activity form.
final class CreateCustomActivityFormStateNotifierProvider
    extends
        $NotifierProvider<
          CreateCustomActivityFormStateNotifier,
          CreateCustomActivityFormState
        > {
  /// State notifier for managing the create custom activity form.
  CreateCustomActivityFormStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomActivityFormStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$createCustomActivityFormStateNotifierHash();

  @$internal
  @override
  CreateCustomActivityFormStateNotifier create() =>
      CreateCustomActivityFormStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCustomActivityFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCustomActivityFormState>(
        value,
      ),
    );
  }
}

String _$createCustomActivityFormStateNotifierHash() =>
    r'a07facc9852fbc2890b5859ff2e9ceb5f9d65450';

/// State notifier for managing the create custom activity form.

abstract class _$CreateCustomActivityFormStateNotifier
    extends $Notifier<CreateCustomActivityFormState> {
  CreateCustomActivityFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              CreateCustomActivityFormState,
              CreateCustomActivityFormState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                CreateCustomActivityFormState,
                CreateCustomActivityFormState
              >,
              CreateCustomActivityFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for form validation state.

@ProviderFor(createCustomActivityValidation)
final createCustomActivityValidationProvider =
    CreateCustomActivityValidationProvider._();

/// Provider for form validation state.

final class CreateCustomActivityValidationProvider
    extends
        $FunctionalProvider<
          CreateCustomActivityValidation,
          CreateCustomActivityValidation,
          CreateCustomActivityValidation
        >
    with $Provider<CreateCustomActivityValidation> {
  /// Provider for form validation state.
  CreateCustomActivityValidationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomActivityValidationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCustomActivityValidationHash();

  @$internal
  @override
  $ProviderElement<CreateCustomActivityValidation> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateCustomActivityValidation create(Ref ref) {
    return createCustomActivityValidation(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCustomActivityValidation value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCustomActivityValidation>(
        value,
      ),
    );
  }
}

String _$createCustomActivityValidationHash() =>
    r'f103042327e7961ce6b18ea73cd08a007a82163a';
