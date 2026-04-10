import 'package:get_it/get_it.dart';

import '../modules/app/bloc/app_bloc.dart';
import 'http_client.dart';

final getIt = GetIt.instance;

class MyInjection {
  static setup() {
    //NETWORK CLIENT
    getIt.registerLazySingleton<BaseNetworkClient>(() => BaseNetworkClient());

    //BLOC
    getIt.registerLazySingleton<AppBloc>(() => AppBloc());

    //CUBIT

    //REPOSITORY
  }
}
