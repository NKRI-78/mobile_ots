import 'package:go_router/go_router.dart';

import '../misc/go_router_refresh_stream.dart';
import '../misc/navigation.dart';
import '../modules/app/bloc/app_bloc.dart';
import 'builder.dart';

class MyRouter {
  static GoRouter init(AppBloc app) {
    return GoRouter(
      navigatorKey: myNavigatorKey,
      routes: $appRoutes,
      initialLocation: SplashRoute().location,
      refreshListenable: GoRouterRefreshStream(app.stream),
      redirect: (context, state) {
        final loggedIn = app.state.isLoggedIn;
        final alreadySplash = app.state.alreadySplash;

        final loc = state.matchedLocation;

        final splashLoc = SplashRoute().location;
        final authLoc = AuthRoutes().location;
        final homeLoc = CategoryRoutes().location;

        final goingToSplash = loc == splashLoc;
        final goingToAuth = loc == authLoc;

        // 1. WAJIB tampilkan splash sekali
        if (!alreadySplash) {
          return goingToSplash ? null : splashLoc;
        }

        // 2. Kalau SUDAH login → ke home
        if (loggedIn) {
          return loc == homeLoc ? null : homeLoc;
        }

        // 3. Kalau BELUM login → ke auth
        if (!loggedIn) {
          return goingToAuth ? null : authLoc;
        }

        return null;
      },
    );
  }
}
