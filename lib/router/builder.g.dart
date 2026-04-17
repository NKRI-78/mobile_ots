// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRoute,
  $authRoutes,
  $transactionsRoutes,
];

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

RouteBase get $transactionsRoutes => GoRouteData.$route(
  path: '/transactions',

  factory: $TransactionsRoutesExtension._fromState,
  routes: [
    GoRouteData.$route(
      path: 'category',

      factory: $CategoryRoutesExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'create-payment',

          factory: $CreatePaymentRoutesExtension._fromState,
        ),
      ],
    ),
    GoRouteData.$route(
      path: 'transaction-detail',

      factory: $TransactionDetailRoutesExtension._fromState,
    ),
  ],
);

extension $TransactionsRoutesExtension on TransactionsRoutes {
  static TransactionsRoutes _fromState(GoRouterState state) =>
      TransactionsRoutes();

  String get location => GoRouteData.$location('/transactions');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CategoryRoutesExtension on CategoryRoutes {
  static CategoryRoutes _fromState(GoRouterState state) => CategoryRoutes();

  String get location => GoRouteData.$location('/transactions/category');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreatePaymentRoutesExtension on CreatePaymentRoutes {
  static CreatePaymentRoutes _fromState(GoRouterState state) =>
      CreatePaymentRoutes($extra: state.extra as PaymentRequestData);

  String get location =>
      GoRouteData.$location('/transactions/category/create-payment');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $TransactionDetailRoutesExtension on TransactionDetailRoutes {
  static TransactionDetailRoutes _fromState(GoRouterState state) =>
      TransactionDetailRoutes(
        $extra: state.extra as TransactionDetailPageParam?,
      );

  String get location =>
      GoRouteData.$location('/transactions/transaction-detail');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}
