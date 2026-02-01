import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/onboarding/presentation/widgets/intro_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// Onboarding intro pager with 3 pages explaining the app.
class IntroPagerScreen extends StatefulWidget {
  const IntroPagerScreen({super.key});

  @override
  State<IntroPagerScreen> createState() => _IntroPagerScreenState();
}

class _IntroPagerScreenState extends State<IntroPagerScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<({IconData icon, String title, String description})> _pages = [
    (
      icon: LucideIcons.target,
      title: 'Track Everything',
      description: 'Log any activity from fitness to lifestyle. Build a complete picture of your daily habits.',
    ),
    (
      icon: LucideIcons.flame,
      title: 'Build Streaks',
      description: 'Stay consistent and build healthy habits. Watch your streaks grow day by day.',
    ),
    (
      icon: LucideIcons.lightbulb,
      title: 'Get Insights',
      description: 'AI-powered analysis of your activity patterns. Discover trends and optimize your routine.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToFavorites();
    }
  }

  void _navigateToFavorites() {
    context.go('/onboarding/questions');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _navigateToFavorites,
                  child: Text(
                    'Skip',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return IntroPage(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: WormEffect(
                  dotColor: theme.colorScheme.surfaceContainerHighest,
                  activeDotColor: theme.colorScheme.primary,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(isLastPage ? 'Get Started' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
