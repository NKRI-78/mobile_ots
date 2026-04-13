import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;

  const UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  @override
  List<Object?> get props => [id, name];
}

class AuthData {
  final String token;
  final String refreshToken;
  final UserModel user;

  AuthData({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'refresh_token': refreshToken,
    'user': user.toJson(),
  };
}

class AuthResponse {
  final int status;
  final bool error;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.status,
    required this.error,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? 0,
      error: json['error'] ?? true,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}
