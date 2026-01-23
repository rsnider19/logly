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
);

Map<String, dynamic> _$ProfileDataToJson(_ProfileData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'onboarding_completed': instance.onboardingCompleted,
      'last_health_sync_date': instance.lastHealthSyncDate?.toIso8601String(),
    };
