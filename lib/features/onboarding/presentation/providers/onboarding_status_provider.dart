import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:logly/features/onboarding/domain/profile_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_status_provider.g.dart';

/// Provides the current user's profile data including onboarding status.
@riverpod
Future<ProfileData> profileData(Ref ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.getProfile();
}

/// Provides whether the current user has completed onboarding.
@riverpod
Future<bool> onboardingCompleted(Ref ref) async {
  final profileDataAsync = await ref.watch(profileDataProvider.future);
  return profileDataAsync.onboardingCompleted;
}

/// Provides whether the current user is a returning user (has existing favorites).
@riverpod
Future<bool> isReturningUser(Ref ref) async {
  final service = ref.watch(onboardingServiceProvider);
  return service.isReturningUser();
}
