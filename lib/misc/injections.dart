import 'package:get_it/get_it.dart';
import 'package:mobile_ots/modules/category/cubit/category_cubit.dart';

import '../modules/app/bloc/app_bloc.dart';
import '../repositories/auth_repository/repository/auth_repository.dart';
import '../repositories/category/repository/category_repository.dart';
import 'http_client.dart';

final getIt = GetIt.instance;

class MyInjection {
  static setup() {
    //NETWORK CLIENT
    getIt.registerLazySingleton<BaseNetworkClient>(() => BaseNetworkClient());

    //BLOC
    getIt.registerLazySingleton<AppBloc>(() => AppBloc());

    //CUBIT
    getIt.registerFactory<CategoryCubit>(() => CategoryCubit());

    //REPOSITORY
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    getIt.registerLazySingleton<CategoryRepository>(() => CategoryRepository());
  }
}
