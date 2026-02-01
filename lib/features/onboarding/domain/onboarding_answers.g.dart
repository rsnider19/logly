// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_answers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingAnswers _$OnboardingAnswersFromJson(Map<String, dynamic> json) =>
    _OnboardingAnswers(
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      unitSystem: json['unit_system'] as String?,
      motivations:
          (json['motivations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      progressPreferences:
          (json['progress_preferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userDescriptors:
          (json['user_descriptors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OnboardingAnswersToJson(_OnboardingAnswers instance) =>
    <String, dynamic>{
      'gender': instance.gender,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'unit_system': instance.unitSystem,
      'motivations': instance.motivations,
      'progress_preferences': instance.progressPreferences,
      'user_descriptors': instance.userDescriptors,
    };
