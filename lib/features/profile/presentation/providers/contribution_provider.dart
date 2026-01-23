import 'package:logly/features/profile/application/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contribution_provider.g.dart';

/// Provides contribution data (activity counts by day) for the last year.
@riverpod
Future<Map<DateTime, int>> contributionData(Ref ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getContributionData();
}
