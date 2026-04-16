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

        // Gunakan uri.toString() agar mencakup full path termasuk child
        final loc = state.uri.toString();

        final splashLoc = SplashRoute().location;
        final authLoc = AuthRoutes().location;
        final homeLoc = CategoryRoutes().location;

        final goingToSplash = loc == splashLoc;
        final goingToAuth = loc == authLoc;

        // startsWith tetap benar untuk semua child di bawah /category
        final goingToHomeTree = loc.startsWith(homeLoc);

        // 1. Splash wajib sekali
        if (!alreadySplash) {
          return goingToSplash ? null : splashLoc;
        }

        // 2. Sudah login → izinkan semua child home, jangan redirect
        if (loggedIn) {
          if (goingToHomeTree) return null; // ✅ tetap di halaman sekarang
          if (goingToSplash) return homeLoc; // splash setelah login → home
          return homeLoc;
        }

        // 3. Belum login → hanya auth
        if (!loggedIn) {
          return goingToAuth ? null : authLoc;
        }

        return null;
      },
    );
  }
}
