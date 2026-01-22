// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $homeRoute,
  $authRoute,
  $activitySearchRoute,
  $editActivityRoute,
];

RouteBase get $homeRoute =>
    GoRouteData.$route(path: '/', factory: $HomeRoute._fromState);

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
