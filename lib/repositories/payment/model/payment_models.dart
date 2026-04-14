import 'package:equatable/equatable.dart';

class PaymentResponse extends Equatable {
  final int? status;
  final bool? error;
  final String? message;
  final PaymentResponseData? data;

  const PaymentResponse({this.status, this.error, this.message, this.data});

  PaymentResponse copyWith({
    int? status,
    bool? error,
    String? message,
    PaymentResponseData? data,
  }) => PaymentResponse(
    status: status ?? this.status,
    error: error ?? this.error,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : PaymentResponseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "data": data?.toJson(),
  };

  @override
  List<Object?> get props => [status, error, message, data];
}

class PaymentResponseData extends Equatable {
  final int? id;
  final String? referenceId;
  final String? status;
  final int? amount;
  final String? qrString;
  final String? qrUrl;
  final String? expiresAt;
  final List<PaymentCategory>? categories;
  final PaymentProvider? provider;

  const PaymentResponseData({
    this.id,
    this.referenceId,
    this.status,
    this.amount,
    this.qrString,
    this.qrUrl,
    this.expiresAt,
    this.categories,
    this.provider,
  });

  PaymentResponseData copyWith({
    int? id,
    String? referenceId,
    String? status,
    int? amount,
    String? qrString,
    String? qrUrl,
    String? expiresAt,
    List<PaymentCategory>? categories,
    PaymentProvider? provider,
  }) => PaymentResponseData(
    id: id ?? this.id,
    referenceId: referenceId ?? this.referenceId,
    status: status ?? this.status,
    amount: amount ?? this.amount,
    qrString: qrString ?? this.qrString,
    qrUrl: qrUrl ?? this.qrUrl,
    expiresAt: expiresAt ?? this.expiresAt,
    categories: categories ?? this.categories,
    provider: provider ?? this.provider,
  );

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) =>
      PaymentResponseData(
        id: json["id"],
        referenceId: json["reference_id"],
        status: json["status"],
        amount: json["amount"],
        qrString: json["qr_string"],
        qrUrl: json["qr_url"],
        expiresAt: json["expires_at"],
        categories: json["categories"] == null
            ? []
            : List<PaymentCategory>.from(
                json["categories"]!.map((x) => PaymentCategory.fromJson(x)),
              ),
        provider: json["provider"] == null
            ? null
            : PaymentProvider.fromJson(json["provider"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference_id": referenceId,
    "status": status,
    "amount": amount,
    "qr_string": qrString,
    "qr_url": qrUrl,
    "expires_at": expiresAt,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "provider": provider?.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
      referenceId,
      status,
      amount,
      qrString,
      qrUrl,
      expiresAt,
      categories,
      provider,
    ];
  }
}

class PaymentCategory extends Equatable {
  final int? categoryId;
  final String? categoryName;
  final int? sortNo;
  final int? qty;
  final int? amount;

  const PaymentCategory({
    this.categoryId,
    this.categoryName,
    this.sortNo,
    this.qty,
    this.amount,
  });

  PaymentCategory copyWith({
    int? categoryId,
    String? categoryName,
    int? sortNo,
    int? qty,
    int? amount,
  }) => PaymentCategory(
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    sortNo: sortNo ?? this.sortNo,
    qty: qty ?? this.qty,
    amount: amount ?? this.amount,
  );

  factory PaymentCategory.fromJson(Map<String, dynamic> json) =>
      PaymentCategory(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        sortNo: json["sort_no"],
        qty: json["qty"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category_name": categoryName,
    "sort_no": sortNo,
    "qty": qty,
    "amount": amount,
  };

  @override
  List<Object?> get props {
    return [categoryId, categoryName, sortNo, qty, amount];
  }
}

class PaymentProvider extends Equatable {
  final PaymentProviderMeta? meta;
  final int? status;
  final PaymentProviderData? data;

  const PaymentProvider({this.meta, this.status, this.data});

  PaymentProvider copyWith({
    PaymentProviderMeta? meta,
    int? status,
    PaymentProviderData? data,
  }) => PaymentProvider(
    meta: meta ?? this.meta,
    status: status ?? this.status,
    data: data ?? this.data,
  );

  factory PaymentProvider.fromJson(Map<String, dynamic> json) =>
      PaymentProvider(
        meta: json["meta"] == null
            ? null
            : PaymentProviderMeta.fromJson(json["meta"]),
        status: json["status"],
        data: json["data"] == null
            ? null
            : PaymentProviderData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "meta": meta?.toJson(),
    "status": status,
    "data": data?.toJson(),
  };

  @override
  List<Object?> get props => [meta, status, data];
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
  final List<PaymentProviderDataItem>? items;

  const PaymentProviderData({
    this.provider,
    this.orderId,
    this.paymentChannelCode,
    this.referenceId,
    this.amount,
    this.status,
    this.qr,
    this.customer,
    this.items,
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
    List<PaymentProviderDataItem>? items,
  }) => PaymentProviderData(
    provider: provider ?? this.provider,
    orderId: orderId ?? this.orderId,
    paymentChannelCode: paymentChannelCode ?? this.paymentChannelCode,
    referenceId: referenceId ?? this.referenceId,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    qr: qr ?? this.qr,
    customer: customer ?? this.customer,
    items: items ?? this.items,
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
        items: json["items"] == null
            ? []
            : List<PaymentProviderDataItem>.from(
                json["items"]!.map((x) => PaymentProviderDataItem.fromJson(x)),
              ),
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
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
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
      items,
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

class PaymentProviderDataItem extends Equatable {
  final String? createdAt;
  final String? updatedAt;
  final int? id;
  final String? product;
  final int? amount;
  final int? qty;
  final int? transactionId;

  const PaymentProviderDataItem({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.product,
    this.amount,
    this.qty,
    this.transactionId,
  });

  PaymentProviderDataItem copyWith({
    String? createdAt,
    String? updatedAt,
    int? id,
    String? product,
    int? amount,
    int? qty,
    int? transactionId,
  }) => PaymentProviderDataItem(
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    product: product ?? this.product,
    amount: amount ?? this.amount,
    qty: qty ?? this.qty,
    transactionId: transactionId ?? this.transactionId,
  );

  factory PaymentProviderDataItem.fromJson(Map<String, dynamic> json) =>
      PaymentProviderDataItem(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        id: json["id"],
        product: json["product"],
        amount: json["amount"],
        qty: json["qty"],
        transactionId: json["transaction_id"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "updated_at": updatedAt,
    "id": id,
    "product": product,
    "amount": amount,
    "qty": qty,
    "transaction_id": transactionId,
  };

  @override
  List<Object?> get props {
    return [createdAt, updatedAt, id, product, amount, qty, transactionId];
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

class PaymentProviderMeta extends Equatable {
  final String? timestamp;
  final String? requestId;

  const PaymentProviderMeta({this.timestamp, this.requestId});

  PaymentProviderMeta copyWith({String? timestamp, String? requestId}) =>
      PaymentProviderMeta(
        timestamp: timestamp ?? this.timestamp,
        requestId: requestId ?? this.requestId,
      );

  factory PaymentProviderMeta.fromJson(Map<String, dynamic> json) =>
      PaymentProviderMeta(
        timestamp: json["timestamp"],
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "requestId": requestId,
  };

  @override
  List<Object?> get props => [timestamp, requestId];
}

class PaymentRequstData {
  final int amount;
  final List<PaymentRequstDataItem> items;
  final String? note;
  final int expiredIn;

  PaymentRequstData({
    required this.amount,
    required this.items,
    required this.note,
    this.expiredIn = 30,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'note': note,
      'expired_in': expiredIn,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class PaymentRequstDataItem {
  final String product;
  final int qty;
  final int amount;

  PaymentRequstDataItem({
    required this.product,
    required this.qty,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'product': product, 'qty': qty, 'amount': amount};
  }
}
