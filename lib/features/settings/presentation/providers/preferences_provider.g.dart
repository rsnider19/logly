// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current user's preferences.

@ProviderFor(userPreferences)
final userPreferencesProvider = UserPreferencesProvider._();

/// Provides the current user's preferences.

final class UserPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserPreferences>,
          UserPreferences,
          FutureOr<UserPreferences>
        >
    with $FutureModifier<UserPreferences>, $FutureProvider<UserPreferences> {
  /// Provides the current user's preferences.
  UserPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<UserPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserPreferences> create(Ref ref) {
    return userPreferences(ref);
  }
}

String _$userPreferencesHash() => r'fb9453a5d1a71199a393617b55cd2b3da26320a0';

/// State notifier for managing user preferences.

@ProviderFor(PreferencesStateNotifier)
final preferencesStateProvider = PreferencesStateNotifierProvider._();

/// State notifier for managing user preferences.
final class PreferencesStateNotifierProvider
    extends $AsyncNotifierProvider<PreferencesStateNotifier, UserPreferences> {
  /// State notifier for managing user preferences.
  PreferencesStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesStateNotifierHash();

  @$internal
  @override
  PreferencesStateNotifier create() => PreferencesStateNotifier();
}

String _$preferencesStateNotifierHash() =>
    r'f2087c39ce8cb8fffebf1260431a393c0668b82e';

/// State notifier for managing user preferences.

abstract class _$PreferencesStateNotifier
    extends $AsyncNotifier<UserPreferences> {
  FutureOr<UserPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserPreferences>, UserPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserPreferences>, UserPreferences>,
              AsyncValue<UserPreferences>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provides the current theme mode, with a default fallback.

@ProviderFor(currentThemeMode)
final currentThemeModeProvider = CurrentThemeModeProvider._();

/// Provides the current theme mode, with a default fallback.

final class CurrentThemeModeProvider
    extends $FunctionalProvider<ThemeMode, ThemeMode, ThemeMode>
    with $Provider<ThemeMode> {
  /// Provides the current theme mode, with a default fallback.
  CurrentThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentThemeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentThemeModeHash();

  @$internal
  @override
  $ProviderElement<ThemeMode> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThemeMode create(Ref ref) {
    return currentThemeMode(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$currentThemeModeHash() => r'8f6e276a10eca5339e9386d61b71b6884a12fe3a';
