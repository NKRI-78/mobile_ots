import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/theme.dart';
import '../../../router/router.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final app = getIt<AppBloc>();
    return BlocProvider<AppBloc>.value(
      value: app..add(InitialAppData()),
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppBloc>();

    final router = MyRouter.init(app);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      routerConfig: router,
    );
  }
}
