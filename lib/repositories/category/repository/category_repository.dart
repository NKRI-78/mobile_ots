import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../misc/my_api.dart';
import '../model/category_models.dart';

class CategoryRepository {
  String get category => '${MyApi.baseUrl}/api/v1/payment/qris/categories';
  String get chargeUrl => '${MyApi.baseUrl}/api/v1/payment/qris/charge';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(category),
        headers: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw jsonResp['message'] ?? "Terjadi kesalahan";
      }

      final data = CategoryResponse.fromJson(jsonResp);

      return data.items;
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateCategoryResponse> createCategories({
    required String name,
    String? shortNo,
  }) async {
    final body = {'name': name, 'short_no': shortNo};
    try {
      final response = await http.post(
        Uri.parse(category),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 201) {
        throw Exception(jsonResp['message'] ?? "Terjadi kesalahan");
      }

      final createResp = CreateCategoryResponse.fromJson(jsonResp);

      return createResp;
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> charge(ChargeRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(chargeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(jsonResp['message'] ?? "Gagal melakukan pembayaran");
      }

      if (jsonResp['error'] == true) {
        throw Exception(jsonResp['message']);
      }

      // kalau nanti butuh QR / payment data → bisa parse di sini
    } on SocketException {
      throw Exception("Terjadi Kesalahan Jaringan");
    } on TimeoutException {
      throw Exception("Koneksi lambat");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
