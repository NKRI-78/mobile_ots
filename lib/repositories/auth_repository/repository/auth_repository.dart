import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../misc/my_api.dart';
import '../models/auth_models.dart';

class AuthRepository {
  String get auth => '${MyApi.baseUrl}/api/v1/auth/login';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  Future<AuthData> login({
    required String email,
    required String password,
  }) async {
    final body = {'value': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse(auth),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResp['message'] ?? "Terjadi kesalahan";
      }

      final authResp = AuthResponse.fromJson(jsonResp);

      if (authResp.error == false && authResp.data != null) {
        return authResp.data!;
      } else {
        throw authResp.message;
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }
}
