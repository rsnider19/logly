import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logly/features/activity_logging/presentation/screens/activity_search_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/activity_statistics_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/category_detail_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/edit_activity_screen.dart';
import 'package:logly/features/activity_logging/presentation/screens/log_activity_screen.dart';
import 'package:logly/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:logly/features/chat/presentation/screens/chat_screen.dart';
import 'package:logly/features/custom_activity/presentation/screens/create_custom_activity_screen.dart';
import 'package:logly/features/developer/presentation/screens/developer_screen.dart';
import 'package:logly/features/home/presentation/screens/home_screen.dart';
import 'package:logly/features/home/presentation/widgets/app_shell.dart';
import 'package:logly/features/onboarding/presentation/screens/favorites_category_detail_screen.dart';
import 'package:logly/features/onboarding/presentation/screens/intro_pager_screen.dart';
import 'package:logly/features/onboarding/presentation/screens/onboarding_questions_shell.dart';
import 'package:logly/features/onboarding/presentation/screens/post_auth_setup_shell.dart';
import 'package:logly/features/profile/presentation/screens/profile_screen.dart';
import 'package:logly/features/settings/presentation/screens/favorites_screen.dart';
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

/// Chat route - LoglyAI chat screen (full-screen push, not inside shell).
@TypedGoRoute<ChatRoute>(path: '/chat')
class ChatRoute extends GoRouteData with $ChatRoute {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatScreen();
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

/// Onboarding intro route - intro pager for new users.
@TypedGoRoute<OnboardingIntroRoute>(path: '/onboarding')
class OnboardingIntroRoute extends GoRouteData with $OnboardingIntroRoute {
  const OnboardingIntroRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const IntroPagerScreen();
  }
}

/// Onboarding questions route - getting to know you questions.
@TypedGoRoute<OnboardingQuestionsRoute>(path: '/onboarding/questions')
class OnboardingQuestionsRoute extends GoRouteData with $OnboardingQuestionsRoute {
  const OnboardingQuestionsRoute({this.source});

  /// When 'settings', the questions flow was launched from settings
  /// and should return there on completion.
  final String? source;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OnboardingQuestionsShell(source: source);
  }
}

/// Onboarding setup route - post-auth favorites and health setup.
@TypedGoRoute<OnboardingSetupRoute>(path: '/onboarding/setup')
class OnboardingSetupRoute extends GoRouteData with $OnboardingSetupRoute {
  const OnboardingSetupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PostAuthSetupShell();
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

/// Log activity route - log a new activity.
///
/// Fetches the full Activity on screen load by activityId.
@TypedGoRoute<LogActivityRoute>(path: '/activities/log/:activityId')
class LogActivityRoute extends GoRouteData with $LogActivityRoute {
  const LogActivityRoute({
    required this.activityId,
    this.date,
  });

  /// The ID of the activity to log.
  final String activityId;

  /// Optional initial date for the activity (ISO 8601 string).
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? initialDate;
    if (date != null) {
      initialDate = DateTime.tryParse(date!);
    }

    return LogActivityScreen(
      activityId: activityId,
      initialDate: initialDate,
    );
  }
}

/// Category detail route - view all activities in a category.
@TypedGoRoute<CategoryDetailRoute>(path: '/activities/category/:categoryId')
class CategoryDetailRoute extends GoRouteData with $CategoryDetailRoute {
  const CategoryDetailRoute({
    required this.categoryId,
    this.date,
  });

  /// The ID of the category to display.
  final String categoryId;

  /// Optional initial date for logging activities (ISO 8601 string).
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? initialDate;
    if (date != null) {
      initialDate = DateTime.tryParse(date!);
    }
    return CategoryDetailScreen(
      categoryId: categoryId,
      initialDate: initialDate,
    );
  }
}

/// Activity statistics route - view monthly statistics for an activity.
@TypedGoRoute<ActivityStatisticsRoute>(path: '/activities/statistics/:activityId')
class ActivityStatisticsRoute extends GoRouteData with $ActivityStatisticsRoute {
  const ActivityStatisticsRoute({
    required this.activityId,
    this.activityName,
    this.initialMonth,
    this.colorHex,
  });

  /// The ID of the activity to show statistics for.
  final String activityId;

  /// The display name of the activity.
  final String? activityName;

  /// Optional initial month to display (ISO 8601 string).
  final String? initialMonth;

  /// The hex color of the activity category (e.g. "#FF5733").
  final String? colorHex;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? parsedMonth;
    if (initialMonth != null) {
      parsedMonth = DateTime.tryParse(initialMonth!);
    }
    return ActivityStatisticsScreen(
      activityId: activityId,
      activityName: activityName ?? 'Statistics',
      initialMonth: parsedMonth,
      colorHex: colorHex,
    );
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

/// Create custom activity route - create a new custom activity.
@TypedGoRoute<CreateCustomActivityRoute>(path: '/activities/create')
class CreateCustomActivityRoute extends GoRouteData with $CreateCustomActivityRoute {
  const CreateCustomActivityRoute({this.name, this.date});

  /// Pre-populated activity name from search query.
  final String? name;

  /// Optional initial date for the activity (ISO 8601 string).
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    DateTime? initialDate;
    if (date != null) {
      initialDate = DateTime.tryParse(date!);
    }
    return CreateCustomActivityScreen(
      initialName: name,
      initialDate: initialDate,
    );
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

/// Settings favorites route - select favorite activities.
@TypedGoRoute<SettingsFavoritesRoute>(path: '/settings/favorites')
class SettingsFavoritesRoute extends GoRouteData with $SettingsFavoritesRoute {
  const SettingsFavoritesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FavoritesScreen();
  }
}

/// Favorites category detail route - view all activities in a category for favorite toggling.
@TypedGoRoute<FavoritesCategoryDetailRoute>(path: '/favorites/category/:categoryId')
class FavoritesCategoryDetailRoute extends GoRouteData with $FavoritesCategoryDetailRoute {
  const FavoritesCategoryDetailRoute({required this.categoryId});

  /// The ID of the category to display.
  final String categoryId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FavoritesCategoryDetailScreen(categoryId: categoryId);
  }
}
