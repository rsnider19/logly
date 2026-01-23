import 'package:logly/features/profile/application/profile_service.dart';
import 'package:logly/features/profile/domain/streak_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_provider.g.dart';

/// Provides the user's streak data.
@riverpod
Future<StreakData> streak(Ref ref) async {
  final service = ref.watch(profileServiceProvider);
  return service.getStreak();
}
