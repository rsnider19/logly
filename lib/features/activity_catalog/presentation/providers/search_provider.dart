import 'dart:async';

import 'package:logly/features/activity_catalog/application/catalog_service.dart';
import 'package:logly/features/activity_catalog/domain/activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_provider.g.dart';

/// Holds the current search query text.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

/// Provides debounced search results.
///
/// Debounces by 300ms and requires minimum 2 characters.
@riverpod
Future<List<Activity>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);

  // Don't search if query is too short
  if (query.trim().length < 2) {
    return [];
  }

  // Debounce for 300ms
  await Future<void>.delayed(const Duration(milliseconds: 300));

  // Check if the query changed during the delay
  if (ref.watch(searchQueryProvider) != query) {
    throw Exception('Query changed');
  }

  final service = ref.watch(catalogServiceProvider);
  return service.searchActivities(query);
}
