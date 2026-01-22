import 'package:logly/features/home/application/home_service.dart';
import 'package:logly/features/home/domain/trending_activity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trending_provider.g.dart';

/// Provides trending activities globally.
@riverpod
Future<List<TrendingActivity>> trendingActivities(Ref ref) async {
  final service = ref.watch(homeServiceProvider);
  return service.getTrendingActivities();
}
