import 'package:flutter/material.dart';
import 'package:logly/core/services/analytics_service.dart';

/// Observes route changes and tracks screen views via [AnalyticsService].
///
/// Attached to [GoRouter.observers] to automatically track all navigation:
/// - Tab switches (StatefulShellRoute branch changes)
/// - Full-screen pushes and replacements
/// - Pop navigations (tracks the returned-to screen)
class AnalyticsRouteObserver extends NavigatorObserver {
  AnalyticsRouteObserver(this._analyticsService);

  final AnalyticsService _analyticsService;

  /// Exact route path -> friendly screen name.
  static const _screenNames = <String, String>{
    '/': 'Home',
    '/profile': 'Profile',
    '/settings': 'Settings',
    '/auth': 'Sign In',
    '/onboarding': 'Onboarding Intro',
    '/onboarding/questions': 'Onboarding Questions',
    '/onboarding/setup': 'Onboarding Setup',
    '/activities/search': 'Activity Search',
    '/activities/create': 'Create Custom Activity',
    '/chat': 'Chat',
    '/chat/history': 'Chat History',
    '/settings/favorites': 'Favorites',
    '/developer': 'Developer',
  };

  /// Patterns for parameterized routes.
  static final _parameterizedPatterns = <RegExp, String>{
    RegExp(r'^/activities/log/[^/]+$'): 'Log Activity',
    RegExp(r'^/activities/category/[^/]+$'): 'Category Detail',
    RegExp(r'^/activities/statistics/[^/]+$'): 'Activity Statistics',
    RegExp(r'^/activities/edit/[^/]+$'): 'Edit Activity',
    RegExp(r'^/favorites/category/[^/]+$'): 'Favorites Category Detail',
  };

  String? _resolveScreenName(Route<dynamic>? route) {
    final settings = route?.settings;
    if (settings == null) return null;

    final path = settings.name;
    if (path == null) return null;

    // Strip query parameters for matching
    final cleanPath = path.split('?').first;

    // Try exact match first
    final exactMatch = _screenNames[cleanPath];
    if (exactMatch != null) return exactMatch;

    // Try parameterized patterns
    for (final entry in _parameterizedPatterns.entries) {
      if (entry.key.hasMatch(cleanPath)) {
        return entry.value;
      }
    }

    return null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final screenName = _resolveScreenName(route);
    if (screenName != null) {
      _analyticsService.trackScreenViewed(screenName: screenName);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final screenName = _resolveScreenName(newRoute);
    if (screenName != null) {
      _analyticsService.trackScreenViewed(screenName: screenName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Track the screen being returned to
    final screenName = _resolveScreenName(previousRoute);
    if (screenName != null) {
      _analyticsService.trackScreenViewed(screenName: screenName);
    }
  }
}
