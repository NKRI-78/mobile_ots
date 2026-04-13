import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/modules/category/view/category_page.dart';

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

@TypedGoRoute<CategoryRoutes>(path: '/category')
class CategoryRoutes extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CategoryPage();
  }
}
