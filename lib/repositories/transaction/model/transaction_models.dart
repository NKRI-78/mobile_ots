// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:mobile_ots/misc/exception.dart';

class TransactionResponse extends Equatable {
  final int status;
  final bool error;
  final String message;
  final TransactionData data;

  const TransactionResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  @override
  List<Object> get props => [status, error, message, data];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'error': error,
      'message': message,
      'data': data.toJson(),
    };
  }

  factory TransactionResponse.fromJson(Map<String, dynamic> map) {
    return TransactionResponse(
      status: map['status'] as int,
      error: map['error'] as bool,
      message: map['message'] as String,
      data: TransactionData.fromJson(map['data'] as Map<String, dynamic>),
    );
  }

  TransactionResponse copyWith({
    int? status,
    bool? error,
    String? message,
    TransactionData? data,
  }) {
    return TransactionResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class TransactionData extends Equatable {
  final int id;
  final String referenceId;
  final String paymentChannel;
  final int amount;
  final String? status;
  final String? note;
  final int? expiresIn;
  final String? expiresAt;
  final String? createdAt;
  final String? updatedAt;
  final PaymentProvider? provider;
  final List<TransactionDataCategory> categories;

  const TransactionData({
    required this.id,
    required this.referenceId,
    required this.paymentChannel,
    required this.amount,
    this.status,
    this.note,
    this.expiresIn,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.provider,
    required this.categories,
  });

  @override
  List<Object?> get props {
    return [
      id,
      referenceId,
      paymentChannel,
      amount,
      status,
      expiresIn,
      note,
      expiresAt,
      createdAt,
      updatedAt,
      provider,
      categories,
    ];
  }

  TransactionData copyWith({
    int? id,
    String? referenceId,
    String? paymentChannel,
    int? amount,
    String? status,
    String? note,
    int? expiresIn,
    String? expiresAt,
    String? createdAt,
    String? updatedAt,
    PaymentProvider? provider,
    List<TransactionDataCategory>? categories,
  }) {
    return TransactionData(
      id: id ?? this.id,
      referenceId: referenceId ?? this.referenceId,
      paymentChannel: paymentChannel ?? this.paymentChannel,
      note: note ?? this.note,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      provider: provider ?? this.provider,
      categories: categories ?? this.categories,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'reference_id': referenceId,
      'payment_channel': paymentChannel,
      'amount': amount,
      'status': status,
      'note': note,
      'expires_in': expiresIn,
      'expires_at': expiresAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'provider_response': provider?.toJson(),
      'categories': categories.map((x) => x.toJson()).toList(),
    };
  }

  factory TransactionData.fromJson(Map<String, dynamic> map) {
    return TransactionData(
      id: map['id'] as int,
      referenceId: map['reference_id'] as String,
      paymentChannel: map['payment_channel'] as String,
      amount: map['amount'] as int,
      status: map['status'] as String,
      note: map['note'],
      expiresIn: map['expires_in'],
      expiresAt: map['expires_at'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      provider: map['provider_response'] != null
          ? PaymentProvider.fromJson(
              _parseProviderResponse(map['provider_response']),
            )
          : null,
      categories:
          (map['categories'] as List?)
              ?.map((e) => TransactionDataCategory.fromJson(e))
              .toList() ??
          [],
    );
  }

  static Map<String, dynamic> _parseProviderResponse(dynamic raw) {
    try {
      if (raw is Map<String, dynamic>) return raw;
      if (raw is String) return jsonDecode(raw) as Map<String, dynamic>;
      throw FormatException('Unexpected type: ${raw.runtimeType}');
    } catch (e) {
      throw ParsingException(
        title: 'Terjadi Kesalahan',
        message:
            'Terjadi kendala saat memproses data pembayaran. Silakan coba beberapa saat lagi.',
        debugMessage: 'provider_response parsing error: $e',
      );
    }
  }
}

class PaymentProvider extends Equatable {
  final dynamic status;
  final PaymentProviderData? data;

  const PaymentProvider({this.status, this.data});

  PaymentProvider copyWith({String? status, PaymentProviderData? data}) =>
      PaymentProvider(status: status ?? this.status, data: data ?? this.data);

  factory PaymentProvider.fromJson(Map<String, dynamic> json) =>
      PaymentProvider(
        status: json["status"],
        data: json["data"] == null
            ? null
            : PaymentProviderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};

  @override
  List<Object?> get props => [status, data];
}

class PaymentProviderData extends Equatable {
  final String? provider;
  final String? orderId;
  final String? paymentChannelCode;
  final String? referenceId;
  final int? amount;
  final int? status;
  final PaymentProviderDataQr? qr;
  final PamentProviderDataCustomer? customer;

  const PaymentProviderData({
    this.provider,
    this.orderId,
    this.paymentChannelCode,
    this.referenceId,
    this.amount,
    this.status,
    this.qr,
    this.customer,
  });

  PaymentProviderData copyWith({
    String? provider,
    String? orderId,
    String? paymentChannelCode,
    String? referenceId,
    int? amount,
    int? status,
    PaymentProviderDataQr? qr,
    PamentProviderDataCustomer? customer,
  }) => PaymentProviderData(
    provider: provider ?? this.provider,
    orderId: orderId ?? this.orderId,
    paymentChannelCode: paymentChannelCode ?? this.paymentChannelCode,
    referenceId: referenceId ?? this.referenceId,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    qr: qr ?? this.qr,
    customer: customer ?? this.customer,
  );

  factory PaymentProviderData.fromJson(Map<String, dynamic> json) =>
      PaymentProviderData(
        provider: json["provider"],
        orderId: json["order_id"],
        paymentChannelCode: json["payment_channel_code"],
        referenceId: json["reference_id"],
        amount: json["amount"],
        status: json["status"],
        qr: json["qr"] == null
            ? null
            : PaymentProviderDataQr.fromJson(json["qr"]),
        customer: json["customer"] == null
            ? null
            : PamentProviderDataCustomer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
    "provider": provider,
    "order_id": orderId,
    "payment_channel_code": paymentChannelCode,
    "reference_id": referenceId,
    "amount": amount,
    "status": status,
    "qr": qr?.toJson(),
    "customer": customer?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      provider,
      orderId,
      paymentChannelCode,
      referenceId,
      amount,
      status,
      qr,
      customer,
    ];
  }
}

class PamentProviderDataCustomer extends Equatable {
  final String? createdAt;
  final String? updatedAt;
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? transactionId;

  const PamentProviderDataCustomer({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.name,
    this.email,
    this.phone,
    this.transactionId,
  });

  PamentProviderDataCustomer copyWith({
    String? createdAt,
    String? updatedAt,
    int? id,
    String? name,
    String? email,
    String? phone,
    int? transactionId,
  }) => PamentProviderDataCustomer(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    transactionId: transactionId ?? this.transactionId,
  );

  factory PamentProviderDataCustomer.fromJson(Map<String, dynamic> json) =>
      PamentProviderDataCustomer(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "updated_at": updatedAt,
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "transaction_id": transactionId,
  };

  @override
  List<Object?> get props {
    return [createdAt, updatedAt, id, name, email, phone, transactionId];
  }
}

class PaymentProviderDataQr extends Equatable {
  final String? createdAt;
  final String? updatedAt;
  final int? id;
  final String? qrData;
  final String? qrUrl;
  final int? transactionId;

  const PaymentProviderDataQr({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.qrData,
    this.qrUrl,
    this.transactionId,
  });

  PaymentProviderDataQr copyWith({
    String? createdAt,
    String? updatedAt,
    int? id,
    String? qrData,
    String? qrUrl,
    int? transactionId,
  }) => PaymentProviderDataQr(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    qrData: qrData ?? this.qrData,
    qrUrl: qrUrl ?? this.qrUrl,
    transactionId: transactionId ?? this.transactionId,
  );

  factory PaymentProviderDataQr.fromJson(Map<String, dynamic> json) =>
      PaymentProviderDataQr(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        id: json["id"],
        qrData: json["qrData"],
        qrUrl: json["qrUrl"],
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "updated_at": updatedAt,
    "id": id,
    "qrData": qrData,
    "qrUrl": qrUrl,
    "transaction_id": transactionId,
  };

  @override
  List<Object?> get props {
    return [createdAt, updatedAt, id, qrData, qrUrl, transactionId];
  }
}

class TransactionDataCategory extends Equatable {
  final int id;
  final String name;
  final int sortNo;
  final int qty;
  final int amount;
  final String createdAt;

  const TransactionDataCategory({
    required this.id,
    required this.name,
    required this.sortNo,
    required this.qty,
    required this.amount,
    required this.createdAt,
  });

  @override
  List<Object> get props {
    return [id, name, sortNo, qty, amount, createdAt];
  }

  TransactionDataCategory copyWith({
    int? id,
    String? name,
    int? sortNo,
    int? qty,
    int? amount,
    String? createdAt,
  }) {
    return TransactionDataCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      sortNo: sortNo ?? this.sortNo,
      qty: qty ?? this.qty,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'category_name': name,
      'sort_no': sortNo,
      'qty': qty,
      'amount': amount,
      'created_at': createdAt,
    };
  }

  factory TransactionDataCategory.fromJson(Map<String, dynamic> map) {
    return TransactionDataCategory(
      id: map['id'] as int,
      name: map['category_name'] as String,
      sortNo: map['sort_no'] as int,
      qty: map['qty'] as int,
      amount: map['amount'] as int,
      createdAt: map['created_at'] as String,
    );
  }
}
