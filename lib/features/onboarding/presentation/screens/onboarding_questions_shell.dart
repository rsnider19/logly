import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:logly/features/onboarding/presentation/widgets/onboarding_top_bar.dart';
import 'package:logly/features/onboarding/presentation/widgets/transition_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/gender_question_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/birthday_question_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/units_question_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/motivations_question_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/progress_preferences_question_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/questions/user_descriptors_question_content.dart';

/// Shell screen for the "Getting to Know You" questions flow.
/// Page 0 = transition, Pages 1-6 = questions.
class OnboardingQuestionsShell extends ConsumerStatefulWidget {
  const OnboardingQuestionsShell({super.key});

  @override
  ConsumerState<OnboardingQuestionsShell> createState() => _OnboardingQuestionsShellState();
}

class _OnboardingQuestionsShellState extends ConsumerState<OnboardingQuestionsShell> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _totalQuestions = 6;

  /// Pages: [transition, gender, birthday, units, motivations, progressPrefs, userDescriptors]
  static const _totalPages = _totalQuestions + 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isTransition => _currentPage == 0;
  bool get _isFirstQuestion => _currentPage == 1;
  bool get _isLastQuestion => _currentPage == _totalPages - 1;

  /// Current segment for the progress bar (0 on transition, 1-6 on questions).
  int get _currentSegment => _currentPage;

  void _next() {
    if (_isLastQuestion) {
      // After last question, navigate to auth
      context.go('/auth');
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _next();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar - hidden on transition
            if (!_isTransition)
              OnboardingTopBar(
                totalSegments: _totalQuestions,
                currentSegment: _currentSegment,
                showBack: !_isFirstQuestion,
                showSkip: true,
                onBack: _back,
                onSkip: _skip,
              )
            else
              const SizedBox(height: 56),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: const [
                  TransitionContent(
                    icon: LucideIcons.userRound,
                    title: "Let's get to know you",
                    subtitle: 'Answer a few quick questions to personalize your experience.',
                  ),
                  GenderQuestionContent(),
                  BirthdayQuestionContent(),
                  UnitsQuestionContent(),
                  MotivationsQuestionContent(),
                  ProgressPreferencesQuestionContent(),
                  UserDescriptorsQuestionContent(),
                ],
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(_isTransition ? 'Continue' : (_isLastQuestion ? 'Done' : 'Continue')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
