import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/http_client.dart';
import 'package:mobile_ots/misc/injections.dart';
import 'package:mobile_ots/misc/my_api.dart';
import 'package:mobile_ots/repositories/transaction/model/transaction_models.dart';

class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

class TransactionRepository {
  String get transactionUrl =>
      '${MyApi.baseUrl}/api/v1/payment/qris/transactions';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  Future<PaginatedResult<TransactionData>> getTransactions({
    int page = 1,
    int limit = 10,
    String? search,
    String? status,
    String sort = "newest",
  }) async {
    final uri = Uri.parse(transactionUrl).replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (search != null) 'search': search,
        if (status != null) 'status': status,
        'sort': sort,
      },
    );

    try {
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      final isHttpError = response.statusCode != 200;
      final isApiError = jsonResp['error'] == true;

      if (isHttpError || isApiError) {
        throw ApiException(
          title: "Gagal Memuat Data",
          message:
              jsonResp['message'] ??
              "Tidak dapat mengambil data transaksi saat ini",
        );
      }

      final data = jsonResp['data'];
      final items = data?['items'];

      if (items == null || items is! List) {
        throw ParsingException(
          title: "Data Tidak Tersedia",
          message:
              "Data transaksi tidak dapat ditampilkan saat ini. Silakan coba lagi.",
          debugMessage: "Invalid items format: ${items.runtimeType}",
        );
      }

      final transactions = <TransactionData>[];

      for (final item in items) {
        try {
          if (item is Map<String, dynamic>) {
            transactions.add(TransactionData.fromJson(item));
          }
        } catch (e, st) {
          if (!kReleaseMode) {
            log(
              "error insert transaction on transactions based items from api = ${e.toString()} | ${st.toString()}t",
            );
          }
        }
      }

      log(
        {
          "items": transactions.map(
            (e) => {
              "amount": e.amount,
              "status": e.status,
              "note": e.note ?? "-",
            },
          ),
          "page": data['page'],
          "limit": data['limit'],
          "total": data['total'],
          "total_pages": data['total_pages'],
        }.toString(),
      );

      return PaginatedResult(
        items: transactions,
        page: data['page'],
        limit: data['limit'],
        total: data['total'],
        totalPages: data['total_pages'],
      );
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }

  Future<TransactionData> getTransactionByRefId(String id) async {
    final urlString = "$transactionUrl/$id";
    try {
      final response = await http
          .get(
            Uri.parse(urlString),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200 || jsonResp['error'] == true) {
        throw ApiException(
          title: "Gagal Memuat Data",
          message: jsonResp['message'] ?? "Tidak dapat mengambil data kategori",
        );
      }

      if (jsonResp['data'] == null) {
        throw ParsingException(
          title: "Terjadi Kesalahan",
          message:
              "Data Transaksi tidak ditemukan, silahkan coba beberapa saat lagi",
        );
      }

      return TransactionResponse.fromJson(jsonResp).data;
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }
}
