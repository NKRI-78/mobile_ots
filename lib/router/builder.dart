import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/modules/category/view/category_page.dart';
import 'package:mobile_ots/modules/payment/view/payment_page.dart';
import 'package:mobile_ots/modules/payment/view/payment_status_page.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';

import '../modules/auth/view/auth_page.dart';
import '../modules/splash/view/splash_page.dart';

part 'builder.g.dart';

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashPage();
  }
}

@TypedGoRoute<AuthRoutes>(path: '/login')
class AuthRoutes extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AuthPage();
  }
}

@TypedGoRoute<CategoryRoutes>(
  path: '/category',
  routes: [
    TypedGoRoute<PaymentRoutes>(path: "payment"),
    TypedGoRoute<PaymentStatusRoutes>(path: "payment-status"),
  ],
)
class CategoryRoutes extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage();
  }
}

class PaymentRoutes extends GoRouteData {
  final PaymentRequstData $extra;

  PaymentRoutes({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PaymentPage(requestData: $extra);
  }
}

class PaymentStatusRoutes extends GoRouteData {
  final PaymentRequstData $extra;

  PaymentStatusRoutes({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PaymentStatusPage();
  }
}
