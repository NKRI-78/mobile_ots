// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$splashRoute, $authRoutes, $categoryRoutes];

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/splash',

  factory: $SplashRouteExtension._fromState,
);

extension $SplashRouteExtension on SplashRoute {
  static SplashRoute _fromState(GoRouterState state) => SplashRoute();

  String get location => GoRouteData.$location('/splash');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $authRoutes => GoRouteData.$route(
  path: '/login',

  factory: $AuthRoutesExtension._fromState,
);

extension $AuthRoutesExtension on AuthRoutes {
  static AuthRoutes _fromState(GoRouterState state) => AuthRoutes();

  String get location => GoRouteData.$location('/login');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoryRoutes => GoRouteData.$route(
  path: '/category',

  factory: $CategoryRoutesExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'payment',

      factory: $PaymentRoutesExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'payment-status',

      factory: $PaymentStatusRoutesExtension._fromState,
    ),
  ],
);

extension $CategoryRoutesExtension on CategoryRoutes {
  static CategoryRoutes _fromState(GoRouterState state) => CategoryRoutes();

  String get location => GoRouteData.$location('/category');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PaymentRoutesExtension on PaymentRoutes {
  static PaymentRoutes _fromState(GoRouterState state) =>
      PaymentRoutes($extra: state.extra as PaymentRequstData);

  String get location => GoRouteData.$location('/category/payment');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $PaymentStatusRoutesExtension on PaymentStatusRoutes {
  static PaymentStatusRoutes _fromState(GoRouterState state) =>
      PaymentStatusRoutes($extra: state.extra as PaymentRequstData);

  String get location => GoRouteData.$location('/category/payment-status');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
