// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRoute,
  $authRoute,
  $onboardingIntroRoute,
  $onboardingFavoritesRoute,
  $onboardingHealthRoute,
  $activitySearchRoute,
  $logActivityRoute,
  $categoryDetailRoute,
  $editActivityRoute,
  $developerRoute,
];

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/profile', factory: $ProfileRoute._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [GoRouteData.$route(path: '/', factory: $HomeRoute._fromState)],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authRoute =>
    GoRouteData.$route(path: '/auth', factory: $AuthRoute._fromState);

mixin $AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  @override
  String get location => GoRouteData.$location('/auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingIntroRoute => GoRouteData.$route(
  path: '/onboarding',
  factory: $OnboardingIntroRoute._fromState,
);

mixin $OnboardingIntroRoute on GoRouteData {
  static OnboardingIntroRoute _fromState(GoRouterState state) =>
      const OnboardingIntroRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingFavoritesRoute => GoRouteData.$route(
  path: '/onboarding/favorites',
  factory: $OnboardingFavoritesRoute._fromState,
);

mixin $OnboardingFavoritesRoute on GoRouteData {
  static OnboardingFavoritesRoute _fromState(GoRouterState state) =>
      const OnboardingFavoritesRoute();

  @override
  String get location => GoRouteData.$location('/onboarding/favorites');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingHealthRoute => GoRouteData.$route(
  path: '/onboarding/health',
  factory: $OnboardingHealthRoute._fromState,
);

mixin $OnboardingHealthRoute on GoRouteData {
  static OnboardingHealthRoute _fromState(GoRouterState state) =>
      const OnboardingHealthRoute();

  @override
  String get location => GoRouteData.$location('/onboarding/health');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activitySearchRoute => GoRouteData.$route(
  path: '/activities/search',
  factory: $ActivitySearchRoute._fromState,
);

mixin $ActivitySearchRoute on GoRouteData {
  static ActivitySearchRoute _fromState(GoRouterState state) =>
      ActivitySearchRoute(date: state.uri.queryParameters['date']);

  ActivitySearchRoute get _self => this as ActivitySearchRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/search',
    queryParams: {if (_self.date != null) 'date': _self.date},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $logActivityRoute => GoRouteData.$route(
  path: '/activities/log/:activityId',
  factory: $LogActivityRoute._fromState,
);

mixin $LogActivityRoute on GoRouteData {
  static LogActivityRoute _fromState(GoRouterState state) => LogActivityRoute(
    activityId: state.pathParameters['activityId']!,
    date: state.uri.queryParameters['date'],
  );

  LogActivityRoute get _self => this as LogActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/log/${Uri.encodeComponent(_self.activityId)}',
    queryParams: {if (_self.date != null) 'date': _self.date},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoryDetailRoute => GoRouteData.$route(
  path: '/activities/category/:categoryId',
  factory: $CategoryDetailRoute._fromState,
);

mixin $CategoryDetailRoute on GoRouteData {
  static CategoryDetailRoute _fromState(GoRouterState state) =>
      CategoryDetailRoute(
        categoryId: state.pathParameters['categoryId']!,
        date: state.uri.queryParameters['date'],
      );

  CategoryDetailRoute get _self => this as CategoryDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/category/${Uri.encodeComponent(_self.categoryId)}',
    queryParams: {if (_self.date != null) 'date': _self.date},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editActivityRoute => GoRouteData.$route(
  path: '/activities/edit/:userActivityId',
  factory: $EditActivityRoute._fromState,
);

mixin $EditActivityRoute on GoRouteData {
  static EditActivityRoute _fromState(GoRouterState state) => EditActivityRoute(
    userActivityId: state.pathParameters['userActivityId']!,
  );

  EditActivityRoute get _self => this as EditActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/edit/${Uri.encodeComponent(_self.userActivityId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $developerRoute =>
    GoRouteData.$route(path: '/developer', factory: $DeveloperRoute._fromState);

mixin $DeveloperRoute on GoRouteData {
  static DeveloperRoute _fromState(GoRouterState state) =>
      const DeveloperRoute();

  @override
  String get location => GoRouteData.$location('/developer');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
