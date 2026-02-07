import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:logly/core/services/analytics_service.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
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
///
/// When [source] is 'settings', the transition page is skipped and
/// completion navigates back to settings instead of to auth.
class OnboardingQuestionsShell extends ConsumerStatefulWidget {
  const OnboardingQuestionsShell({super.key, this.source});

  /// When 'settings', the flow was launched from settings.
  final String? source;

  @override
  ConsumerState<OnboardingQuestionsShell> createState() => _OnboardingQuestionsShellState();
}

class _OnboardingQuestionsShellState extends ConsumerState<OnboardingQuestionsShell> {
  late final PageController _pageController;
  late int _currentPage;

  bool get _isFromSettings => widget.source == 'settings';

  static const _totalQuestions = 6;

  /// Pages: [transition, gender, birthday, units, motivations, progressPrefs, userDescriptors]
  static const _totalPages = _totalQuestions + 1;

  static const _stepNames = [
    'transition',
    'gender',
    'birthday',
    'units',
    'motivations',
    'progress_preferences',
    'user_descriptors',
  ];

  @override
  void initState() {
    super.initState();
    // When coming from settings, skip the transition page
    final initialPage = _isFromSettings ? 1 : 0;
    _pageController = PageController(initialPage: initialPage);
    _currentPage = initialPage;
  }

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

  Future<void> _next() async {
    ref.read(analyticsServiceProvider).trackOnboardingStepCompleted(
      stepName: _stepNames[_currentPage],
      stepNumber: _currentPage,
      skipped: false,
    );

    if (_isLastQuestion) {
      if (_isFromSettings) {
        // Persist answers and return to settings
        await ref.read(onboardingAnswersStateProvider.notifier).persistToServer();
        ref.invalidate(hasAnsweredProfileQuestionsProvider);
        if (mounted) context.go('/settings');
      } else {
        // After last question, navigate to auth
        context.go('/auth');
      }
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _back() {
    if (_isFromSettings && _isFirstQuestion) {
      // Return to settings when pressing back on first question
      context.go('/settings');
      return;
    }
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    ref.read(analyticsServiceProvider).trackOnboardingStepCompleted(
      stepName: _stepNames[_currentPage],
      stepNumber: _currentPage,
      skipped: true,
    );
    context.go('/auth');
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
                showBack: _isFromSettings || !_isFirstQuestion,
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
