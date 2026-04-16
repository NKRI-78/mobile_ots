import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_ots/misc/socket.dart';
import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';
import 'package:mobile_ots/modules/payment/cubit/payment_cubit.dart';
import 'package:mobile_ots/modules/transaction/cubit/transaction_cubit.dart';

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
      child: AppView(app),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView(this.bloc, {super.key});

  final AppBloc bloc;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  // init: router, socket
  void _initService() {
    router = MyRouter.init(widget.bloc);
    SocketService().connectWithUserId(widget.bloc.state.user?.id ?? '1');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<PaymentCubit>()),
        BlocProvider.value(value: getIt<CategoryCubit>()),
        BlocProvider.value(value: getIt<TransactionCubit>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: baseTheme,
        routerConfig: router,
      ),
    );
  }
}
