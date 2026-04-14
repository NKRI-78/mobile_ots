import 'dart:async';
import 'dart:convert';

import 'package:mobile_ots/misc/exception.dart';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../misc/my_api.dart';
import '../model/category_models.dart';

class CategoryRepository {
  String get category => '${MyApi.baseUrl}/api/v1/payment/qris/categories';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  //* fetch category
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse(category),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200 || jsonResp['error'] == true) {
        throw ApiException(
          title: "Gagal Memuat Data",
          message: jsonResp['message'] ?? "Tidak dapat mengambil data kategori",
        );
      }

      if (jsonResp['data'] == null) {
        throw ParsingException(
          title: "Invalid Response",
          message: "Data kategori tidak ditemukan",
        );
      }

      return CategoryResponse.fromJson(jsonResp).items;
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }

  //* create category
  Future<CreateCategoryResponse> createCategory(Category newCategory) async {
    final body = {'name': newCategory.name, 'qty': newCategory.qty};
    try {
      final response = await http
          .post(
            Uri.parse(category),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if ((response.statusCode != 200 && response.statusCode != 201) ||
          jsonResp['error'] == true) {
        throw ApiException(
          title: "Gagal Menyimpan",
          message: jsonResp['message'] ?? "Tidak dapat membuat kategori",
        );
      }

      if (jsonResp['data'] == null) {
        throw ParsingException(
          title: "Invalid Response",
          message: "Data kategori tidak ditemukan",
        );
      }

      return CreateCategoryResponse.fromJson(jsonResp);
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }

  //* update category
  Future<Category> updateCategory(Category update) async {
    final url = "$category/${update.id}";
    final body = {'name': update.name, 'qty': update.qty};

    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200 || jsonResp['error'] == true) {
        if (response.statusCode == 404) {
          throw ApiException(
            title: "Data Tidak Ditemukan",
            message: "Kategori yang ingin diperbarui tidak tersedia.",
          );
        }
        throw ApiException(
          title: "Gagal Memperbarui",
          message: jsonResp['message'] ?? "Tidak dapat memperbarui kategori",
        );
      }

      final data = jsonResp['data'];
      if (data == null || data is! Map<String, dynamic>) {
        throw ParsingException(
          title: "Invalid Response",
          message: "Format data kategori tidak valid",
        );
      }

      return Category.fromJson(data);
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }

  //* delete category
  Future<void> deleteCategoryById(int id) async {
    final url = "$category/$id";

    try {
      final response = await http
          .delete(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200 || jsonResp['error'] == true) {
        if (response.statusCode == 404) {
          throw ApiException(
            title: "Data Tidak Ditemukan",
            message: "Kategori yang ingin dihapus tidak tersedia.",
          );
        }
        throw ApiException(
          title: "Gagal Menghapus",
          message: jsonResp['message'] ?? "Tidak dapat menghapus kategori",
        );
      }
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }
}
