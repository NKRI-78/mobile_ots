import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/modules/category/view/category_page.dart';
import 'package:mobile_ots/modules/payment/view/create_payment_page.dart';
import 'package:mobile_ots/modules/transaction/view/transaction_detail_page.dart';
import 'package:mobile_ots/modules/transaction/view/transactions_page.dart';
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
    TypedGoRoute<CreatePaymentRoutes>(path: "create-payment"),
    TypedGoRoute<TransactionsRoutes>(path: "transactions"),
    TypedGoRoute<TransactionDetailRoutes>(path: "transaction-detail"),
  ],
)
class CategoryRoutes extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage();
  }
}

class CreatePaymentRoutes extends GoRouteData {
  final PaymentRequestData $extra;

  CreatePaymentRoutes({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreatePaymentPage(requestData: $extra);
  }
}

class TransactionsRoutes extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionsPage();
  }
}

class TransactionDetailRoutes extends GoRouteData {
  final String? referenceId;
  final bool hasPaid;

  TransactionDetailRoutes({required this.referenceId, required this.hasPaid});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionDetailPage(referenceId: referenceId, hasPaid: hasPaid);
  }
}
