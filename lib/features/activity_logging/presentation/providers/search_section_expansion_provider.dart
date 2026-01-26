import 'package:logly/core/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search_section_expansion_provider.g.dart';

/// Prefix for all search section expansion keys in SharedPreferences.
const String _keyPrefix = 'search_section_';

/// Section ID for the favorites section.
const String favoritesSectionId = 'favorites';

/// Creates a section ID for a category.
String categorySectionId(String categoryId) => 'category_$categoryId';

/// Manages expand/collapse state for search screen sections.
///
/// Persists state to SharedPreferences so expansion state is preserved
/// across app sessions. All sections default to expanded.
@Riverpod(keepAlive: true)
class SearchSectionExpansionStateNotifier extends _$SearchSectionExpansionStateNotifier {
  late SharedPreferences _prefs;

  @override
  Map<String, bool> build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return _loadFromPrefs();
  }

  /// Loads all search section expansion states from SharedPreferences.
  Map<String, bool> _loadFromPrefs() {
    final result = <String, bool>{};
    final keys = _prefs.getKeys().where((key) => key.startsWith(_keyPrefix));

    for (final key in keys) {
      final sectionId = key.substring(_keyPrefix.length);
      result[sectionId] = _prefs.getBool(key) ?? true;
    }

    return result;
  }

  /// Returns whether a section is expanded.
  ///
  /// Defaults to true (expanded) if not explicitly set.
  bool isExpanded(String sectionId) {
    return state[sectionId] ?? true;
  }

  /// Toggles the expansion state of a section.
  Future<void> toggle(String sectionId) async {
    final currentState = isExpanded(sectionId);
    final newState = !currentState;

    // Update state
    state = {...state, sectionId: newState};

    // Persist to SharedPreferences
    await _prefs.setBool('$_keyPrefix$sectionId', newState);
  }

  /// Resets all expansion states (clears from SharedPreferences).
  ///
  /// Call this during logout to clear user-specific preferences.
  Future<void> reset() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_keyPrefix)).toList();

    for (final key in keys) {
      await _prefs.remove(key);
    }

    state = {};
  }
}
