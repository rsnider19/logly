import 'dart:convert';

import 'package:logly/core/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'category_filter_frequency_repository.g.dart';

/// Repository for tracking how often each category filter chip is toggled ON.
///
/// Stores a JSON-encoded `Map<String, int>` in SharedPreferences.
/// Used to sort category chips by usage frequency on screen load.
class CategoryFilterFrequencyRepository {
  CategoryFilterFrequencyRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _prefsKey = 'category_filter_frequencies';

  /// Returns the frequency map: categoryId -> toggle-on count.
  Map<String, int> getFrequencies() {
    final json = _prefs.getString(_prefsKey);
    if (json == null) return {};
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  /// Increments the toggle-on count for a category.
  Future<void> incrementFrequency(String categoryId) async {
    final frequencies = getFrequencies();
    frequencies[categoryId] = (frequencies[categoryId] ?? 0) + 1;
    await _prefs.setString(_prefsKey, jsonEncode(frequencies));
  }
}

@Riverpod(keepAlive: true)
CategoryFilterFrequencyRepository categoryFilterFrequencyRepository(Ref ref) {
  return CategoryFilterFrequencyRepository(
    ref.watch(sharedPreferencesProvider),
  );
}
