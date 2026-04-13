import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/repository/auth_repository.dart';
import '../../app/bloc/app_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  final AuthRepository repo = getIt<AuthRepository>();

  final passController = TextEditingController();
  final emailController = TextEditingController();

  void onChanged({String? email, String? password}) {
    emit(
      state.copyWith(
        email: email ?? state.email,
        password: password ?? state.password,
      ),
    );
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(BuildContext context) async {
    try {
      emit(state.copyWith(loading: true));

      final response = await repo.login(
        email: emailController.text.trim(),
        password: passController.text,
      );

      context.read<AppBloc>().add(
        SetUserData(
          user: response.user,
          token: response.token,
          refreshToken: response.refreshToken,
        ),
      );

      emit(state.copyWith(loading: false));

      ShowSnackbar.snackbar(
        context,
        "Selamat Datang ${response.user.name}",
        isSuccess: true,
      );
    } catch (e) {
      emit(state.copyWith(loading: false));

      ShowSnackbar.snackbar(context, e.toString(), isSuccess: false);
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passController.dispose();
    return super.close();
  }
}
