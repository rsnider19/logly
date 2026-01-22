import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_logging/presentation/screens/activity_search_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/edit_activity_screen.dart';
import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:logly/features/developer/presentation/screens/developer_screen.dart';
import 'package:logly/features/home/presentation/screens/home_screen.dart';
import 'package:logly/features/home/presentation/widgets/app_shell.dart';
import 'package:logly/features/profile/presentation/screens/profile_screen.dart';
import 'package:logly/features/settings/presentation/screens/settings_screen.dart';

part 'routes.g.dart';

/// Shell route providing consistent navigation wrapper.
@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(path: '/profile'),
      ],
    ),
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(path: '/'),
      ],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [
        TypedGoRoute<SettingsRoute>(path: '/settings'),
      ],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return AppShell(navigationShell: navigationShell);
  }
}

/// Branch for the profile tab.
class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();
}

/// Branch for the home tab.
class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

/// Branch for the settings tab.
class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

/// Home route - main screen of the app.
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

/// Profile route - user profile and stats.
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileScreen();
  }
}

/// Settings route - app settings screen.
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: SettingsScreen());
  }
}

/// Auth route - authentication screen.
@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInScreen();
  }
}

/// Activity search route - search and select activities to log.
@TypedGoRoute<ActivitySearchRoute>(path: '/activities/search')
class ActivitySearchRoute extends GoRouteData with $ActivitySearchRoute {
  const ActivitySearchRoute({this.date});

  /// Optional initial date for the activity (ISO 8601 string).
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? initialDate;
    if (date != null) {
      initialDate = DateTime.tryParse(date!);
    }
    return ActivitySearchScreen(initialDate: initialDate);
  }
}

/// Edit activity route - edit an existing logged activity.
@TypedGoRoute<EditActivityRoute>(path: '/activities/edit/:userActivityId')
class EditActivityRoute extends GoRouteData with $EditActivityRoute {
  const EditActivityRoute({required this.userActivityId});

  final String userActivityId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditActivityScreen(userActivityId: userActivityId);
  }
}

/// Developer route - debug tools and input testing.
///
/// Only accessible in debug mode.
@TypedGoRoute<DeveloperRoute>(path: '/developer')
class DeveloperRoute extends GoRouteData with $DeveloperRoute {
  const DeveloperRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (!kDebugMode) {
      return '/';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DeveloperScreen();
  }
}
