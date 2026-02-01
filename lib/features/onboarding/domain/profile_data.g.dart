// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => _ProfileData(
  userId: json['user_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  onboardingCompleted: json['onboarding_completed'] as bool,
  lastHealthSyncDate: json['last_health_sync_date'] == null
      ? null
      : DateTime.parse(json['last_health_sync_date'] as String),
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  motivations: const _JsonbStringListConverter().fromJson(json['motivations']),
  progressPreferences: const _JsonbStringListConverter().fromJson(
    json['progress_preferences'],
  ),
  userDescriptors: const _JsonbStringListConverter().fromJson(
    json['user_descriptors'],
  ),
);

Map<String, dynamic> _$ProfileDataToJson(_ProfileData instance) => <String, dynamic>{
  'user_id': instance.userId,
  'created_at': instance.createdAt.toIso8601String(),
  'onboarding_completed': instance.onboardingCompleted,
  'last_health_sync_date': instance.lastHealthSyncDate?.toIso8601String(),
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'motivations': const _JsonbStringListConverter().toJson(instance.motivations),
  'progress_preferences': const _JsonbStringListConverter().toJson(
    instance.progressPreferences,
  ),
  'user_descriptors': const _JsonbStringListConverter().toJson(
    instance.userDescriptors,
  ),
};
