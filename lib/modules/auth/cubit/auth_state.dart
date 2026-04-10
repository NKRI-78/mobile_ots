part of 'auth_cubit.dart';

class AuthState {
  final String email;
  final String password;
  final bool loading;
  final bool isPasswordVisible;

  const AuthState({
    this.email = "",
    this.password = "",
    this.loading = false,
    this.isPasswordVisible = false,
  });

  AuthState copyWith({
    String? email,
    String? password,
    bool? loading,
    bool? isPasswordVisible,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      loading: loading ?? this.loading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}
