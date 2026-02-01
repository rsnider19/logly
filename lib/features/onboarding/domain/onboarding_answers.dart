import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_answers.freezed.dart';
part 'onboarding_answers.g.dart';

/// In-memory model holding pre-auth onboarding question answers.
@freezed
abstract class OnboardingAnswers with _$OnboardingAnswers {
  const factory OnboardingAnswers({
    String? gender,
    DateTime? dateOfBirth,
    String? unitSystem,
    @Default([]) List<String> motivations,
    @Default([]) List<String> progressPreferences,
    @Default([]) List<String> userDescriptors,
  }) = _OnboardingAnswers;

  factory OnboardingAnswers.fromJson(Map<String, dynamic> json) => _$OnboardingAnswersFromJson(json);
}
