import 'dart:async';
import 'dart:convert';

import 'package:mobile_ots/misc/exception.dart';
import 'package:mobile_ots/repositories/payment/model/payment_models.dart';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../misc/my_api.dart';

class PaymentRepository {
  String get chargeUrl => '${MyApi.baseUrl}/api/v1/payment/qris/charge';

  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  //* checkout payment
  Future<PaymentResponse> createPayment(PaymentRequstData request) async {
    try {
      final response = await http
          .post(
            Uri.parse(chargeUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (response.statusCode != 200 || jsonResp['error'] == true) {
        throw ApiException(
          title: "Pembayaran Gagal",
          message: jsonResp['message'] ?? "Tidak dapat memproses pembayaran",
        );
      }

      return PaymentResponse.fromJson(jsonResp);
    } catch (e, st) {
      throw ErrorMapper.map(e, st);
    }
  }
}
