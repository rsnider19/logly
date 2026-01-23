import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_data.freezed.dart';
part 'profile_data.g.dart';

/// User profile data including onboarding status.
@freezed
abstract class ProfileData with _$ProfileData {
  const factory ProfileData({
    required String userId,
    required DateTime createdAt,
    required bool onboardingCompleted,
    DateTime? lastHealthSyncDate,
  }) = _ProfileData;

  factory ProfileData.fromJson(Map<String, dynamic> json) => _$ProfileDataFromJson(json);
}
