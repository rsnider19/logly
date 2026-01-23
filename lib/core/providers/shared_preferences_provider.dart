import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Provides the SharedPreferences instance.
///
/// This provider must be overridden in the ProviderScope during app bootstrap
/// with an initialized SharedPreferences instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden with an initialized SharedPreferences instance',
  );
}
