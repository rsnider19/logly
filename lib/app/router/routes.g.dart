// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRoute,
  $authRoute,
  $onboardingIntroRoute,
  $onboardingQuestionsRoute,
  $onboardingSetupRoute,
  $activitySearchRoute,
  $logActivityRoute,
  $categoryDetailRoute,
  $activityStatisticsRoute,
  $editActivityRoute,
  $createCustomActivityRoute,
  $developerRoute,
  $settingsFavoritesRoute,
  $favoritesCategoryDetailRoute,
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

RouteBase get $onboardingQuestionsRoute => GoRouteData.$route(
  path: '/onboarding/questions',
  factory: $OnboardingQuestionsRoute._fromState,
);

mixin $OnboardingQuestionsRoute on GoRouteData {
  static OnboardingQuestionsRoute _fromState(GoRouterState state) =>
      OnboardingQuestionsRoute(source: state.uri.queryParameters['source']);

  OnboardingQuestionsRoute get _self => this as OnboardingQuestionsRoute;

  @override
  String get location => GoRouteData.$location(
    '/onboarding/questions',
    queryParams: {if (_self.source != null) 'source': _self.source},
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

RouteBase get $onboardingSetupRoute => GoRouteData.$route(
  path: '/onboarding/setup',
  factory: $OnboardingSetupRoute._fromState,
);

mixin $OnboardingSetupRoute on GoRouteData {
  static OnboardingSetupRoute _fromState(GoRouterState state) =>
      const OnboardingSetupRoute();

  @override
  String get location => GoRouteData.$location('/onboarding/setup');

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

RouteBase get $activityStatisticsRoute => GoRouteData.$route(
  path: '/activities/statistics/:activityId',
  factory: $ActivityStatisticsRoute._fromState,
);

mixin $ActivityStatisticsRoute on GoRouteData {
  static ActivityStatisticsRoute _fromState(GoRouterState state) =>
      ActivityStatisticsRoute(
        activityId: state.pathParameters['activityId']!,
        activityName: state.uri.queryParameters['activity-name'],
        initialMonth: state.uri.queryParameters['initial-month'],
        colorHex: state.uri.queryParameters['color-hex'],
      );

  ActivityStatisticsRoute get _self => this as ActivityStatisticsRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/statistics/${Uri.encodeComponent(_self.activityId)}',
    queryParams: {
      if (_self.activityName != null) 'activity-name': _self.activityName,
      if (_self.initialMonth != null) 'initial-month': _self.initialMonth,
      if (_self.colorHex != null) 'color-hex': _self.colorHex,
    },
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

RouteBase get $createCustomActivityRoute => GoRouteData.$route(
  path: '/activities/create',
  factory: $CreateCustomActivityRoute._fromState,
);

mixin $CreateCustomActivityRoute on GoRouteData {
  static CreateCustomActivityRoute _fromState(GoRouterState state) =>
      CreateCustomActivityRoute(
        name: state.uri.queryParameters['name'],
        date: state.uri.queryParameters['date'],
      );

  CreateCustomActivityRoute get _self => this as CreateCustomActivityRoute;

  @override
  String get location => GoRouteData.$location(
    '/activities/create',
    queryParams: {
      if (_self.name != null) 'name': _self.name,
      if (_self.date != null) 'date': _self.date,
    },
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

RouteBase get $settingsFavoritesRoute => GoRouteData.$route(
  path: '/settings/favorites',
  factory: $SettingsFavoritesRoute._fromState,
);

mixin $SettingsFavoritesRoute on GoRouteData {
  static SettingsFavoritesRoute _fromState(GoRouterState state) =>
      const SettingsFavoritesRoute();

  @override
  String get location => GoRouteData.$location('/settings/favorites');

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

RouteBase get $favoritesCategoryDetailRoute => GoRouteData.$route(
  path: '/favorites/category/:categoryId',
  factory: $FavoritesCategoryDetailRoute._fromState,
);

mixin $FavoritesCategoryDetailRoute on GoRouteData {
  static FavoritesCategoryDetailRoute _fromState(GoRouterState state) =>
      FavoritesCategoryDetailRoute(
        categoryId: state.pathParameters['categoryId']!,
      );

  FavoritesCategoryDetailRoute get _self =>
      this as FavoritesCategoryDetailRoute;

  @override
  String get location => GoRouteData.$location(
    '/favorites/category/${Uri.encodeComponent(_self.categoryId)}',
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
