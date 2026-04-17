import 'dart:async';
import 'dart:convert';

import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/misc/logger.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../misc/my_api.dart';

class PaymentRepository {
  String get chargeUrl => '${MyApi.baseUrl}/api/v1/payment/qris/charge';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  //* checkout payment
  Future<String> createPayment(PaymentRequestData request) async {
    final uri = Uri.parse(chargeUrl);

    logger(request.toJson().toString());

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      final isHttpError =
          response.statusCode != 200 && response.statusCode != 201;

      final isApiError = jsonResp['error'] == true;

      if (isHttpError || isApiError) {
        throw ApiException(
          title: "Pembayaran Gagal",
          message: jsonResp['message'] ?? "Tidak dapat memproses pembayaran",
        );
      }

      final data = jsonResp['data'];
      if (data == null || data['reference_id'] == null) {
        throw ApiException(
          title: "Pembayaran Gagal",
          message:
              "Terjadi kendala saat memproses pembayaran. Silakan coba beberapa saat lagi.",
        );
      }

      return data['reference_id'] as String;
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }
}
