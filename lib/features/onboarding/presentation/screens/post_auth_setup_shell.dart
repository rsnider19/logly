import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_answers_provider.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_favorites_provider.dart';
import 'package:logly/features/onboarding/presentation/providers/onboarding_status_provider.dart';
import 'package:logly/features/onboarding/application/onboarding_service.dart';
import 'package:logly/features/onboarding/presentation/widgets/onboarding_top_bar.dart';
import 'package:logly/features/onboarding/presentation/widgets/transition_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/favorites_content.dart';
import 'package:logly/features/onboarding/presentation/widgets/health_content.dart';

/// Shell screen for the post-auth setup flow (favorites + health).
/// Page 0 = transition, Page 1 = favorites, Page 2 = health.
class PostAuthSetupShell extends ConsumerStatefulWidget {
  const PostAuthSetupShell({super.key});

  @override
  ConsumerState<PostAuthSetupShell> createState() => _PostAuthSetupShellState();
}

class _PostAuthSetupShellState extends ConsumerState<PostAuthSetupShell> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;
  bool _persistedAnswers = false;

  static const _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    _persistAnswers();
  }

  Future<void> _persistAnswers() async {
    if (_persistedAnswers) return;
    _persistedAnswers = true;
    try {
      await ref.read(onboardingAnswersStateProvider.notifier).persistToServer();
    } catch (e) {
      // Non-blocking: answers may be empty if user skipped all questions
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isTransition => _currentPage == 0;
  bool get _isFavorites => _currentPage == 1;
  bool get _isHealth => _currentPage == 2;

  int get _currentSegment => _currentPage;

  void _next() {
    if (_isHealth) {
      _completeOnboarding();
    } else if (_isFavorites) {
      _saveFavoritesAndAdvance();
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

  Future<void> _saveFavoritesAndAdvance() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(onboardingFavoritesStateProvider.notifier).saveFavorites();
      if (mounted) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save favorites: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final service = ref.read(onboardingServiceProvider);
      await service.completeOnboarding();
      ref.invalidate(profileDataProvider);
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete setup: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            if (!_isTransition)
              OnboardingTopBar(
                totalSegments: _totalSteps,
                currentSegment: _currentSegment,
                showBack: !_isFavorites,
                showSkip: false,
                onBack: _back,
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
                children: [
                  const TransitionContent(
                    icon: LucideIcons.settings,
                    title: 'Set up your activities',
                    subtitle: 'Choose your favorites and connect your health data.',
                  ),
                  const FavoritesContent(),
                  HealthContent(
                    onComplete: _completeOnboarding,
                  ),
                ],
              ),
            ),

            // Continue button (hidden on health page since it has its own buttons)
            if (!_isHealth)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_isSaving) ? null : _next,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
