class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String access;
  final bool enabled;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.access,
    required this.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '-',
      role: json['role'] ?? '',
      access: json['access'] ?? '',
      enabled: json['enabled'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'access': access,
    'enabled': enabled,
  };
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
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
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
