import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:logly/features/onboarding/domain/onboarding_answers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_answers_provider.g.dart';

/// State notifier for managing in-memory onboarding question answers.
@Riverpod(keepAlive: true)
class OnboardingAnswersStateNotifier extends _$OnboardingAnswersStateNotifier {
  @override
  OnboardingAnswers build() {
    return const OnboardingAnswers();
  }

  void setGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void setDateOfBirth(DateTime? dateOfBirth) {
    state = state.copyWith(dateOfBirth: dateOfBirth);
  }

  void setUnitSystem(String? unitSystem) {
    state = state.copyWith(unitSystem: unitSystem);
  }

  void toggleMotivation(String motivation) {
    final current = [...state.motivations];
    if (current.contains(motivation)) {
      current.remove(motivation);
    } else {
      current.add(motivation);
    }
    state = state.copyWith(motivations: current);
  }

  void toggleProgressPreference(String preference) {
    final current = [...state.progressPreferences];
    if (current.contains(preference)) {
      current.remove(preference);
    } else {
      current.add(preference);
    }
    state = state.copyWith(progressPreferences: current);
  }

  void toggleUserDescriptor(String descriptor) {
    final current = [...state.userDescriptors];
    if (current.contains(descriptor)) {
      current.remove(descriptor);
    } else {
      current.add(descriptor);
    }
    state = state.copyWith(userDescriptors: current);
  }

  /// Persists current answers to the server.
  Future<void> persistToServer() async {
    final service = ref.read(onboardingServiceProvider);
    await service.saveProfileAnswers(state);
  }

  void reset() {
    state = const OnboardingAnswers();
  }
}
