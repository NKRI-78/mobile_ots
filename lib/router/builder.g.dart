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
      path: 'create-payment',

      factory: $CreatePaymentRoutesExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'transactions',

      factory: $TransactionsRoutesExtension._fromState,
    ),
    GoRouteData.$route(
      path: 'transaction-detail',

      factory: $TransactionDetailRoutesExtension._fromState,
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

extension $CreatePaymentRoutesExtension on CreatePaymentRoutes {
  static CreatePaymentRoutes _fromState(GoRouterState state) =>
      CreatePaymentRoutes($extra: state.extra as PaymentRequestData);

  String get location => GoRouteData.$location('/category/create-payment');

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $TransactionsRoutesExtension on TransactionsRoutes {
  static TransactionsRoutes _fromState(GoRouterState state) =>
      TransactionsRoutes();

  String get location => GoRouteData.$location('/category/transactions');

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TransactionDetailRoutesExtension on TransactionDetailRoutes {
  static TransactionDetailRoutes _fromState(GoRouterState state) =>
      TransactionDetailRoutes(
        referenceId: state.uri.queryParameters['reference-id'],
        hasPaid: _$boolConverter(state.uri.queryParameters['has-paid']!)!,
      );

  String get location => GoRouteData.$location(
    '/category/transaction-detail',
    queryParams: {
      if (referenceId != null) 'reference-id': referenceId,
      'has-paid': hasPaid.toString(),
    },
  );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
